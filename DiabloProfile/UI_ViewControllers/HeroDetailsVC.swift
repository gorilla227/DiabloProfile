//
//  HeroDetailsVC.swift
//  DiabloProfile
//
//  Created by Andy on 16/8/16.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import UIKit
import CoreData

class HeroDetailsVC: UITableViewController {
    @IBOutlet weak var titleBackgroundImageView: UIImageView!
    @IBOutlet weak var heroNameLabel: UILabel!
    @IBOutlet weak var heroLevelClassLabel: UILabel!
    @IBOutlet weak var hardcoreImageView: UIImageView!
    @IBOutlet weak var seasonImageView: UIImageView!
    @IBOutlet weak var headView: UIView!
    
    var heroData: [String: AnyObject]?
    var battleTag: String?
    var region: String?
    var locale: String?
    var hero: Hero?
    
    let gameData = AppDelegate.gameData()
    
    let mainManagedObjectContext: NSManagedObjectContext = {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.mainManagedObjectContext
    }()
    
    lazy var privateManagedObjectContext: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        moc.parentContext = self.mainManagedObjectContext
        return moc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        initializeHeroObject()
        
        tableView.layoutIfNeeded()
        configureHeaderViewLayout()
        
        loadData()
    }
    
    private func initializeHeroObject() {
        if let heroData = heroData {
            hero = Hero(dictionary: heroData, context: privateManagedObjectContext)
            hero?.battleTag = battleTag
        }
    }
    
    private func configureHeaderViewLayout() {
        var frame = headView.frame
        frame.size.height = frame.size.width / 3
        headView.frame = frame
    }
    
    private func loadData() {
        if let hero = hero {
            navigationItem.title = hero.name
            heroNameLabel.text = hero.name
            if let classes = gameData?["class"] as? [String: AnyObject],
                let classKey = hero.heroClass,
                let heroClass = classes[classKey] as? [String: AnyObject],
                let className = heroClass["name"] {
                heroLevelClassLabel.text = "\(hero.level!) (\(hero.paragonLevel!)) \(className)"
                
                if let gender = hero.gender?.boolValue {
                    let genderKey = gender ? "female" : "male"
                    let image = titleBackgroundImage(classKey, genderKey: genderKey)
                    titleBackgroundImageView.image = image
                }
            }
            if let isHardcore = hero.hardcore?.boolValue {
                hardcoreImageView.hidden = !isHardcore
            }
            if let isSeasonal = hero.seasonal?.boolValue {
                seasonImageView.hidden = !isSeasonal
            }
            tableView.reloadData()
        }
        
    }
    
    private func titleBackgroundImage(classKey: String, genderKey: String) -> UIImage? {
        let imageFileName = "\(classKey)-\(genderKey)-background.jpg"
        return UIImage(named: imageFileName)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 1
        case 1:
            return 4
        case 2:
            return 3
        default:
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("ResourceCell", forIndexPath: indexPath) as! HeroDetailsVC_ResourceCell
            cell.configureCell(hero!)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("StatCell", forIndexPath: indexPath)
            switch indexPath.row {
            case 0:
                configureStatCell(cell, statKey: Stats.Keys.Strength)
            case 1:
                configureStatCell(cell, statKey: Stats.Keys.Dexterity)
            case 2:
                configureStatCell(cell, statKey: Stats.Keys.Intelligence)
            case 3:
                configureStatCell(cell, statKey: Stats.Keys.Vitality)
            default:
                break
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCellWithIdentifier("StatCell", forIndexPath: indexPath)
            switch indexPath.row {
            case 0:
                configureStatCell(cell, statKey: Stats.Keys.Damage)
            case 1:
                configureStatCell(cell, statKey: Stats.Keys.Toughness)
            case 2:
                configureStatCell(cell, statKey: Stats.Keys.Healing)
            default:
                break
            }
            return cell
        default:
            break
        }
        return UITableViewCell()
    }
    
    private func configureStatCell(cell: UITableViewCell, statKey: String) {
        if let stats = gameData?[Hero.Keys.Stats] as? [String: String] {
            cell.textLabel?.text = stats[statKey]
            if let value = hero?.stats?.valueForKey(statKey) as? NSNumber {
                cell.detailTextLabel?.text = value.stringValue
            }
        }
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Life & Resource"
        case 1:
            return "Attributes"
        case 2:
            return "Stats"
        default:
            return nil
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

}
