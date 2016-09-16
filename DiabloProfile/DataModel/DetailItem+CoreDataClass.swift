//
//  DetailItem+CoreDataClass.swift
//  DiabloProfile
//
//  Created by Andy on 16/9/15.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import Foundation
import CoreData


public class DetailItem: NSManagedObject {
    
    // Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(dictionary: [String: Any], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: Keys.EntityName, in: context)!
        super.init(entity: entity, insertInto: context)
        
        if let accountBound = dictionary[Keys.AccountBound] as? Bool {
            self.accountBound = NSNumber(value: accountBound as Bool)
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
        
        if let icon = dictionary[Keys.Icon] as? Data {
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
            self.typeTwoHanded = NSNumber(value: typeTwoHanded)
        }
        if let blockChance = dictionary[Keys.BlockChance] as? String {
            self.blockChance = blockChance
        }
        if let blockAmountMin = dictionary[Keys.BlockAmountMin] as? NSNumber {
            self.blockAmountMin = blockAmountMin
        }
        if let blockAmountMax = dictionary[Keys.BlockAmountMax] as? NSNumber {
            self.blockAmountMax = blockAmountMax
        }
        
        if let attributes = dictionary[Keys.Attributes] as? [[String: AnyObject]] {
            var itemAttributes = [ItemAttribute]()
            for attributeDict in attributes {
                let itemAttribute = ItemAttribute(dictionary: attributeDict, context: context)
                itemAttributes.append(itemAttribute)
            }
            self.attributes = NSOrderedSet(array: itemAttributes)
        }
        
        if let gems = dictionary[Keys.Gems] as? [[String: Any]] {
            var gemsArray = [Gem]()
            for gemDict in gems {
                let gem = Gem(dictionary: gemDict, context: context)
                gemsArray.append(gem)
            }
            self.gems = NSSet(array: gemsArray)
        }
        
        if var itemSetDict = dictionary[Keys.ItemSet] as? [String: Any] {
            itemSetDict[ItemSet.Keys.Locale] = dictionary[Keys.Locale]
            if let itemSet = ItemSet.fetchItemSet(itemSetDict[ItemSet.Keys.Slug] as? String, locale: itemSetDict[ItemSet.Keys.Locale] as? String, context: context) {
                self.itemSet = itemSet
            } else {
                self.itemSet = ItemSet(dictionary: itemSetDict, context: context)
            }
        }
    }
    
    // size = "small" or "large"
    func iconImageURL(_ size: String) -> URL? {
        if let iconKey = iconKey {
            return URL(string: BlizzardAPI.ItemIconURLComponents.Head + size + "/" + iconKey + BlizzardAPI.ItemIconURLComponents.Tail)
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
        static let ItemSet = "itemSet"
        static let BlockChance = "blockChance"
        static let BlockAmountMin = "blockAmountMin"
        static let BlockAmountMax = "blockAmountMax"
    }
}
