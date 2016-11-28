import Foundation
final class Throttler {
    let delay: TimeInterval
    
    private var lastFireTime: DispatchTime
    
    init(delay: TimeInterval) {
        assert(delay >= 0, "Throttler can't have negative delay")
        
        self.delay = delay
        self.lastFireTime = DispatchTime.now() - delay
    }
    
    func throttle(_ closure: () -> ()) {
        let now = DispatchTime.now()
        let when = lastFireTime + delay
        if now >= when {
            fire(closure)
        }
    }
    
    private func fire(_ closure: () -> ()) {
        lastFireTime = DispatchTime.now()
        closure()
    }
}
