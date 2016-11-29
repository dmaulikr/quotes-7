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
    
    //MARK - State
    var symbolToListen: Symbol!
    
    /*
        Data points for graph.
        Last point is also displayed on header.
    */
    var data = [Tick]()
    
    private let ticksListeningService = TicksListeningService()
    private let storageService = StorageService()
    
    private var isScrollViewScrolling = false
    private var isFirstPointAdded = false
    private var isFollowModeEnabled = true
    
    private let spacingStep: CGFloat = 5
    private let maxSpacing: CGFloat = 80
    private let minSpacing: CGFloat = 5
    

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
    
    
    // MARK: - Update view
    private func addDataPoint(_ tick: Tick) {
        
        data.append(tick)
        updateHeader(with: tick)
        
        guard !isScrollViewScrolling else { return }
        
        redrawGraph()
    }
    
    private func updateHeader(with tick: Tick) {
        symbolLabel.text = tick.symbol.description
        bidLabel.text = String(tick.bid)
        askLabel.text = String(tick.ask)
        spreadLabel.text = String(tick.spread)
    }
    
    private func redrawGraph() {
        
        let contentExceedsFrame = frontGraphView.contentSize.width > frontGraphView.frame.width
        let offset = isFollowModeEnabled && contentExceedsFrame ?  CGPoint(x: frontGraphView.contentSize.width  - frontGraphView.frame.width, y: 0) : frontGraphView.contentOffset

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
    
    @IBAction func onZoomInTap(_ sender: Any) {
        guard graphView.dataPointSpacing < maxSpacing else { return }
        
        graphView.dataPointSpacing += spacingStep
        frontGraphView.dataPointSpacing += spacingStep
        
        redrawGraph()
    }
    
    @IBAction func onZoomOutTap(_ sender: Any) {
        guard graphView.dataPointSpacing > minSpacing else { return }
        
        graphView.dataPointSpacing -= spacingStep
        frontGraphView.dataPointSpacing -= spacingStep
        
        redrawGraph()
    }
    
}
