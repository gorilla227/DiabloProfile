//
//  Skill+CoreDataProperties.swift
//  DiabloProfile
//
//  Created by Andy on 16/9/15.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import Foundation
import CoreData


extension Skill {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Skill> {
        return NSFetchRequest<Skill>(entityName: "Skill");
    }

    @NSManaged public var categorySlug: String?
    @NSManaged public var flavor: String?
    @NSManaged public var icon: Data?
    @NSManaged public var iconURL: String?
    @NSManaged public var heroA: Hero?
    @NSManaged public var heroP: Hero?
    @NSManaged public var rune: Rune?

}
