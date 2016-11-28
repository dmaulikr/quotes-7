import Starscream


/* 
    Wrapper class for Starscream socket with added Pub/Sub functionality 
*/
class Socket: WebSocketDelegate {
    
    /* Singleton */
    static let instance = Socket(url: Host.production.url)
    
    private let socket: WebSocket
    
    private var listeners = [SocketListener]()
    
    func addListener(_ listener: SocketListener) {
        listeners.append(listener)
    }
    func removeListener(_ listener: SocketListener) {
        listeners = listeners.filter { $0.id == listener.id }
    }
    
    private init(url: URL) {
        self.socket = WebSocket(url: url)
        socket.delegate = self
    }
    
    var isConnected: Bool { return socket.isConnected }
    
    func connect() {
        socket.connect()
    }
    
    func disconnect() {
        socket.disconnect()
    }
    
    func send(request: CustomStringConvertible) {
        socket.write(string: request.description)
    }
    
    func websocketDidConnect(socket: WebSocket) {
        listeners.forEach { $0.socketDidConnected() }
    }
    
    func websocketDidDisconnect(socket: WebSocket, error: NSError?) {
        /* Simple failover mechanism */
        if error != nil { DispatchQueue.main.asyncAfter(deadline: .now() + 1) { self.connect(); } }
        listeners.forEach { $0.socketDidDisconnected(error: error) }
    }
    
    func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        listeners.forEach { $0.socketDidReceivedMessage(message: text) }
    }
    
    func websocketDidReceiveData(socket: WebSocket, data: Data) {
        assertionFailure("Socket should't write any binary")
    }
}
