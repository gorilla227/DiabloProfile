//
//  ItemAttribute.swift
//  DiabloProfile
//
//  Created by Andy Xu on 8/29/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import Foundation
import CoreData


class ItemAttribute: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(dictionary: [String: AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: Keys.EntityName, in: context)!
        super.init(entity: entity, insertInto: context)
        
        if let affixType = dictionary[Keys.AffixType] as? String {
            self.affixType = affixType
        }
        
        if let category = dictionary[Keys.Category] as? String {
            self.category = category
        }
        
        if let displayColor = dictionary[Keys.DisplayColor] as? String {
            self.color = displayColor
        }
        
        if let text = dictionary[Keys.Text] as? String {
            self.text = text
        }
        
        if let gem = dictionary[Keys.Gem] as? Gem {
            self.gem = gem
        }
        
        if let item = dictionary[Keys.Item] as? DetailItem {
            self.item = item
        }
        
        if let setBonus = dictionary[Keys.SetBonus] as? SetBonus {
            self.setBonus = setBonus
        }
    }
}

extension ItemAttribute {
    struct Keys {
        static let EntityName = "ItemAttribute"
        static let AffixType = "affixType"
        static let Category = "category"
        static let DisplayColor = "color"
        static let Text = "text"
        static let Gem = "gem"
        static let Item = "item"
        static let SetBonus = "setBonus"
    }
}
