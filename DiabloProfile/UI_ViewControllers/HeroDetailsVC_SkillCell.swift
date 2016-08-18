//
//  HeroDetailsVC_SkillCell.swift
//  DiabloProfile
//
//  Created by Andy Xu on 8/18/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import UIKit

class HeroDetailsVC_SkillCell: UITableViewCell {
    @IBOutlet weak var skillIconImageView: UIImageView!
    @IBOutlet weak var skillNameLabel: UILabel!
    @IBOutlet weak var skillDescriptionLabel: UILabel!
    @IBOutlet weak var runeView: UIStackView!
    @IBOutlet weak var runeIconImageView: UIImageView!
    @IBOutlet weak var runeNameLabel: UILabel!
    @IBOutlet weak var runeDescriptionLabel: UILabel!

    func configureCell(skill: Skill, isActiveSkill: Bool) {
        // Set Skill
        skillNameLabel.text = skill.name
        skillDescriptionLabel.text = isActiveSkill ? skill.simpleDescription : skill.fullDescription
        
        if let skillIcon = skill.icon {
            skillIconImageView.image = UIImage(data: skillIcon)
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
            runeDescriptionLabel.text = rune.simpleDescription
            
            if let runeIconImagePath = rune.runeIconImagePath() {
                runeIconImageView.image = UIImage(named: runeIconImagePath)
            }
        } else {
            runeView.hidden = true
        }
    }

}
