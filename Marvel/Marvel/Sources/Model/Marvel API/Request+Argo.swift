import Foundation
import Alamofire
import Argo

typealias ArgoJSON = Argo.JSON

enum ErrorCode {
    case MissingAPIKey
    case MissingHash
    case MissingTimestamp
    case InvalidReferer
    case InvalidHash
    case MethodNotAllowed
    case Forbidden
    case FailedToParseJSON
    case UnknownFailure
}

struct RequestFailed: ErrorType {
    let code: ErrorCode
    let description: String
}

extension Request {
    
    func responseArgo<T: Decodable where T == T.DecodedType>(completionHandler: Response<T, RequestFailed> -> Void) -> Self {
        let responseSerializer = ResponseSerializer<T, RequestFailed> { request, response, data, error in
            guard error == .None else { return .Failure(self.unkownFailure(error!)) }
            
            let result = Request.JSONResponseSerializer(options: .AllowFragments).serializeResponse(request, response, data, error)
            let statusCode = response!.statusCode
            
            switch result {
            case .Success:
                do {
                    let json: AnyObject? = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions())
                    if let j = json {
                        switch statusCode {
                        case 200:
                            let thing: Decoded<T> = T.decode(ArgoJSON.parse(j))
                            return .Success(thing.value!)
                        default:
                            return .Failure(self.extractErrorFromJSON(statusCode, json: j, data: data!))
                        }
                    } else {
                        return .Failure(self.failedToParseJSON(data!))
                    }
                } catch {
                    return .Failure(self.failedToParseJSON(data!))
                }
            case .Failure(let error):
                return .Failure(self.unkownFailure(error))
            }
        }
        
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
    
    private func extractErrorFromJSON(statusCode: Int, json: AnyObject, data: NSData) -> RequestFailed {
        guard let errorCode = json["code"] as? String, errorMessage = json["message"] as? String else {
            return unkownFailure(data)
        }
        
        switch statusCode {
        case 401 where errorCode == "Invalid Referer":
            return serverError(.InvalidReferer, string: errorMessage)
        case 401 where errorCode == "Invalid Hash":
            return serverError(.InvalidHash, string: errorMessage)
        case 403 where errorCode == "Forbidden":
            return serverError(.Forbidden, string: errorMessage)
        case 405 where errorCode == "Method Not Allowed":
            return serverError(.MethodNotAllowed, string: errorMessage)
        case 409 where errorCode == "Missing Timestamp":
            return serverError(.MissingTimestamp, string: errorMessage)
        case 409 where errorCode == "Missing Hash":
            return serverError(.MissingHash, string: errorMessage)
        case 409 where errorCode == "Missing API Key":
            return serverError(.MissingAPIKey, string: errorMessage)
        default:
            return unkownFailure(data)
        }
    }
    
    private func serverError(code: ErrorCode, string: String) -> RequestFailed {
        return RequestFailed(code: code, description: "\(string)")
    }
    
    private func failedToParseJSON(data: NSData) -> RequestFailed {
        return RequestFailed(code: .FailedToParseJSON, description: "Failed to parse JSON response: \(String(data: data, encoding: NSUTF8StringEncoding))")
    }
    
    private func unkownFailure(data: NSData) -> RequestFailed {
        return RequestFailed(code: .UnknownFailure, description: "\(String(data: data, encoding: NSUTF8StringEncoding))")
    }
    
    private func unkownFailure(error: NSError) -> RequestFailed {
        return RequestFailed(code: .UnknownFailure, description: "\(error.localizedDescription)")
    }
}
