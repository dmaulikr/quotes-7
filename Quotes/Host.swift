import Foundation


/*
    Host is suitable for host switching.
*/
enum Host: String {
    case production = "wss://quotes.exness.com:18400/"
    
    var url: URL {
        return URL(string: self.rawValue)!
    }
}
