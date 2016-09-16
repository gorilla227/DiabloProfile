//
//  Spell+CoreDataProperties.swift
//  DiabloProfile
//
//  Created by Andy on 16/9/15.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import Foundation
import CoreData


extension Spell {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Spell> {
        return NSFetchRequest<Spell>(entityName: "Spell");
    }

    @NSManaged public var fullDescription: String?
    @NSManaged public var name: String?
    @NSManaged public var simpleDescription: String?
    @NSManaged public var slug: String?

}
