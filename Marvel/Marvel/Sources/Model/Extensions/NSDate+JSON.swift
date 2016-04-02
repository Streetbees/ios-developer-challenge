import Foundation
import Argo
import Curry

extension NSDate: Decodable {
    
    public static func decode(json: JSON) -> Decoded<NSDate> {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        
        switch json {
        case let .String(s):
            if let converted = formatter.dateFromString(s) {
                return pure(converted)
            } else {
                fallthrough
            }
        default:
            return .typeMismatch("NSDate", actual: json)
        }
    }
    
}