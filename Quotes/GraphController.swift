import UIKit

class GraphController: UIViewController, UIScrollViewDelegate {

    // MARK: - UI
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var bidLabel: UILabel!
    @IBOutlet weak var askLabel: UILabel!
    @IBOutlet weak var spreadLabel: UILabel!
    @IBOutlet weak var graphView: ScrollableGraphView!
    @IBOutlet weak var frontGraphView: ScrollableGraphView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private var referencePointSpacing: CGFloat!
    
    //MARK - State
    let ticksListeningService = TicksListeningService()
    let storageService = StorageService()
    
    var symbolToListen: Symbol!
    var data = [Tick]()
    
    private var isScrollViewScrolling = false
    private var isScalingInProcess = false
    private var isFirstPointAdded = false
    private var isFollowModeEnabled = true
    
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        frontGraphView.delegate = self
        
        setupTicksListeningService()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        graphView.isHidden = false
        frontGraphView.isHidden = false
        
        updateHeader(with: storageService.lastTick(for: symbolToListen))
        
        ticksListeningService.startListening(socket: Socket.instance)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        graphView.isHidden = true
        frontGraphView.isHidden = true
        
        ticksListeningService.stopListening()
    }
    
    // MARK: - Update view
    private func addDataPoint(_ tick: Tick) {
        
        data.append(tick)
        updateHeader(with: tick)
        
        guard !isScrollViewScrolling else { return }
        guard !isScalingInProcess else { return }
        
        redrawGraph()
    }
    
    private func updateHeader(with tick: Tick) {
        symbolLabel.text = tick.symbol.description
        bidLabel.text = String(tick.bid)
        askLabel.text = String(tick.ask)
        spreadLabel.text = String(tick.spread)
    }
    
    private func redrawGraph() {
        
        let offset = isFollowModeEnabled ?  CGPoint(x: frontGraphView.contentSize.width  - frontGraphView.frame.width, y: 0) : frontGraphView.contentOffset

        graphView.set(data: data.map { $0.ask }, withLabels: [])
        frontGraphView.set(data: data.map { $0.bid }, withLabels: [])
        
        
        graphView.setContentOffset(offset, animated: false)
        frontGraphView.setContentOffset(offset, animated: false)
        
        if !isFirstPointAdded {
            activityIndicator.isHidden = true
            graphView.layoutSubviews()
            frontGraphView.layoutSubviews()
            isFirstPointAdded = !isFirstPointAdded
        }

    }
    
    @IBAction func onZoomInTap(_ sender: Any) {
        guard graphView.dataPointSpacing < 100 else { return }
        graphView.alpha = 0
        frontGraphView.alpha = 0
        activityIndicator.isHidden = false
        graphView.dataPointSpacing += 5
        frontGraphView.dataPointSpacing += 5
        
        self.activityIndicator.isHidden = true
        self.graphView.layoutSubviews()
        self.frontGraphView.layoutSubviews()
        self.redrawGraph()
        self.graphView.alpha = 1
        self.frontGraphView.alpha = 1

        
        
        
        
    }
    @IBAction func onZoomOutTap(_ sender: Any) {
        guard graphView.dataPointSpacing > 5 else { return }
        graphView.alpha = 0
        frontGraphView.alpha = 0
        activityIndicator.isHidden = false
        graphView.dataPointSpacing -= 5
        frontGraphView.dataPointSpacing -= 5
        
        self.activityIndicator.isHidden = true
        self.graphView.layoutSubviews()
        self.frontGraphView.layoutSubviews()
        self.redrawGraph()
        self.graphView.alpha = 1
        self.frontGraphView.alpha = 1
    }
    

    // MARK: - ScrollView delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        graphView.contentOffset = scrollView.contentOffset
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isScrollViewScrolling = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isScrollViewScrolling = false
    }
    
    // MARK: - View actions
    @IBAction func onSwitchTap(_ sender: Any) {
        isFollowModeEnabled = !isFollowModeEnabled
    }
    
    let throttler = Throttler(delay: 0.2)
    @IBAction func onPinch(_ sender: UIPinchGestureRecognizer) {
        
        let clamp = { min(max($0, CGFloat(2)), CGFloat(30)) }
        let updateGraph: (CGFloat) -> () = { [weak self] scale in
            if let `self` = self {
                debugPrint(self.referencePointSpacing)
                debugPrint(scale)
                let newSpacing = clamp(self.referencePointSpacing*(scale))
                self.graphView.dataPointSpacing = newSpacing
                self.frontGraphView.dataPointSpacing = newSpacing
                self.redrawGraph()
            }
        }
        
        switch sender.state {
        case .began:
            referencePointSpacing = frontGraphView.dataPointSpacing
            isScalingInProcess = true
        case .changed:
            throttler.throttle {
                updateGraph(sender.scale)
            }
        case .ended:
            referencePointSpacing = frontGraphView.dataPointSpacing
            isScalingInProcess = false
        default:
            isScalingInProcess = false
        }
        
    }
    
    
    // MARK: - Ticks Listening
    private func setupTicksListeningService() {
        
        ticksListeningService.onStatusChange { [weak self] status in
            if status == .active {
                if let `self` = self {
                    self.ticksListeningService.subscribe(to: [self.symbolToListen])
                }
            }
        }
        
        ticksListeningService.onTicks { [weak self] ticks in
            if let `self` = self {
                ticks.filter { $0.symbol == self.symbolToListen }.forEach { self.addDataPoint($0) }
            }
        }
    }

}
