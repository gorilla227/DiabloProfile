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
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(dictionary: [String: Any], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: Keys.EntityName, in: context)!
        super.init(entity: entity, insertInto: context)
        
        if let isGem = dictionary[Keys.IsGem] as? Bool {
            self.isGem = NSNumber(value: isGem)
        }
        
        if let isJewel = dictionary[Keys.IsJewel] as? Bool {
            self.isJewel = NSNumber(value: isJewel)
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
        
        if let detailItem = dictionary[Keys.DetailItem] as? DetailItem {
            self.detailItem = detailItem
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
        static let DetailItem = "detailItem"
    }
}
