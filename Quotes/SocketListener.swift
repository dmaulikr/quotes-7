import Foundation


enum SocketListenerStatus {
    case wait, active
}


/* 
    Sub for Socket.
*/
protocol SocketListener: class {
    weak var socket: Socket? { get set }
    var status: SocketListenerStatus { get set }
    var id: String { get }
    
    func socketDidConnected()
    func socketDidDisconnected(error: Error?)
    func socketDidReceivedMessage(message: String)
    
    func startListening(socket: Socket)
    func stopListening()
}


/* 
    Default implementation.
*/
extension SocketListener {
    var id: String { return UUID().uuidString }
    
    func startListening(socket: Socket) {
        self.socket = socket
        if socket.isConnected { status = .active }
        socket.addListener(self)
    }
    func stopListening() {
        socket?.removeListener(self)
        status = .wait
        socket = nil
    }

    func socketDidConnected() {
        status = .active
    }
    func socketDidDisconnected(error: Error?) {
        status = .wait
    }
}
