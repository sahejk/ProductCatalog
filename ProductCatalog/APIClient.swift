import Foundation
import Alamofire
class APIClient {
    class func getResponseJSON(endpoint: String, method: HTTPMethod, successHandler: @escaping(AnyObject) -> Void, errorHandler: @escaping(NSError) -> (Void)) {
        Alamofire.request(URL(string: endpoint)!, method: method)
        .validate()
        .responseJSON { response in
            print(response.request ?? "")
            print(response.response ?? "")
            print(response.data ?? "")
            print(response.result)
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                successHandler(JSON as AnyObject)
            } else {
                errorHandler(response.error as! NSError)
            }

        }
    }
}
