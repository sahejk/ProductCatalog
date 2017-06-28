//
//  Product+CoreDataProperties.swift
//  
//
//  Created by Sahej Kaur on 21/06/17.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData

extension CartProduct {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CartProduct> {
        return NSFetchRequest<Product>(entityName: "Product");
    }
    @NSManaged public var productId: Int32
}
