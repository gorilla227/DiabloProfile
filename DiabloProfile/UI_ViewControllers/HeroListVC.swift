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
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.mainManagedObjectContext
    }()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Hero> = {
        let fetchRequest: NSFetchRequest<Hero> = Hero.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: Hero.Keys.ElitesKills, ascending: false), NSSortDescriptor(key: Hero.Keys.BattleTag, ascending: true), NSSortDescriptor(key: Hero.Keys.Level, ascending: false)]
        
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
    
    fileprivate func loadDataUIRespond(_ loading: Bool, extraBlock:(() -> Void)?) {
        AppDelegate.performUIUpdatesOnMain {
            if loading {
                self.loadingIndicator.startAnimating()
                self.tableView.isUserInteractionEnabled = false
                if let block = extraBlock {
                    block()
                }
            } else {
                self.loadingIndicator.stopAnimating()
                self.tableView.isUserInteractionEnabled = true
                if let block = extraBlock {
                    block()
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let section = fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
        return section.numberOfObjects 
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeroCell", for: indexPath) as! HeorListVC_HeroCell
        let hero = fetchedResultsController.object(at: indexPath)
        cell.configureCell(hero: hero)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hero = fetchedResultsController.object(at: indexPath)
        
        if let lastUpdated = hero.lastUpdated?.doubleValue,
            let region = hero.region,
            BlizzardAPI.reachability(region: region) {
            loadDataUIRespond(true, extraBlock: nil)
            
            BlizzardAPI.requestHeroProfile(hero.region!, locale: hero.locale!, battleTag: hero.battleTag!, heroId: hero.id!, completion: { (result, error) in
                guard error == nil && result != nil else {
                    if let errorInfo = error?.userInfo[NSLocalizedDescriptionKey] as? [String: String] {
                        let warning = UIAlertController(title: errorInfo[BlizzardAPI.ResponseKeys.ErrorCode], message: errorInfo[BlizzardAPI.ResponseKeys.ErrorReason], preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                            AppDelegate.performUIUpdatesOnMain {
                                self.performSegue(withIdentifier: "ViewHeroDetailsSegue", sender: hero)
                            }
                        })
                        warning.addAction(okAction)
                        
                        self.loadDataUIRespond(false, extraBlock: {
                            self.present(warning, animated: true, completion: nil)
                        })
                    }
                    return
                }
                
                if let newLastUpdated = result![Hero.Keys.LastUpdated] as? NSNumber {
                    if newLastUpdated.doubleValue != lastUpdated {
                        print("Update Offline Data")
                        // Update Offline Data
                        self.mainManagedObjectContext.perform({
                            self.mainManagedObjectContext.delete(hero)
                            let newHero = Hero(dictionary: result!, context: self.mainManagedObjectContext)
                            AppDelegate.saveContext(self.mainManagedObjectContext)
                            self.loadDataUIRespond(false, extraBlock: {
                                self.performSegue(withIdentifier: "ViewHeroDetailsSegue", sender: newHero)
                            })
                        })
                    } else {
                        print("Offline Data was Up-to-Dated")
                        self.loadDataUIRespond(false, extraBlock: { 
                            self.performSegue(withIdentifier: "ViewHeroDetailsSegue", sender: hero)
                        })
                    }
                }
            })
        } else {
            performSegue(withIdentifier: "ViewHeroDetailsSegue", sender: hero)
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = fetchedResultsController.sections![section] as NSFetchedResultsSectionInfo
        return section.name
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let hero = fetchedResultsController.object(at: indexPath)
            mainManagedObjectContext.delete(hero)
            AppDelegate.saveContext(mainManagedObjectContext)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ViewHeroDetailsSegue" {
            let heroDetialsVC = segue.destination as! HeroDetailsTabBarController
            heroDetialsVC.hero = sender as? Hero
        }
    }

}

extension HeroListVC: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .automatic)
        case .move:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .update:
            tableView.reloadSections(IndexSet(integer: sectionIndex), with: .automatic)
        case .move:
            break
        }
    }
}
