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
    @IBOutlet var addToCollectionButton: UIBarButtonItem!
    @IBOutlet var removeButton: UIBarButtonItem!
    
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
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let backgroundManagedObjectContext = appDelegate.backgroundManagedObjectContext
        let moc = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        moc.parentContext = backgroundManagedObjectContext
        return moc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(mergeToMainManagedObjectContext(_:)), name: NSManagedObjectContextDidSaveNotification, object: privateManagedObjectContext)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(saveBackgroundManagedObjectContext(_:)), name: NSManagedObjectContextDidSaveNotification, object: mainManagedObjectContext)
        
        initializeHeroObject()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.layoutIfNeeded()
        
        configureHeaderViewLayout()
        
        loadData()
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
            hero = Hero(dictionary: heroData, context: privateManagedObjectContext)
            hero?.battleTag = battleTag
            navigationItem.rightBarButtonItem = addToCollectionButton
        } else {
            navigationItem.rightBarButtonItem = removeButton
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
                
                if let imagePath = hero.titleBackgroundImagePath() {
                    titleBackgroundImageView.image = UIImage(named: imagePath)
                }
            }
            if let isHardcore = hero.hardcore?.boolValue {
                hardcoreImageView.hidden = !isHardcore
            }
            if let isSeasonal = hero.seasonal?.boolValue {
                seasonImageView.hidden = !isSeasonal
            }
            
            addToCollectionButton.enabled = !isHeroExistedInCollection()
            tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0: // Life & Resource
            return 1
        case 1: // Attributes
            return 4
        case 2: // Stats
            return 3
        case 3: // Active Skills
            return hero?.activeSkills?.count ?? 0
        case 4: // Passive Skills
            return hero?.passiveSkills?.count ?? 0
        default:
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: // Life & Resource
            let cell = tableView.dequeueReusableCellWithIdentifier("ResourceCell", forIndexPath: indexPath) as! HeroDetailsVC_ResourceCell
            cell.configureCell(hero!)
            return cell
        case 1: // Attributes
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
        case 2: // Stats
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
        case 3: // Active Skills
            let cell = tableView.dequeueReusableCellWithIdentifier("SkillCell", forIndexPath: indexPath) as! HeroDetailsVC_SkillCell
            if let activeSkills = hero?.activeSkills, let skill = activeSkills[indexPath.row] as? Skill {
                cell.configureCell(skill, isActiveSkill: true)
                cell.backgroundColor = (indexPath.row % 2 == 0) ? UIColor.grayColor() : UIColor.darkGrayColor()
            }
            return cell
        case 4: // Passive Skills
            let cell = tableView.dequeueReusableCellWithIdentifier("SkillCell", forIndexPath: indexPath) as! HeroDetailsVC_SkillCell
            if let passiveSkills = hero?.passiveSkills, let skill = passiveSkills[indexPath.row] as? Skill {
                cell.configureCell(skill, isActiveSkill: false)
                cell.backgroundColor = (indexPath.row % 2 == 0) ? UIColor.grayColor() : UIColor.darkGrayColor()
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 3 || indexPath.section == 4 {
            performSegueWithIdentifier("SkillDetailsSegue", sender: indexPath)
        }
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1: // Attributes
            return "Attributes"
        case 2: // Stats
            return "Stats"
        case 3: // Active Skills
            return "Active Skills"
        case 4: // Passive Skills
            return "Passive Skills"
        default:
            return nil
        }
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "SkillDetailsSegue" {
            if let skillDetailsVC = segue.destinationViewController as? SkillDetailsVC, let indexPath = sender as? NSIndexPath{
                switch indexPath.section {
                case 3: // Active Skill
                    if let activeSkills = hero?.activeSkills, let skill = activeSkills[indexPath.row] as? Skill {
                        skillDetailsVC.skill = skill
                        skillDetailsVC.isActiveSkill = true
                        skillDetailsVC.classKey = hero?.heroClass ?? ""
                    }
                case 4: // Passive Skill
                    if let passiveSkills = hero?.passiveSkills, let skill = passiveSkills[indexPath.row] as? Skill {
                        skillDetailsVC.skill = skill
                        skillDetailsVC.isActiveSkill = false
                        skillDetailsVC.classKey = hero?.heroClass ?? ""
                    }
                default:
                    break
                }
            }
        }
    }
    
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
