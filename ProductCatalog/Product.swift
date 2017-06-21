import Foundation

struct Product: Parsable {
    let productId: Int
    let productPrice: Int
    let productName: String

    
    init(dict: [String: Any]) throws {
        productId =  try "productId" <- dict
        productPrice = try "productPrice" <- dict
        productName = try "productName" <- dict

    }
}
