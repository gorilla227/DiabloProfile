//
//  SkillDetailsVC_PassiveSkillCell.swift
//  DiabloProfile
//
//  Created by Andy Xu on 8/19/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import UIKit

class SkillDetailsVC_PassiveSkillCell: UITableViewCell {
    @IBOutlet weak var skillIconImageView: UIImageView!
    @IBOutlet weak var skillNameLabel: UILabel!
    @IBOutlet weak var skillDescriptionLabel: UILabel!
    @IBOutlet weak var skillFlavorLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let bgImage = UIImage(named: "skill_bg.jpg")
        let bgImageView = UIImageView(frame: self.bounds)
        bgImageView.image = bgImage
        bgImageView.contentMode = .ScaleToFill
        self.backgroundView = bgImageView
    }

    func configureCell(skill: Skill) {
        // Set Skill
        skillNameLabel.text = skill.name
        skillDescriptionLabel.text = skill.fullDescription
        skillFlavorLabel.text = skill.flavor
        
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
    }

}
