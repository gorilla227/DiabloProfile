//
//  BasicItem+CoreDataProperties.swift
//  DiabloProfile
//
//  Created by Andy on 16/9/15.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import Foundation
import CoreData


extension BasicItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BasicItem> {
        return NSFetchRequest<BasicItem>(entityName: "BasicItem");
    }

    @NSManaged public var displayColor: String?
    @NSManaged public var icon: Data?
    @NSManaged public var iconKey: String?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var setItemsEquipped: [String]?
    @NSManaged public var slot: String?
    @NSManaged public var tooltipParams: String?
    @NSManaged public var detailItem: DetailItem?
    @NSManaged public var gem: Gem?
    @NSManaged public var hero: Hero?
    @NSManaged public var set: ItemSet?

}
