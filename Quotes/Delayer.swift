import Foundation

final class Delayer {
    private let queue: DispatchQueue
    private let delayTime: TimeInterval
    
    init(delay: TimeInterval, queue: DispatchQueue = DispatchQueue.main ) {
        assert(delay >= 0, "Delayer can't have negative delay")
        
        self.delayTime = delay
        self.queue = queue
    }
    
    func delay(_ closure: @escaping () -> ()) {
        if delayTime > 0 {
            queue.asyncAfter(deadline: .now() + delayTime) {
                closure()
            }
        } else {
            closure()
        }
    }
}
