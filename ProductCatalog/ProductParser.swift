class ProductParser: ResponseToCollectionParser<Product> {
    
    override func parse(_ dictionary: [[String: AnyObject]]) -> [Product] {
        return dictionary.map{ return try! Product(dict: $0 ) }
    }
}
