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
    @IBOutlet weak var heroNameLabel: UILabel!
    @IBOutlet weak var heroLevelClassLabel: UILabel!
    @IBOutlet weak var hardcoreImageView: UIImageView!
    @IBOutlet weak var seasonImageView: UIImageView!
    @IBOutlet weak var headView: UIView!
    
    var hero: Hero?
    var gameData: [String: AnyObject]?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        tabBarItem.selectedImage = UIImage(named: "basic.png")?.imageWithRenderingMode(.AlwaysOriginal)
        tabBarItem.image = UIImage(named: "basic_unselected.png")?.imageWithRenderingMode(.AlwaysOriginal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tabBarController = tabBarController as? HeroDetailsTabBarController, let hero = tabBarController.hero {
            loadData(hero)
        }
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.layoutIfNeeded()
        
        configureHeaderViewLayout()
    }
    
    private func configureHeaderViewLayout() {
        var frame = headView.frame
        frame.size.height = frame.size.width / 3
        headView.frame = frame
    }
    
    func initialViewController(locale: String?) {
        if let uiStrings = AppDelegate.uiStrings(locale: locale) {
            tabBarItem.title = uiStrings["tabGeneral"] as? String
        }
    }
    
    func loadData(hero: Hero) {
        self.hero = hero
        gameData = AppDelegate.gameData(locale: hero.locale)
        
        heroNameLabel.text = hero.name?.uppercaseString ?? ""
        if let classes = gameData?["class"] as? [String: AnyObject],
            let classKey = hero.heroClass,
            let heroClass = classes[classKey] as? [String: AnyObject],
            let className = heroClass["name"] {
            heroLevelClassLabel.text = "\(hero.level!) (\(hero.paragonLevel!)) \(className)"
            
            if let imagePath = hero.titleBackgroundImagePath() {
                let backgroundImageView = UIImageView(frame: tableView.bounds)
                backgroundImageView.image = UIImage(named: imagePath)
                backgroundImageView.contentMode = .ScaleAspectFill
                tableView.backgroundView = backgroundImageView
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

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return (hero != nil) ? 5 : 0
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
                cell.backgroundColor = (indexPath.row % 2 == 0) ? UIColor.grayColor().colorWithAlphaComponent(0.5) : UIColor.darkGrayColor().colorWithAlphaComponent(0.5)
            }
            return cell
        case 4: // Passive Skills
            let cell = tableView.dequeueReusableCellWithIdentifier("SkillCell", forIndexPath: indexPath) as! HeroDetailsVC_SkillCell
            if let passiveSkills = hero?.passiveSkills, let skill = passiveSkills[indexPath.row] as? Skill {
                cell.configureCell(skill, isActiveSkill: false)
                cell.backgroundColor = (indexPath.row % 2 == 0) ? UIColor.grayColor().colorWithAlphaComponent(0.5) : UIColor.darkGrayColor().colorWithAlphaComponent(0.5)
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
        if let gameData = gameData {
            switch section {
            case 1: // Attributes
                return gameData["attributesTitle"] as? String
            case 2: // Stats
                return gameData["statsTitle"] as? String
            case 3: // Active Skills
                return gameData["activeSkillsTitle"] as? String
            case 4: // Passive Skills
                return gameData["passiveSkillsTitle"] as? String
            default:
                return nil
            }
        }
        return nil
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
                        skillDetailsVC.locale = hero?.locale
                    }
                case 4: // Passive Skill
                    if let passiveSkills = hero?.passiveSkills, let skill = passiveSkills[indexPath.row] as? Skill {
                        skillDetailsVC.skill = skill
                        skillDetailsVC.isActiveSkill = false
                        skillDetailsVC.classKey = hero?.heroClass ?? ""
                        skillDetailsVC.locale = hero?.locale
                    }
                default:
                    break
                }
            }
        }
    }
}
