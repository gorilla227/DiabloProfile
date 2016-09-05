//
//  ItemSet.swift
//  DiabloProfile
//
//  Created by Andy Xu on 8/29/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import Foundation
import CoreData


class ItemSet: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
        super.init(entity: entity, insertIntoManagedObjectContext: context)
    }
    
    init(dictionary: [String: AnyObject], context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entityForName(Keys.EntityName, inManagedObjectContext: context)!
        super.init(entity: entity, insertIntoManagedObjectContext: context)
        
        if let name = dictionary[Keys.Name] as? String {
            self.name = name
        }
        
        if let slug = dictionary[Keys.Slug] as? String {
            self.slug = slug
        }
        
        if let items = dictionary[Keys.Items] as? [[String: AnyObject]] {
            var basicItems = [BasicItem]()
            for itemDict in items {
                let item = BasicItem(dictionary: itemDict, context: context)
                basicItems.append(item)
            }
            self.items = NSSet(array: basicItems)
        }
        
        if let setBonus = dictionary[Keys.SetBonus] as? [[String: AnyObject]] {
            var setBonusArray = [SetBonus]()
            for setBonusDict in setBonus {
                let bonus = SetBonus(dictionary: setBonusDict, context: context)
                setBonusArray.append(bonus)
            }
            self.setBonus = NSOrderedSet(array: setBonusArray)
        }
        
        if let locale = dictionary[Keys.Locale] as? String {
            self.locale = locale
        }
    }
    
    class func fetchItemSet(slug: String?, locale: String?, context: NSManagedObjectContext) -> ItemSet? {
        if let slug = slug, locale = locale {
            let fetchRequest = NSFetchRequest(entityName: Keys.EntityName)
            fetchRequest.predicate = NSPredicate(format: "slug == %@ && locale == %@", slug, locale)
            do {
                let result = try context.executeFetchRequest(fetchRequest)
                if let itemSet = result.first as? ItemSet {
                    return itemSet
                }
            } catch {
                return nil
            }
        }
        return nil
    }
}

extension ItemSet {
    struct Keys {
        static let EntityName = "ItemSet"
        static let Name = "name"
        static let Slug = "slug"
        static let Items = "items"
        static let SetBonus = "setBonus"
        static let DetailItem = "detailItem"
        static let Locale = "locale"
    }
}