//
//  SkillDetailsVC.swift
//  DiabloProfile
//
//  Created by Andy Xu on 8/19/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import UIKit

class SkillDetailsVC: UITableViewController {
    
    var classKey: String = ""
    var locale: String?
    var skill: Skill?
    var isActiveSkill: Bool = true
    
    lazy var gameData: [String: AnyObject]? = {
        return AppDelegate.gameData(locale: self.locale)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50.0
        
        if let gameData = gameData,
            let heroClasses = gameData["class"] as? [String: AnyObject],
            let heroClass = heroClasses[classKey] as? [String: AnyObject],
            let className = heroClass["name"] as? String {
            navigationItem.title = className
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if isActiveSkill {
            if let cell = tableView.dequeueReusableCellWithIdentifier("ActiveSkillCell", forIndexPath: indexPath) as? SkillDetailsVC_ActiveSkillCell, let skill = skill, let gameData = self.gameData {
                cell.configureCell(skill, classKey: classKey, gameData: gameData)
                return cell
            }
            return UITableViewCell()
        } else {
            if let cell = tableView.dequeueReusableCellWithIdentifier("PassiveSkillCell", forIndexPath: indexPath) as? SkillDetailsVC_PassiveSkillCell, let skill = skill {
                cell.configureCell(skill)
                return cell
            }
            return UITableViewCell()
        }
    }

}
