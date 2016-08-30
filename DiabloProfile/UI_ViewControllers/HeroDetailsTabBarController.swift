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
    var battleTag: String?
    var hero: Hero?
 
    let mainManagedObjectContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.mainManagedObjectContext
    }()
    
    lazy var privateManagedObjectContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let backgroundManagedObjectContext = appDelegate.backgroundManagedObjectContext
        let moc = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        moc.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        moc.parentContext = backgroundManagedObjectContext
        return moc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(mergeToMainManagedObjectContext(_:)), name: NSManagedObjectContextDidSaveNotification, object: privateManagedObjectContext)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(saveBackgroundManagedObjectContext(_:)), name: NSManagedObjectContextDidSaveNotification, object: mainManagedObjectContext)

        initializeHeroObject()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        print("HeroDetailsVC Disappear")
        
        if mainManagedObjectContext == hero?.managedObjectContext {
            AppDelegate.saveContext(mainManagedObjectContext)
        }
    }
    
    private func initializeHeroObject() {
        if let heroData = heroData {
            privateManagedObjectContext.performBlock({
                let hero = Hero(dictionary: heroData, context: self.privateManagedObjectContext)
                hero.battleTag = self.battleTag
                AppDelegate.performUIUpdatesOnMain({
                    self.hero = hero
                    self.navigationItem.title = hero.name
                    self.navigationItem.rightBarButtonItem = self.addToCollectionButton
                    self.addToCollectionButton.enabled = !self.isHeroExistedInCollection()
                    
                    if let detailsVC = self.selectedViewController as? HeroDetailsVC {
                        detailsVC.loadData(hero)
                    }
                })
            })
        } else {
            if let hero = self.hero {
                navigationItem.title = hero.name
                navigationItem.rightBarButtonItem = removeButton
            }
        }
    }
    
    private func isHeroExistedInCollection() -> Bool {
        if let hero = hero, let id = hero.id {
            let fetchRequest = NSFetchRequest(entityName: Hero.Keys.EntityName)
            fetchRequest.predicate = NSPredicate(format: "\(Hero.Keys.ID) == %@", id)
            
            var error: NSError?
            let numOfExistedObject = mainManagedObjectContext.countForFetchRequest(fetchRequest, error: &error)
            return numOfExistedObject > 0
        }
        return false
    }
    
    func mergeToMainManagedObjectContext(notification: NSNotification) {
        mainManagedObjectContext.mergeChangesFromContextDidSaveNotification(notification)
        print("mergeToMainManagedObjectContext")
        
        AppDelegate.performUIUpdatesOnMain {
            self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func saveBackgroundManagedObjectContext(notification: NSNotification) {
        if let moc = notification.object as? NSManagedObjectContext, let parentMOC = moc.parentContext {
            AppDelegate.saveContext(parentMOC)
            print("Save backgroundManagedObjectContext from HeroDetailsVC")
        }
    }
    
    /*
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func addToCollectionButtonOnClicked(sender: AnyObject) {
        AppDelegate.saveContext(privateManagedObjectContext)
    }
    
    @IBAction func removeButtonOnClicked(sender: AnyObject) {
        mainManagedObjectContext.deleteObject(hero!)
        AppDelegate.saveContext(mainManagedObjectContext)
        AppDelegate.performUIUpdatesOnMain {
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
}