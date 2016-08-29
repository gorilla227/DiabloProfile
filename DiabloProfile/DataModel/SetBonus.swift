//
//  SetBonus.swift
//  DiabloProfile
//
//  Created by Andy Xu on 8/29/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import Foundation
import CoreData


class SetBonus: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String: AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName(Keys.EntityName, inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        if let required = dictionary[Keys.Required] as? NSNumber {
            self.required = required
        }
        
        if let attributes = dictionary[Keys.Attributes] as? [[String: AnyObject]] {
            var itemAttributes = [ItemAttribute]()
            for attributeDict in attributes {
                let itemAttribute = ItemAttribute(dictionary: attributeDict, context: context)
                itemAttributes.append(itemAttribute)
            }
            self.attributes = NSSet(array: itemAttributes)
        }
        
        if let set = dictionary[Keys.Set] as? ItemSet {
            self.set = set
        }
    }
}

extension SetBonus {
    struct Keys {
        static let EntityName = "SetBonus"
        static let Required = "required"
        static let Attributes = "attributes"
        static let Set = "set"
    }
}