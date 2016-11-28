import Foundation


enum TicksListeningServiceError: Error {
    case notConnected
}

/* 
    TicksListeningService notifies about ticks via `onTicks` callback.
    To start listening ticks call `subscribe` method.
*/
class TicksListeningService: SocketListener {
    weak var socket: Socket?
    var ticksParser = TicksParser()
    
    var status: SocketListenerStatus = .wait {
        didSet {
            statusChangeHandler?(status)
        }
    }
    
    var ticksHandler: (([Tick]) -> ())?
    var statusChangeHandler: ((SocketListenerStatus) -> ())?
    
    func socketDidReceivedMessage(message: String) {
        if let ticks = ticksParser.parse(message) {
            ticksHandler?(ticks)
        }
    }
    
    func onStatusChange(_ handler: @escaping (SocketListenerStatus) -> ()) {
        self.statusChangeHandler = handler
    }
    
    func onTicks(_ handler: @escaping ([Tick]) -> ()) {
        self.ticksHandler = handler
    }
    
    func subscribe(to symbols: [Symbol], completion: ((Error?) -> ())? = nil) {
        guard socket?.isConnected ?? false else {
            completion?(TicksListeningServiceError.notConnected)
            return
        }
        socket?.send(request: SubscribeRequest(to: symbols))
        completion?(nil)
    }
    
    func unsubscribe(from symbols: [Symbol], completion: ((Error?) -> ())? = nil) {
        guard socket?.isConnected ?? false else {
            completion?(TicksListeningServiceError.notConnected)
            return
        }
        socket?.send(request: UnsubscribeRequest(from: symbols))
        completion?(nil)
    }
}
