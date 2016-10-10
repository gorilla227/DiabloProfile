//
//  SkillListVC.swift
//  DiabloProfile
//
//  Created by Andy on 16/9/16.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import UIKit

class SkillListVC: UITableViewController {

    var hero: Hero?
    var gameData: [String: AnyObject]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tabBarItem.selectedImage = UIImage(named: "skill.png")?.withRenderingMode(.alwaysOriginal)
        tabBarItem.image = UIImage(named: "skill_unselected.png")?.withRenderingMode(.alwaysOriginal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let tabBarController = tabBarController as? HeroDetailsTabBarController, let hero = tabBarController.hero {
            loadData(hero)
        }
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
    }
    
    func initialViewController(_ locale: String?) {
        if let uiStrings = AppDelegate.uiStrings(locale: locale) {
            tabBarItem.title = uiStrings["tabSkill"] as? String
        }
    }
    
    func loadData(_ hero: Hero) {
        self.hero = hero
        gameData = AppDelegate.gameData(locale: hero.locale)
            
        if let imagePath = hero.titleBackgroundImagePath() {
            let backgroundImageView = UIImageView(frame: tableView.bounds)
            backgroundImageView.image = UIImage(named: imagePath)
            backgroundImageView.contentMode = .scaleAspectFill
            tableView.backgroundView = backgroundImageView
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0: // Active Skills
            return hero?.activeSkills?.count ?? 0
        case 1: // Passive Skills
            return hero?.passiveSkills?.count ?? 0
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: // Active Skills
            let cell = tableView.dequeueReusableCell(withIdentifier: "SkillCell", for: indexPath) as! SkillListVC_SkillCell
            if let activeSkills = hero?.activeSkills, let skill = activeSkills[indexPath.row] as? Skill {
                cell.configureCell(skill, isActiveSkill: true)
                cell.backgroundColor = (indexPath.row % 2 == 0) ? UIColor.gray.withAlphaComponent(0.5) : UIColor.darkGray.withAlphaComponent(0.5)
            }
            return cell
        case 1: // Passive Skills
            let cell = tableView.dequeueReusableCell(withIdentifier: "SkillCell", for: indexPath) as! SkillListVC_SkillCell
            if let passiveSkills = hero?.passiveSkills, let skill = passiveSkills[indexPath.row] as? Skill {
                cell.configureCell(skill, isActiveSkill: false)
                cell.backgroundColor = (indexPath.row % 2 == 0) ? UIColor.gray.withAlphaComponent(0.5) : UIColor.darkGray.withAlphaComponent(0.5)
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "SkillDetailsSegue", sender: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let gameData = gameData {
            switch section {
            case 0: // Active Skills
                return gameData["activeSkillsTitle"] as? String
            case 1: // Passive Skills
                return gameData["passiveSkillsTitle"] as? String
            default:
                return nil
            }
        }
        return nil
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "SkillDetailsSegue" {
            if let skillDetailsVC = segue.destination as? SkillDetailsVC, let indexPath = sender as? IndexPath{
                switch indexPath.section {
                case 0: // Active Skill
                    if let activeSkills = hero?.activeSkills, let skill = activeSkills[indexPath.row] as? Skill {
                        skillDetailsVC.skill = skill
                        skillDetailsVC.isActiveSkill = true
                        skillDetailsVC.classKey = hero?.heroClass ?? ""
                        skillDetailsVC.locale = hero?.locale
                    }
                case 1: // Passive Skill
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
