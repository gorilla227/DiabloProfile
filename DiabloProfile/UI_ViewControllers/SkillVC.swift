//
//  SkillVC.swift
//  DiabloProfile
//
//  Created by Andy Xu on 9/22/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import UIKit

class SkillVC: UITableViewController {

    var hero: Hero?
    var gameData: [String: AnyObject]?
    
    lazy var popoverVC: SkillDetails = {
        let popoverVC = self.storyboard?.instantiateViewController(withIdentifier: "SkillDetailPopoverVC") as! SkillDetails
        popoverVC.modalPresentationStyle = .popover
        popoverVC.modalTransitionStyle = .flipHorizontal
        popoverVC.loadViewIfNeeded()
        return popoverVC
    }()
    
    let blurEffect = UIBlurEffect(style: .light)
    
    lazy var blurEffectView: UIVisualEffectView = {
        let effectView = UIVisualEffectView()
        effectView.frame = (self.navigationController?.view.bounds)!
        effectView.isUserInteractionEnabled = false
        self.navigationController?.view.addSubview(effectView)
        return effectView
    }()
    
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
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0: // Mouse Skills
            if let count = hero?.activeSkills?.count {
                return min(2, count)
            } else {
                return 0
            }
        case 1: // Action Bar Skills
            if let count = hero?.activeSkills?.count {
                return max(0, count - 2)
            } else {
                return 0
            }
        case 2: // Passive Skills
            return hero?.passiveSkills?.count ?? 0
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: // Active Skills
            let cell = tableView.dequeueReusableCell(withIdentifier: "SkillCell", for: indexPath) as! SkillVC_Cell
            if let activeSkills = hero?.activeSkills, let skill = activeSkills[indexPath.row] as? Skill {
                cell.configureCell(skill: skill, index: indexPath.row)
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SkillCell", for: indexPath) as! SkillVC_Cell
            if let activeSkills = hero?.activeSkills, let skill = activeSkills[indexPath.row + 2] as? Skill {
                cell.configureCell(skill: skill, index: indexPath.row + 2)
            }
            return cell
        case 2: // Passive Skills
            let cell = tableView.dequeueReusableCell(withIdentifier: "PassiveCell", for: indexPath) as! SkillVC_PassiveCell
            if let passiveSkills = hero?.passiveSkills, let skill = passiveSkills[indexPath.row] as? Skill {
                cell.configureCell(skill: skill)
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        popoverVC.popoverPresentationController?.sourceView = tableView.cellForRow(at: indexPath)
        let popoverController = popoverVC.popoverPresentationController!
        popoverController.delegate = self
        
        popoverController.permittedArrowDirections = .init(rawValue: 0)
        popoverController.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "hexagonTexture_01"))
        
        switch indexPath.section {
        case 0: // Mouse Skills
            if let activeSkills = hero?.activeSkills, let skill = activeSkills[indexPath.row] as? Skill {
                popoverVC.configureSkill(skill: skill, isActiveSkill: true)
            }
        case 1: // Action Bar Skill,
            if let activeSkills = hero?.activeSkills, let skill = activeSkills[indexPath.row + 2] as? Skill {
                popoverVC.configureSkill(skill: skill, isActiveSkill: true)
            }
        case 2: // Passive Skill
            if let passiveSkills = hero?.passiveSkills, let skill = passiveSkills[indexPath.row] as? Skill {
                popoverVC.configureSkill(skill: skill, isActiveSkill: false)
            }
        default:
            break
        }
        
        AppDelegate.performUIUpdatesOnMain {
            self.blurEffectView.effect = nil
            UIView.animate(withDuration: 0.2, animations: {
                self.blurEffectView.effect = self.blurEffect
            })
            self.present(self.popoverVC, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let gameData = gameData {
            switch section {
            case 0: // Mouse Skills
                if let count = hero?.activeSkills?.count {
                    return count > 0 ? "Mouse Skills" : nil
                }
            case 1: // Action Bar Skills
                if let count = hero?.activeSkills?.count {
                    return count > 2 ? "Action Bar Skills" : nil
                }
            case 2: // Passive Skills
                if let count = hero?.passiveSkills?.count {
                    return count > 0 ? gameData["passiveSkillsTitle"] as? String : nil
                }
            default:
                return nil
            }
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = UIColor.white
            headerView.textLabel?.textAlignment = .center
            headerView.textLabel?.font = UIFont(name: "DiabloHeavy", size: 20)
        }
    }
}

extension SkillVC: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.blurEffectView.effect = nil
        })
    }
}
