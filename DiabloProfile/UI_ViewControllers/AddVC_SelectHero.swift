//
//  AddVC_SelectHero.swift
//  DiabloProfile
//
//  Created by Andy Xu on 8/16/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import UIKit

class AddVC_SelectHero: UITableViewController {
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    var heroes: [[String: AnyObject]]?
    var battleTag: String?
    var region: String?
    var locale: String?

    lazy var gameData: [String: AnyObject]? = {
        return AppDelegate.gameData(locale: self.locale)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = battleTag
        
        configureLoadingIndicator()
    }
    
    private func configureLoadingIndicator() {
        tableView.addSubview(loadingIndicator)
        loadingIndicator.center = tableView.center
    }
    
    private func loadDataUIRespond(loading: Bool) {
        AppDelegate.performUIUpdatesOnMain {
            if loading {
                self.loadingIndicator.startAnimating()
                self.tableView.userInteractionEnabled = false
            } else {
                self.loadingIndicator.stopAnimating()
                self.tableView.userInteractionEnabled = true
            }
        }
    }
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return heroes?.count ?? 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("HeroCell", forIndexPath: indexPath)
        let hero = heroes![indexPath.row]

        // Configure the cell...
        configureCell(cell, hero: hero)

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let hero = heroes![indexPath.row]
        if let region = region, let locale = locale, let battleTag = battleTag, let heroId = hero[Hero.Keys.ID] as? NSNumber {
            loadDataUIRespond(true)
            
            BlizzardAPI.requestHeroProfile(region, locale: locale, battleTag: battleTag, heroId: heroId, completion: { (result, error) in
                self.loadDataUIRespond(false)
                
                guard error == nil else {
                    if let errorInfo = error?.userInfo[NSLocalizedDescriptionKey] as? [String: String] {
                        let warning = UIAlertController(title: errorInfo[BlizzardAPI.ResponseKeys.ErrorCode], message: errorInfo[BlizzardAPI.ResponseKeys.ErrorReason], preferredStyle: .Alert)
                        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        warning.addAction(okAction)
                        AppDelegate.performUIUpdatesOnMain({
                            self.presentViewController(warning, animated: true, completion: nil)
                        })
                    }
                    return
                }
                
                AppDelegate.performUIUpdatesOnMain({
                    self.performSegueWithIdentifier("HeroDetailSegue", sender: result)
                })
            })
        }
    }


    private func configureCell(cell: UITableViewCell, hero: [String: AnyObject]) {
        if let name = hero[Hero.Keys.Name] as? String {
            cell.textLabel?.text = name
        }
        if let level = hero[Hero.Keys.Level] as? NSNumber,
            let heroClassKey = hero[Hero.Keys.HeroClass] as? String,
            let gameData = gameData, let heroClasses = gameData["class"] as? [String: [String: AnyObject]],
            let heroClass = heroClasses[heroClassKey],
            let heroClassName = heroClass["name"] {
            
            cell.detailTextLabel?.text = "\(level) \(heroClassName)"
            
            if let gender = hero[Hero.Keys.Gender] as? Bool {
                let genderKey = gender ? "female" : "male"
                cell.imageView?.image = UIImage(named: Hero.classIconImagePath(classKey: heroClassKey, genderKey: genderKey))
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "HeroDetailSegue" {
            let heroDetailVC = segue.destinationViewController as! HeroDetailsVC
            heroDetailVC.battleTag = battleTag
//            heroDetailVC.region = region
//            heroDetailVC.locale = locale
            heroDetailVC.heroData = sender as? [String: AnyObject]
        }
    }

}
