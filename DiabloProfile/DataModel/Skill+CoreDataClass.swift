//
//  Skill+CoreDataClass.swift
//  DiabloProfile
//
//  Created by Andy on 16/9/15.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import Foundation
import CoreData


public class Skill: Spell {
    
    // Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    override init(dictionary: [String : Any], entityName: String, context: NSManagedObjectContext) {
        super.init(dictionary: dictionary, entityName: entityName, context: context)
        
        if let categorySlug = dictionary[Keys.CategorySlug] as? String {
            self.categorySlug = categorySlug
        }
        
        if let flavor = dictionary[Keys.Flavor] as? String {
            self.flavor = flavor
        }
        
        if let iconURL = dictionary[Keys.IconURL] as? String {
            self.iconURL = iconURL
        }
        
        if let icon = dictionary[Keys.Icon] as? Data {
            self.icon = icon
        }
        
        if let heroA = dictionary[Keys.HeroOfActive] as? Hero {
            self.heroA = heroA
        }
        
        if let heroP = dictionary[Keys.HeroOfPassive] as? Hero {
            self.heroP = heroP
        }
        
        if let runeDict = dictionary[Keys.Rune] as? [String: AnyObject] {
            let rune = Rune(dictionary: runeDict, entityName: "Rune", context: context)
            self.rune = rune
        }
    }
    
    func skillIconImageURL() -> URL? {
        if let iconURL = iconURL {
            return URL(string: BlizzardAPI.SkillIconURLComponents.Head + iconURL + BlizzardAPI.SkillIconURLComponents.Tail)
        } else {
            return nil
        }
    }
}

extension Skill {
    struct Keys {
        static let EntityName = "Skill"
        static let CategorySlug = "categorySlug"
        static let Flavor = "flavor"
        static let IconURL = "iconURL"
        static let Icon = "icon"
        static let Rune = "rune"
        static let HeroOfActive = "heroA"
        static let HeroOfPassive = "heroP"
    }
}
