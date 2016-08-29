//
//  Gem.swift
//  DiabloProfile
//
//  Created by Andy Xu on 8/29/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import Foundation
import CoreData


class Gem: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String: AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName(Keys.EntityName, inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        if let isGem = dictionary[Keys.IsGem] as? Bool {
            self.isGem = NSNumber(bool: isGem)
        }
        
        if let isJewel = dictionary[Keys.IsJewel] as? Bool {
            self.isJewel = NSNumber(bool: isJewel)
        }
        
        if let jewelRank = dictionary[Keys.JewelRank] as? NSNumber {
            self.jewelRank = jewelRank
        }
        
        if let jewelSecondaryEffectUnlockRank = dictionary[Keys.JewelSecondaryEffectUnlockRank] as? NSNumber {
            self.jewelSecondaryEffectUnlockRank = jewelSecondaryEffectUnlockRank
        }
        
        if let attributes = dictionary[Keys.Attributes] as? [[String: AnyObject]] {
            var itemAttributes = [ItemAttribute]()
            for attributeDict in attributes {
                let itemAttribute = ItemAttribute(dictionary: attributeDict, context: context)
                itemAttributes.append(itemAttribute)
            }
            self.attributes = NSOrderedSet(array: itemAttributes)
        }
        
        if let basicItem = dictionary[Keys.BasicItem] as? [String: AnyObject] {
            self.basicItem = BasicItem(dictionary: basicItem, context: context)
        }
    }
}

extension Gem {
    struct Keys {
        static let EntityName = "Gem"
        static let IsGem = "isGem"
        static let IsJewel = "isJewel"
        static let JewelRank = "jewelRank"
        static let JewelSecondaryEffectUnlockRank = "jewelSecondaryEffectUnlockRank"
        static let Attributes = "attributes"
        static let BasicItem = "basicItem"
    }
}