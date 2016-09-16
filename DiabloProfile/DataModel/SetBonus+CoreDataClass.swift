//
//  SetBonus+CoreDataClass.swift
//  DiabloProfile
//
//  Created by Andy on 16/9/15.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import Foundation
import CoreData


public class SetBonus: NSManagedObject {
    
    // Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(dictionary: [String: AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: Keys.EntityName, in: context)!
        super.init(entity: entity, insertInto: context)
        
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