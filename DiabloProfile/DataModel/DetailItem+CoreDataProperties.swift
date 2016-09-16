//
//  DetailItem+CoreDataProperties.swift
//  DiabloProfile
//
//  Created by Andy on 16/9/15.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import Foundation
import CoreData


extension DetailItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DetailItem> {
        return NSFetchRequest<DetailItem>(entityName: "DetailItem");
    }

    @NSManaged public var accountBound: NSNumber?
    @NSManaged public var armor: NSNumber?
    @NSManaged public var attacksPerSecond: NSNumber?
    @NSManaged public var attacksPerSecondText: String?
    @NSManaged public var blockAmountMax: NSNumber?
    @NSManaged public var blockAmountMin: NSNumber?
    @NSManaged public var blockChance: String?
    @NSManaged public var damageRange: String?
    @NSManaged public var displayColor: String?
    @NSManaged public var dps: NSNumber?
    @NSManaged public var elementalType: String?
    @NSManaged public var flavor: String?
    @NSManaged public var icon: Data?
    @NSManaged public var iconKey: String?
    @NSManaged public var id: String?
    @NSManaged public var itemLevel: NSNumber?
    @NSManaged public var locale: String?
    @NSManaged public var name: String?
    @NSManaged public var requiredLevel: NSNumber?
    @NSManaged public var setItemsEquipped: [String]?
    @NSManaged public var tooltipParams: String?
    @NSManaged public var typeID: String?
    @NSManaged public var typeName: String?
    @NSManaged public var typeTwoHanded: NSNumber?
    @NSManaged public var attributes: NSOrderedSet?
    @NSManaged public var basicItem: BasicItem?
    @NSManaged public var gems: NSSet?
    @NSManaged public var itemSet: ItemSet?

}

// MARK: Generated accessors for attributes
extension DetailItem {

    @objc(insertObject:inAttributesAtIndex:)
    @NSManaged public func insertIntoAttributes(_ value: ItemAttribute, at idx: Int)

    @objc(removeObjectFromAttributesAtIndex:)
    @NSManaged public func removeFromAttributes(at idx: Int)

    @objc(insertAttributes:atIndexes:)
    @NSManaged public func insertIntoAttributes(_ values: [ItemAttribute], at indexes: NSIndexSet)

    @objc(removeAttributesAtIndexes:)
    @NSManaged public func removeFromAttributes(at indexes: NSIndexSet)

    @objc(replaceObjectInAttributesAtIndex:withObject:)
    @NSManaged public func replaceAttributes(at idx: Int, with value: ItemAttribute)

    @objc(replaceAttributesAtIndexes:withAttributes:)
    @NSManaged public func replaceAttributes(at indexes: NSIndexSet, with values: [ItemAttribute])

    @objc(addAttributesObject:)
    @NSManaged public func addToAttributes(_ value: ItemAttribute)

    @objc(removeAttributesObject:)
    @NSManaged public func removeFromAttributes(_ value: ItemAttribute)

    @objc(addAttributes:)
    @NSManaged public func addToAttributes(_ values: NSOrderedSet)

    @objc(removeAttributes:)
    @NSManaged public func removeFromAttributes(_ values: NSOrderedSet)

}

// MARK: Generated accessors for gems
extension DetailItem {

    @objc(addGemsObject:)
    @NSManaged public func addToGems(_ value: Gem)

    @objc(removeGemsObject:)
    @NSManaged public func removeFromGems(_ value: Gem)

    @objc(addGems:)
    @NSManaged public func addToGems(_ values: NSSet)

    @objc(removeGems:)
    @NSManaged public func removeFromGems(_ values: NSSet)

}
