//
//  ItemAttribute+CoreDataProperties.swift
//  DiabloProfile
//
//  Created by Andy on 16/9/15.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import Foundation
import CoreData


extension ItemAttribute {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemAttribute> {
        return NSFetchRequest<ItemAttribute>(entityName: "ItemAttribute");
    }

    @NSManaged public var affixType: String?
    @NSManaged public var category: String?
    @NSManaged public var color: String?
    @NSManaged public var text: String?
    @NSManaged public var gem: Gem?
    @NSManaged public var item: DetailItem?
    @NSManaged public var legendaryPower: LegendaryPower?
    @NSManaged public var setBonus: SetBonus?

}
