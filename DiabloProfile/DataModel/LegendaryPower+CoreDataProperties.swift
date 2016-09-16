//
//  LegendaryPower+CoreDataProperties.swift
//  DiabloProfile
//
//  Created by Andy on 16/9/15.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import Foundation
import CoreData

extension LegendaryPower {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LegendaryPower> {
        return NSFetchRequest<LegendaryPower>(entityName: "LegendaryPower");
    }

    @NSManaged public var displayColor: String?
    @NSManaged public var icon: Data?
    @NSManaged public var iconKey: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var tooltipParams: String?
    @NSManaged public var attribute: NSSet?
    @NSManaged public var hero: Hero?

}

// MARK: Generated accessors for attribute
extension LegendaryPower {

    @objc(addAttributeObject:)
    @NSManaged public func addToAttribute(_ value: ItemAttribute)

    @objc(removeAttributeObject:)
    @NSManaged public func removeFromAttribute(_ value: ItemAttribute)

    @objc(addAttribute:)
    @NSManaged public func addToAttribute(_ values: NSSet)

    @objc(removeAttribute:)
    @NSManaged public func removeFromAttribute(_ values: NSSet)

}
