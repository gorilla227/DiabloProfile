//
//  ItemSet+CoreDataProperties.swift
//  DiabloProfile
//
//  Created by Andy on 16/9/15.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import Foundation
import CoreData


extension ItemSet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemSet> {
        return NSFetchRequest<ItemSet>(entityName: "ItemSet");
    }

    @NSManaged public var locale: String?
    @NSManaged public var name: String?
    @NSManaged public var slug: String?
    @NSManaged public var detailItem: NSSet?
    @NSManaged public var items: NSSet?
    @NSManaged public var setBonus: NSOrderedSet?

}

// MARK: Generated accessors for detailItem
extension ItemSet {

    @objc(addDetailItemObject:)
    @NSManaged public func addToDetailItem(_ value: DetailItem)

    @objc(removeDetailItemObject:)
    @NSManaged public func removeFromDetailItem(_ value: DetailItem)

    @objc(addDetailItem:)
    @NSManaged public func addToDetailItem(_ values: NSSet)

    @objc(removeDetailItem:)
    @NSManaged public func removeFromDetailItem(_ values: NSSet)

}

// MARK: Generated accessors for items
extension ItemSet {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: BasicItem)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: BasicItem)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

// MARK: Generated accessors for setBonus
extension ItemSet {

    @objc(insertObject:inSetBonusAtIndex:)
    @NSManaged public func insertIntoSetBonus(_ value: SetBonus, at idx: Int)

    @objc(removeObjectFromSetBonusAtIndex:)
    @NSManaged public func removeFromSetBonus(at idx: Int)

    @objc(insertSetBonus:atIndexes:)
    @NSManaged public func insertIntoSetBonus(_ values: [SetBonus], at indexes: NSIndexSet)

    @objc(removeSetBonusAtIndexes:)
    @NSManaged public func removeFromSetBonus(at indexes: NSIndexSet)

    @objc(replaceObjectInSetBonusAtIndex:withObject:)
    @NSManaged public func replaceSetBonus(at idx: Int, with value: SetBonus)

    @objc(replaceSetBonusAtIndexes:withSetBonus:)
    @NSManaged public func replaceSetBonus(at indexes: NSIndexSet, with values: [SetBonus])

    @objc(addSetBonusObject:)
    @NSManaged public func addToSetBonus(_ value: SetBonus)

    @objc(removeSetBonusObject:)
    @NSManaged public func removeFromSetBonus(_ value: SetBonus)

    @objc(addSetBonus:)
    @NSManaged public func addToSetBonus(_ values: NSOrderedSet)

    @objc(removeSetBonus:)
    @NSManaged public func removeFromSetBonus(_ values: NSOrderedSet)

}
