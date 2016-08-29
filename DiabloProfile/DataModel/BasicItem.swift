//
//  BasicItem.swift
//  DiabloProfile
//
//  Created by Andy Xu on 8/29/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import Foundation
import CoreData


class BasicItem: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }

    init(dictionary: [String: AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName(Keys.EntityName, inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        if let id = dictionary[Keys.ID] as? String {
            self.id = id
        }
        
        if let name = dictionary[Keys.Name] as? String {
            self.name = name
        }
        
        if let displayColor = dictionary[Keys.DisplayColor] as? String {
            self.displayColor = displayColor
        }
        
        if let iconKey = dictionary[Keys.IconKey] as? String {
            self.iconKey = iconKey
        }
        
        if let icon = dictionary[Keys.Icon] as? NSData {
            self.icon = icon
        }
        
        if let setItemsEquipped = dictionary[Keys.SetItemsEquipped] as? [String] {
            self.setItemsEquipped = setItemsEquipped
        }
        
        if let slot = dictionary[Keys.Slot] as? String {
            self.slot = slot
        }
        
        if let tooltipParams = dictionary[Keys.ToolTipParams] as? String {
            self.tooltipParams = tooltipParams
        }
        
        if let detailItem = dictionary[Keys.DetailItem] as? DetailItem {
            self.detailItem = detailItem
        }
        
        if let gem = dictionary[Keys.Gem] as? Gem {
            self.gem = gem
        }
        
        if let hero = dictionary[Keys.Hero] as? Hero {
            self.hero = hero
        }
        
        if let set = dictionary[Keys.Set] as? Set {
            self.set = set
        }
    }
    
    // size = "small" or "large"
    func iconImageURL(size: String) -> NSURL? {
        if let iconKey = iconKey {
            return NSURL(string: BlizzardAPI.ItemIconURLComponents.Head + size + "/" + iconKey + BlizzardAPI.ItemIconURLComponents.Tail)
        } else {
            return nil
        }
    }
}

extension BasicItem {
    struct Keys {
        static let EntityName = "BasicItem"
        static let DisplayColor = "displayColor"
        static let Icon = "icon"
        static let IconKey = "iconKey"
        static let ID = "id"
        static let Name = "name"
        static let SetItemsEquipped = "setItemsEquipped"
        static let Slot = "slot"
        static let ToolTipParams = "toolTipParams"
        static let DetailItem = "detailItem"
        static let Gem = "gem"
        static let Hero = "hero"
        static let Set = "set"
    }
}