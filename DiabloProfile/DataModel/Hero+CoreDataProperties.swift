//
//  Hero+CoreDataProperties.swift
//  DiabloProfile
//
//  Created by Andy on 16/9/15.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import Foundation
import CoreData

extension Hero {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Hero> {
        return NSFetchRequest<Hero>(entityName: "Hero");
    }

    @NSManaged public var battleTag: String?
    @NSManaged public var dead: NSNumber?
    @NSManaged public var elitesKills: NSNumber?
    @NSManaged public var gender: NSNumber?
    @NSManaged public var hardcore: NSNumber?
    @NSManaged public var heroClass: String?
    @NSManaged public var id: NSNumber?
    @NSManaged public var lastUpdated: NSNumber?
    @NSManaged public var level: NSNumber?
    @NSManaged public var locale: String?
    @NSManaged public var name: String?
    @NSManaged public var paragonLevel: NSNumber?
    @NSManaged public var region: String?
    @NSManaged public var seasonal: NSNumber?
    @NSManaged public var seasonCreated: NSNumber?
    @NSManaged public var activeSkills: NSOrderedSet?
    @NSManaged public var items: NSSet?
    @NSManaged public var legendaryPowers: NSOrderedSet?
    @NSManaged public var passiveSkills: NSOrderedSet?
    @NSManaged public var stats: Stats?

}

// MARK: Generated accessors for activeSkills
extension Hero {

    @objc(insertObject:inActiveSkillsAtIndex:)
    @NSManaged public func insertIntoActiveSkills(_ value: Skill, at idx: Int)

    @objc(removeObjectFromActiveSkillsAtIndex:)
    @NSManaged public func removeFromActiveSkills(at idx: Int)

    @objc(insertActiveSkills:atIndexes:)
    @NSManaged public func insertIntoActiveSkills(_ values: [Skill], at indexes: NSIndexSet)

    @objc(removeActiveSkillsAtIndexes:)
    @NSManaged public func removeFromActiveSkills(at indexes: NSIndexSet)

    @objc(replaceObjectInActiveSkillsAtIndex:withObject:)
    @NSManaged public func replaceActiveSkills(at idx: Int, with value: Skill)

    @objc(replaceActiveSkillsAtIndexes:withActiveSkills:)
    @NSManaged public func replaceActiveSkills(at indexes: NSIndexSet, with values: [Skill])

    @objc(addActiveSkillsObject:)
    @NSManaged public func addToActiveSkills(_ value: Skill)

    @objc(removeActiveSkillsObject:)
    @NSManaged public func removeFromActiveSkills(_ value: Skill)

    @objc(addActiveSkills:)
    @NSManaged public func addToActiveSkills(_ values: NSOrderedSet)

    @objc(removeActiveSkills:)
    @NSManaged public func removeFromActiveSkills(_ values: NSOrderedSet)

}

// MARK: Generated accessors for items
extension Hero {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: BasicItem)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: BasicItem)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

// MARK: Generated accessors for legendaryPowers
extension Hero {

    @objc(insertObject:inLegendaryPowersAtIndex:)
    @NSManaged public func insertIntoLegendaryPowers(_ value: LegendaryPower, at idx: Int)

    @objc(removeObjectFromLegendaryPowersAtIndex:)
    @NSManaged public func removeFromLegendaryPowers(at idx: Int)

    @objc(insertLegendaryPowers:atIndexes:)
    @NSManaged public func insertIntoLegendaryPowers(_ values: [LegendaryPower], at indexes: NSIndexSet)

    @objc(removeLegendaryPowersAtIndexes:)
    @NSManaged public func removeFromLegendaryPowers(at indexes: NSIndexSet)

    @objc(replaceObjectInLegendaryPowersAtIndex:withObject:)
    @NSManaged public func replaceLegendaryPowers(at idx: Int, with value: LegendaryPower)

    @objc(replaceLegendaryPowersAtIndexes:withLegendaryPowers:)
    @NSManaged public func replaceLegendaryPowers(at indexes: NSIndexSet, with values: [LegendaryPower])

    @objc(addLegendaryPowersObject:)
    @NSManaged public func addToLegendaryPowers(_ value: LegendaryPower)

    @objc(removeLegendaryPowersObject:)
    @NSManaged public func removeFromLegendaryPowers(_ value: LegendaryPower)

    @objc(addLegendaryPowers:)
    @NSManaged public func addToLegendaryPowers(_ values: NSOrderedSet)

    @objc(removeLegendaryPowers:)
    @NSManaged public func removeFromLegendaryPowers(_ values: NSOrderedSet)

}

// MARK: Generated accessors for passiveSkills
extension Hero {

    @objc(insertObject:inPassiveSkillsAtIndex:)
    @NSManaged public func insertIntoPassiveSkills(_ value: Skill, at idx: Int)

    @objc(removeObjectFromPassiveSkillsAtIndex:)
    @NSManaged public func removeFromPassiveSkills(at idx: Int)

    @objc(insertPassiveSkills:atIndexes:)
    @NSManaged public func insertIntoPassiveSkills(_ values: [Skill], at indexes: NSIndexSet)

    @objc(removePassiveSkillsAtIndexes:)
    @NSManaged public func removeFromPassiveSkills(at indexes: NSIndexSet)

    @objc(replaceObjectInPassiveSkillsAtIndex:withObject:)
    @NSManaged public func replacePassiveSkills(at idx: Int, with value: Skill)

    @objc(replacePassiveSkillsAtIndexes:withPassiveSkills:)
    @NSManaged public func replacePassiveSkills(at indexes: NSIndexSet, with values: [Skill])

    @objc(addPassiveSkillsObject:)
    @NSManaged public func addToPassiveSkills(_ value: Skill)

    @objc(removePassiveSkillsObject:)
    @NSManaged public func removeFromPassiveSkills(_ value: Skill)

    @objc(addPassiveSkills:)
    @NSManaged public func addToPassiveSkills(_ values: NSOrderedSet)

    @objc(removePassiveSkills:)
    @NSManaged public func removeFromPassiveSkills(_ values: NSOrderedSet)

}
