import Foundation

class ProductsRepository {
    func fetchProducts(pageNo: Int, successHandler: @escaping ([Product])->  Void, failureHandler: @escaping (_ error: NSError) -> Void) {
        APIClient.getResponseJSON(endpoint: "https://sahej-catalog.herokuapp.com/" + "products", method: .get, successHandler:{json in
            successHandler(ProductParser().parse(json as! [[String : AnyObject]]))
        }, errorHandler: {error in
            failureHandler(error)
            })
    }
}
