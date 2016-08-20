//
//  SkillDetailsVC_ActiveSkillCell.swift
//  DiabloProfile
//
//  Created by Andy Xu on 8/19/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import UIKit

class SkillDetailsVC_ActiveSkillCell: UITableViewCell {
    @IBOutlet weak var skillIconImageView: UIImageView!
    @IBOutlet weak var skillNameLabel: UILabel!
    @IBOutlet weak var skillCategoryLabel: UILabel!
    @IBOutlet weak var skillDescriptionLabel: UILabel!
    @IBOutlet weak var runeView: UIStackView!
    @IBOutlet weak var runeIconImageView: UIImageView!
    @IBOutlet weak var runeNameLabel: UILabel!
    @IBOutlet weak var runeDescriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let bgImage = UIImage(named: "skill_bg.jpg")
        let bgImageView = UIImageView(frame: self.bounds)
        bgImageView.image = bgImage
        bgImageView.contentMode = .ScaleToFill
        self.backgroundView = bgImageView
    }

    func configureCell(skill: Skill, classKey: String) {
        // Set Skill
        skillNameLabel.text = skill.name
        skillDescriptionLabel.text = skill.fullDescription
        if let categorySlug = skill.categorySlug,
            let gameData = AppDelegate.gameData(),
            let heroClasses = gameData["class"] as? [String: AnyObject],
            let heroClass = heroClasses[classKey] as? [String: AnyObject],
            let skillCategories = heroClass["skillCategory"] as? [String: String],
            let categoryName = skillCategories[categorySlug] {
            
            skillCategoryLabel.text = categoryName
        }
        
        if let skillIcon = skill.icon {
            skillIconImageView.image = UIImage(data: skillIcon)
            setNeedsLayout()
        } else if let skillIconURL = skill.skillIconImageURL() {
            
            print("DownloadImage from Web")
            BlizzardAPI.downloadImage(skillIconURL, completion: { (result, error) in
                guard error == nil && result != nil else {
                    print(error?.domain, error?.localizedDescription)
                    return
                }
                
                skill.icon = result
                
                AppDelegate.performUIUpdatesOnMain({
                    self.skillIconImageView.image = UIImage(data: result!)
                    self.setNeedsLayout()
                })
            })
        }
        
        // Set Rune
        if let rune = skill.rune {
            runeView.hidden = false
            
            runeNameLabel.text = rune.name
            runeDescriptionLabel.text = rune.fullDescription
            
            if let runeIconImagePath = rune.runeIconImagePath() {
                runeIconImageView.image = UIImage(named: runeIconImagePath)
            }
        } else {
            runeView.hidden = true
        }
    }

}
