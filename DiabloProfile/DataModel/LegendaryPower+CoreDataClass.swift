//
//  LegendaryPower+CoreDataClass.swift
//  DiabloProfile
//
//  Created by Andy on 16/9/15.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import Foundation
import CoreData

@objc(LegendaryPower)
public class LegendaryPower: NSManagedObject {
    
    // Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(dictionary: [String: Any], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "LegendaryPower", in: context)!
        super.init(entity: entity, insertInto: context)
        
        if let id = dictionary[Keys.ID] as? String {
            self.id = id
        }
        if let name = dictionary[Keys.Name] as? String {
            self.name = name
        }
        if let displayColor = dictionary[Keys.DisplayColor] as? String {
            self.displayColor = displayColor
        }
        if let tooltipParams = dictionary[Keys.TooltipParams] as? String {
            self.tooltipParams = tooltipParams
        }
        if let iconKey = dictionary[Keys.IconKey] as? String {
            self.iconKey = iconKey
        }
        if let icon = dictionary[Keys.Icon] as? Data {
            self.icon = icon
        }
        if let hero = dictionary[Keys.Hero] as? Hero {
            self.hero = hero
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

extension LegendaryPower {
    struct Keys {
        static let ID = "id"
        static let DisplayColor = "displayColor"
        static let Name = "name"
        static let TooltipParams = "tooltipParams"
        static let IconKey = "iconKey"
        static let Icon = "icon"
        static let Attribute = "attribute"
        static let Hero = "hero"
    }
}
