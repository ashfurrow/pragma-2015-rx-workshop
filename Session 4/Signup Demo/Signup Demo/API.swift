import Moya
import RxSwift

enum MyAPI {
    case Image
}

extension MyAPI: MoyaTarget {
    var baseURL: NSURL {
        return NSURL(string: "https://static.ashfurrow.com")!
    }

    var path: String {
        switch self {
        case .Image:
            return "/pragma/image.jpg"
        }
    }

    var method: Moya.Method { return .GET }
    var parameters: [String: AnyObject]? { return nil }
    var sampleData: NSData { return NSData() }
}

let provider = RxMoyaProvider<MyAPI>()
