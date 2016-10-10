//
//  HeroDetailsTabBarController.swift
//  DiabloProfile
//
//  Created by Andy Xu on 8/29/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import UIKit
import CoreData

class HeroDetailsTabBarController: UITabBarController {
    @IBOutlet var addToCollectionButton: UIBarButtonItem!
    @IBOutlet var removeButton: UIBarButtonItem!

    var heroData: [String: AnyObject]?
    var hero: Hero?
 
    let mainManagedObjectContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.mainManagedObjectContext
    }()
    
    lazy var privateManagedObjectContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let backgroundManagedObjectContext = appDelegate.backgroundManagedObjectContext
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        moc.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        moc.parent = backgroundManagedObjectContext
        return moc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(mergeToMainManagedObjectContext(_:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: privateManagedObjectContext)
        NotificationCenter.default.addObserver(self, selector: #selector(saveBackgroundManagedObjectContext(_:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: mainManagedObjectContext)

        initializeHeroObject()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("HeroDetailsVC Disappear")
        
        if mainManagedObjectContext == hero?.managedObjectContext {
            AppDelegate.saveContext(mainManagedObjectContext)
        }
    }
    
    fileprivate func initializeHeroObject() {
        if let heroData = heroData {
            privateManagedObjectContext.perform({
                let hero = Hero(dictionary: heroData, context: self.privateManagedObjectContext)
                AppDelegate.performUIUpdatesOnMain({
                    self.hero = hero
                    self.navigationItem.title = hero.name?.uppercased() ?? ""
                    self.navigationItem.rightBarButtonItem = self.addToCollectionButton
                    self.addToCollectionButton.isEnabled = !self.isHeroExistedInCollection()
                    
                    self.initialChildViewControllers(hero)
                })
            })
        } else {
            if let hero = self.hero {
                navigationItem.title = hero.name?.uppercased() ?? ""
                navigationItem.rightBarButtonItem = removeButton
                
                initialChildViewControllers(hero)
            }
        }
    }
    
    func initialChildViewControllers(_ hero: Hero) {
        for childViewController in childViewControllers {
            if let heroDetailVC = childViewController as? HeroDetailsVC {
                heroDetailVC.initialViewController(hero.locale)
                if selectedViewController == heroDetailVC {
                    heroDetailVC.loadData(hero)
                }
            } else if let equipmentVC = childViewController as? EquipmentVC {
                equipmentVC.initialViewController(hero.locale)
                if selectedViewController == equipmentVC {
                    equipmentVC.loadData(hero)
                }
            } else if let skillVC = childViewController as? SkillListVC {
                skillVC.initialViewController(hero.locale)
                if selectedViewController == skillVC {
                    skillVC.loadData(hero)
                }
            }
        }
    }
    
    fileprivate func isHeroExistedInCollection() -> Bool {
        if let hero = hero, let id = hero.id {
            let fetchRequest = NSFetchRequest<Hero>(entityName: Hero.Keys.EntityName)
            fetchRequest.predicate = NSPredicate(format: "\(Hero.Keys.ID) == %@", id)
            
            do {
                let numOfExistedObject = try mainManagedObjectContext.count(for: fetchRequest)
                return numOfExistedObject > 0
            } catch {
                print("Fetch 'isHeroExistedInCollection' request failed")
                return false
            }
        }
        return false
    }
    
    func mergeToMainManagedObjectContext(_ notification: Notification) {
        mainManagedObjectContext.mergeChanges(fromContextDidSave: notification)
        print("mergeToMainManagedObjectContext")
        
        AppDelegate.performUIUpdatesOnMain {
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func saveBackgroundManagedObjectContext(_ notification: Notification) {
        if let moc = notification.object as? NSManagedObjectContext, let parentMOC = moc.parent {
            AppDelegate.saveContext(parentMOC)
            print("Save backgroundManagedObjectContext from HeroDetailsVC")
        }
    }
    
    
    // MARK: - IBActions
    @IBAction func addToCollectionButtonOnClicked(_ sender: AnyObject) {
        AppDelegate.saveContext(privateManagedObjectContext)
    }
    
    @IBAction func removeButtonOnClicked(_ sender: AnyObject) {
        mainManagedObjectContext.delete(hero!)
        AppDelegate.saveContext(mainManagedObjectContext)
        AppDelegate.performUIUpdatesOnMain {
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
}
