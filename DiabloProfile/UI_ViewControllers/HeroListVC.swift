//
//  HeroListVC.swift
//  DiabloProfile
//
//  Created by Andy Xu on 8/15/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import UIKit
import CoreData

class HeroListVC: UITableViewController {
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!

    lazy var mainManagedObjectContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.mainManagedObjectContext
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: Hero.Keys.EntityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: Hero.Keys.BattleTag, ascending: true), NSSortDescriptor(key: Hero.Keys.Level, ascending: false)]
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.mainManagedObjectContext, sectionNameKeyPath: Hero.Keys.BattleTag, cacheName: nil)
        
        frc.delegate = self
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingIndicator.center = tableView.center
        tableView.addSubview(loadingIndicator)
        
        if let uiStrings = AppDelegate.uiStrings(locale: nil), let heroListTitle = uiStrings["heroListTitle"] as? String {
            navigationItem.title = heroListTitle
        }

        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Load local hero list failed")
        }
    }

    private func configureCell(cell: UITableViewCell, hero: Hero) {
        cell.textLabel?.text = hero.name
        if let level = hero.level,
            let heroClassKey = hero.heroClass,
            let gameData = AppDelegate.gameData(locale: hero.locale), let heroClasses = gameData["class"] as? [String: [String: AnyObject]],
            let heroClass = heroClasses[heroClassKey],
            let heroClassName = heroClass["name"] {
            
            cell.detailTextLabel?.text = "\(level) \(heroClassName)"
            
            if let classIconImagePath = hero.classIconImagePath() {
                cell.imageView?.image = UIImage(named: classIconImagePath)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let section = fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
        return section.numberOfObjects ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HeroCell", forIndexPath: indexPath)
        if let hero = fetchedResultsController.objectAtIndexPath(indexPath) as? Hero {
            configureCell(cell, hero: hero)
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let hero = fetchedResultsController.objectAtIndexPath(indexPath) as? Hero {
            if let lastUpdated = hero.lastUpdated?.doubleValue {
                loadingIndicator.startAnimating()
                
                BlizzardAPI.requestHeroProfile(hero.region!, locale: hero.locale!, battleTag: hero.battleTag!, heroId: hero.id!, completion: { (result, error) in
                    guard error == nil && result != nil else {
                        if let errorInfo = error?.userInfo[NSLocalizedDescriptionKey] as? [String: String] {
                            let warning = UIAlertController(title: errorInfo[BlizzardAPI.ResponseKeys.ErrorCode], message: errorInfo[BlizzardAPI.ResponseKeys.ErrorReason], preferredStyle: .Alert)
                            let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                            warning.addAction(okAction)
                            AppDelegate.performUIUpdatesOnMain({
                                self.loadingIndicator.stopAnimating()
                                self.presentViewController(warning, animated: true, completion: nil)
                            })
                        }
                        return
                    }
                    
                    if let newLastUpdated = result![Hero.Keys.LastUpdated] as? NSNumber {
                        if newLastUpdated.doubleValue != lastUpdated {
                            print("Update Offline Data")
                            // Update Offline Data
                            self.mainManagedObjectContext.performBlock({
                                self.mainManagedObjectContext.deleteObject(hero)
                                let newHero = Hero(dictionary: result!, context: self.mainManagedObjectContext)
                                AppDelegate.saveContext(self.mainManagedObjectContext)
                                AppDelegate.performUIUpdatesOnMain({
                                    self.loadingIndicator.stopAnimating()
                                    self.performSegueWithIdentifier("ViewHeroDetailsSegue", sender: newHero)
                                })
                            })
                        } else {
                            print("Offline Data was Up-to-Dated")
                            AppDelegate.performUIUpdatesOnMain({
                                self.loadingIndicator.stopAnimating()
                                self.performSegueWithIdentifier("ViewHeroDetailsSegue", sender: hero)
                            })
                        }
                    }
                })
            }
        }
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
        return section.name
    }

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            if let hero = fetchedResultsController.objectAtIndexPath(indexPath) as? Hero {
                mainManagedObjectContext.deleteObject(hero)
                AppDelegate.saveContext(mainManagedObjectContext)
            }
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ViewHeroDetailsSegue" {
            let heroDetialsVC = segue.destinationViewController as! HeroDetailsTabBarController
            heroDetialsVC.hero = sender as? Hero
        }
    }

}

extension HeroListVC: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Automatic)
        case .Move:
            break
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        case .Delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Update:
            tableView.reloadSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Automatic)
        case .Move:
            break
        }
    }
}