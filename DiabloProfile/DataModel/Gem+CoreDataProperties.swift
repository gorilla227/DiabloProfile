//
//  Gem+CoreDataProperties.swift
//  DiabloProfile
//
//  Created by Andy on 16/9/15.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import Foundation
import CoreData


extension Gem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Gem> {
        return NSFetchRequest<Gem>(entityName: "Gem");
    }

    @NSManaged public var isGem: NSNumber?
    @NSManaged public var isJewel: NSNumber?
    @NSManaged public var jewelRank: NSNumber?
    @NSManaged public var jewelSecondaryEffectUnlockRank: NSNumber?
    @NSManaged public var attributes: NSOrderedSet?
    @NSManaged public var basicItem: BasicItem?
    @NSManaged public var detailItem: DetailItem?

}

// MARK: Generated accessors for attributes
extension Gem {

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
