import Foundation
import Unbox


/* 
    Socket response models.
*/
struct TicksResponse {
    let ticks: [Tick]
}

struct SubscribeResponse {
    let ticksResponse: TicksResponse
}

struct UnsubscribeResponse {
    let ticksResponse: TicksResponse
}
