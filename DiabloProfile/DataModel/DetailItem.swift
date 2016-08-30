//
//  DetailItem.swift
//  DiabloProfile
//
//  Created by Andy Xu on 8/29/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import Foundation
import CoreData


class DetailItem: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String: AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName(Keys.EntityName, inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        if let accountBound = dictionary[Keys.AccountBound] as? Bool {
            self.accountBound = NSNumber(bool: accountBound)
        }
        
        if let armor = dictionary[Keys.Armor] as? NSNumber {
            self.armor = armor
        }
        
        if let attacksPerSecond = dictionary[Keys.AttacksPerSecond] as? NSNumber {
            self.attacksPerSecond = attacksPerSecond
        }
        
        if let attacksPerSecondText = dictionary[Keys.AttacksPerSecondText] as? String {
            self.attacksPerSecondText = attacksPerSecondText
        }
        
        if let damageRange = dictionary[Keys.DamageRange] as? String {
            self.damageRange = damageRange
        }
        
        if let displayColor = dictionary[Keys.DisplayColor] as? String {
            self.displayColor = displayColor
        }
        
        if let dps = dictionary[Keys.DPS] as? NSNumber {
            self.dps = dps
        }
        
        if let elementalType = dictionary[Keys.ElementalType] as? String {
            self.elementalType = elementalType
        }
        
        if let flavor = dictionary[Keys.Flavor] as? String {
            self.flavor = flavor
        }
        
        if let icon = dictionary[Keys.Icon] as? NSData {
            self.icon = icon
        }
        
        if let iconKey = dictionary[Keys.IconKey] as? String {
            self.iconKey = iconKey
        }
        
        if let id = dictionary[Keys.ID] as? String {
            self.id = id
        }
        
        if let itemLevel = dictionary[Keys.ItemLevel] as? NSNumber {
            self.itemLevel = itemLevel
        }
        
        if let locale = dictionary[Keys.Locale] as? String {
            self.locale = locale
        }
        
        if let name = dictionary[Keys.Name] as? String {
            self.name = name
        }
        
        if let requiredLevel = dictionary[Keys.RequiredLevel] as? NSNumber {
            self.requiredLevel = requiredLevel
        }
        
        if let setItemsEquipped = dictionary[Keys.SetItemsEquipped] as? [String] {
            self.setItemsEquipped = setItemsEquipped
        }
        
        if let tooltipParams = dictionary[Keys.TooltipParams] as? String {
            self.tooltipParams = tooltipParams
        }
        
        if let typeID = dictionary[Keys.TypeID] as? String {
            self.typeID = typeID
        }
        
        if let typeName = dictionary[Keys.TypeName] as? String {
            self.typeName = typeName
        }
        
        if let typeTwoHanded = dictionary[Keys.TypeTwoHanded] as? Bool {
            self.typeTwoHanded = NSNumber(bool: typeTwoHanded)
        }
        
        if let attributes = dictionary[Keys.Attributes] as? [[String: AnyObject]] {
            var itemAttributes = [ItemAttribute]()
            for attributeDict in attributes {
                let itemAttribute = ItemAttribute(dictionary: attributeDict, context: context)
                itemAttributes.append(itemAttribute)
            }
            self.attributes = NSSet(array: itemAttributes)
        }
        
        if let basicItem = dictionary[Keys.BasicItem] as? BasicItem {
            self.basicItem = basicItem
        }
        
        if let gems = dictionary[Keys.Gems] as? [[String: AnyObject]] {
            var gemsArray = [Gem]()
            for gemDict in gems {
                let gem = Gem(dictionary: gemDict, context: context)
                gemsArray.append(gem)
            }
            self.gems = NSSet(array: gemsArray)
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

extension DetailItem {
    struct Keys {
        static let EntityName = "DetailItem"
        static let AccountBound = "accountBound"
        static let Armor = "armor"
        static let AttacksPerSecond = "attacksPerSecond"
        static let AttacksPerSecondText = "attacksPerSecondText"
        static let DamageRange = "damageRange"
        static let DisplayColor = "displayColor"
        static let DPS = "dps"
        static let ElementalType = "elementalType"
        static let Flavor = "flavor"
        static let Icon = "icon"
        static let IconKey = "iconKey"
        static let ID = "id"
        static let ItemLevel = "itemLevel"
        static let Locale = "locale"
        static let Name = "name"
        static let RequiredLevel = "requiredLevel"
        static let SetItemsEquipped = "setItemsEquipped"
        static let TooltipParams = "tooltipParams"
        static let TypeID = "typeID"
        static let TypeName = "typeName"
        static let TypeTwoHanded = "typeTwoHanded"
        static let Attributes = "attributes"
        static let BasicItem = "basicItem"
        static let Gems = "gems"
    }
}