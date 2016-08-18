//
//  Skill.swift
//  DiabloProfile
//
//  Created by Andy Xu on 8/15/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import Foundation
import CoreData


class Skill: Spell {

// Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    override init(dictionary: [String : AnyObject], entityName: String, context: NSManagedObjectContext) {
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
        
        if let icon = dictionary[Keys.Icon] as? NSData {
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
    
    func skillIconImageURL() -> NSURL? {
        if let iconURL = iconURL {
            return NSURL(string: BlizzardAPI.SkillIconURLComponents.Head + iconURL + BlizzardAPI.SkillIconURLComponents.Tail)
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