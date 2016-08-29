//
//  Hero.swift
//  DiabloProfile
//
//  Created by Andy Xu on 8/15/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import Foundation
import CoreData


class Hero: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String: AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName(Keys.EntityName, inManagedObjectContext: context)!
        super.init(entity:entity, insertIntoManagedObjectContext: context)
        
        if let battleTag = dictionary[Keys.BattleTag] as? String {
            self.battleTag = battleTag
        }
        
        if let region = dictionary[Keys.Region] as? String {
            self.region = region
        }
        
        if let locale = dictionary[Keys.Locale] as? String {
            self.locale = locale
        }
        
        if let id = dictionary[Keys.ID] as? NSNumber {
            self.id = id
        }
        
        if let dead = dictionary[Keys.Dead] as? Bool {
            self.dead = NSNumber(bool: dead)
        }
        
        if let gender = dictionary[Keys.Gender] as? Bool {
            self.gender = NSNumber(bool: gender)
        }
        
        if let hardcore = dictionary[Keys.Hardcore] as? Bool {
            self.hardcore = NSNumber(bool: hardcore)
        }
        
        if let heroClass = dictionary[Keys.HeroClass] as? String {
            self.heroClass = heroClass
        }
        
        if let lastUpdated = dictionary[Keys.LastUpdated] as? NSNumber {
            self.lastUpdated = lastUpdated
        }
        
        if let level = dictionary[Keys.Level] as? NSNumber {
            self.level = level
        }
        
        if let name = dictionary[Keys.Name] as? String {
            self.name = name
        }
        
        if let paragonLevel = dictionary[Keys.ParagonLevel] as? NSNumber {
            self.paragonLevel = paragonLevel
        }
        
        if let seasonal = dictionary[Keys.Seasonal] as? Bool {
            self.seasonal = NSNumber(bool: seasonal)
        }
        
        if let seasonCreated = dictionary[Keys.SeasonCreated] as? NSNumber {
            self.seasonCreated = seasonCreated
        }
        
        if let activeSkills = dictionary[Keys.ActiveSkills] as? [[String: AnyObject]] {
            var skills = [Skill]()
            for skillDict in activeSkills {
                let skill = Skill(dictionary: skillDict, entityName: "Skill", context: context)
                skills.append(skill)
            }
            self.activeSkills = NSMutableOrderedSet(array: skills)
        }
        
        if let passiveSkills = dictionary[Keys.PassiveSkills] as? [[String: AnyObject]] {
            var skills = [Skill]()
            for skillDict in passiveSkills {
                let skill = Skill(dictionary: skillDict, entityName: "Skill", context: context)
                skills.append(skill)
            }
            self.passiveSkills = NSMutableOrderedSet(array: skills)
        }
        
        if let statsDict = dictionary[Keys.Stats] as? [String: AnyObject] {
            let stats = Stats(dictionary: statsDict, context: context)
            self.stats = stats
        }
        
        if let items = dictionary[Keys.Items] as? [[String: AnyObject]] {
            var basicItems = [BasicItem]()
            for itemDict in items {
                let basicItem = BasicItem(dictionary: itemDict, context: context)
                basicItems.append(basicItem)
            }
            self.items = NSSet(array: basicItems)
        }
    }
    
    class func titleBackgroundImagePath(classKey classKey: String, genderKey: String) -> String {
        let imageFilePath = "\(classKey)-\(genderKey)-background.jpg"
        return imageFilePath
    }
    
    func titleBackgroundImagePath() -> String? {
        if let classKey = heroClass, let gender = gender?.boolValue {
            let genderKey = gender ? "female" : "male"
            return Hero.titleBackgroundImagePath(classKey: classKey, genderKey: genderKey)
        } else {
            return nil
        }
    }
    
    class func classIconImagePath(classKey classKey: String, genderKey: String) -> String {
        let imageFilePath = "\(classKey)_\(genderKey).png"
        return imageFilePath
    }
    
    func classIconImagePath() -> String? {
        if let classKey = heroClass, let gender = gender?.boolValue {
            let genderKey = gender ? "female" : "male"
            return Hero.classIconImagePath(classKey: classKey, genderKey: genderKey)
        } else {
            return nil
        }
    }
}

extension Hero {
    struct Keys {
        static let EntityName = "Hero"
        static let Region = "region"
        static let Locale = "locale"
        static let BattleTag = "battleTag"
        static let ID = "id"
        static let Dead = "dead"
        static let Gender = "gender"
        static let Hardcore = "hardcore"
        static let HeroClass = "heroClass"
        static let LastUpdated = "lastUpdated"
        static let Level = "level"
        static let Name = "name"
        static let ParagonLevel = "paragonLevel"
        static let Seasonal = "seasonal"
        static let SeasonCreated = "seasonCreated"
        static let ActiveSkills = "activeSkills"
        static let PassiveSkills = "passiveSkills"
        static let Stats = "stats"
        static let Items = "items"
    }
}