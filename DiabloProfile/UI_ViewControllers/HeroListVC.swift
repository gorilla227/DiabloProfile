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

    lazy var mainManagedObjectContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.mainManagedObjectContext
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: Hero.Keys.EntityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: Hero.Keys.Level, ascending: false), NSSortDescriptor(key: Hero.Keys.ParagonLevel, ascending: false)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.mainManagedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        frc.delegate = self
        return frc
    }()
    
    let gameData = AppDelegate.gameData()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
            let gameData = gameData, let heroClasses = gameData["class"] as? [String: [String: AnyObject]],
            let heroClass = heroClasses[heroClassKey],
            let heroClassName = heroClass["name"] {
            
            cell.detailTextLabel?.text = "\(level) \(heroClassName)"
            
            if let gender = hero.gender?.boolValue {
                let genderKey = gender ? "female" : "male"
                cell.imageView?.image = classIconImage(heroClassKey, genderKey: genderKey)
            }
        }
    }
    
    private func classIconImage(classKey: String, genderKey: String) -> UIImage? {
        let imageFileName = "\(classKey)_\(genderKey).png"
        return UIImage(named: imageFileName)
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
            performSegueWithIdentifier("ViewHeroDetailsSegue", sender: hero)
        }
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

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ViewHeroDetailsSegue" {
            let heroDetialsVC = segue.destinationViewController as! HeroDetailsVC
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
            break
        case .Update:
            break
        case .Move:
            break
        }
    }
}