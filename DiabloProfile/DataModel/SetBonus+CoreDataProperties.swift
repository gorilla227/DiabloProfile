//
//  SetBonus+CoreDataProperties.swift
//  DiabloProfile
//
//  Created by Andy on 16/9/15.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import Foundation
import CoreData


extension SetBonus {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SetBonus> {
        return NSFetchRequest<SetBonus>(entityName: "SetBonus");
    }

    @NSManaged public var required: NSNumber?
    @NSManaged public var attributes: NSSet?
    @NSManaged public var set: ItemSet?

}

// MARK: Generated accessors for attributes
extension SetBonus {

    @objc(addAttributesObject:)
    @NSManaged public func addToAttributes(_ value: ItemAttribute)

    @objc(removeAttributesObject:)
    @NSManaged public func removeFromAttributes(_ value: ItemAttribute)

    @objc(addAttributes:)
    @NSManaged public func addToAttributes(_ values: NSSet)

    @objc(removeAttributes:)
    @NSManaged public func removeFromAttributes(_ values: NSSet)

}
