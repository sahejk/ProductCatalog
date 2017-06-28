//
//  Cart+CoreDataProperties.swift
//  
//
//  Created by Sahej Kaur on 21/06/17.
//
//

import Foundation
import CoreData


extension Cart {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cart> {
        return NSFetchRequest<Cart>(entityName: "Cart");
    }

    @NSManaged public var cartId: Int32
    @NSManaged public var products: Product?

}
