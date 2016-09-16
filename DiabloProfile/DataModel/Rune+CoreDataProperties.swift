//
//  Rune+CoreDataProperties.swift
//  DiabloProfile
//
//  Created by Andy on 16/9/15.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import Foundation
import CoreData


extension Rune {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Rune> {
        return NSFetchRequest<Rune>(entityName: "Rune");
    }

    @NSManaged public var runeType: String?
    @NSManaged public var skill: Skill?

}
