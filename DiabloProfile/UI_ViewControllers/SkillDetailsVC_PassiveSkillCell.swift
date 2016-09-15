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

    let loadingIndicator = UIActivityIndicatorView()
    let passiveSkillIcon_unloaded = UIImage(named: "passiveskill_icon_unloaded.png")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // Add background image
        let bgImage = UIImage(named: "skill_bg.jpg")
        let bgImageView = UIImageView(frame: self.bounds)
        bgImageView.image = bgImage
        bgImageView.contentMode = .scaleToFill
        self.backgroundView = bgImageView
        
        // Add loadingIndicator
        loadingIndicator.color = UIColor.orange
        loadingIndicator.hidesWhenStopped = true
        skillIconImageView.addSubview(loadingIndicator)
    }

    func configureCell(_ skill: Skill) {
        // Set Skill
        skillNameLabel.text = skill.name
        skillDescriptionLabel.text = skill.fullDescription
        skillFlavorLabel.text = skill.flavor
        
        if let skillIcon = skill.icon {
            skillIconImageView.image = UIImage(data: skillIcon as Data)
            loadingIndicator.stopAnimating()
            setNeedsLayout()
        } else if let skillIconURL = skill.skillIconImageURL() {
            skillIconImageView.image = passiveSkillIcon_unloaded
            loadingIndicator.frame = skillIconImageView.bounds
            loadingIndicator.startAnimating()
            
            print("DownloadImage from Web")
            BlizzardAPI.downloadImage(skillIconURL, completion: { (result, error) in
                guard error == nil && result != nil else {
                    print(error?.domain, error?.localizedDescription)
                    return
                }
                
                skill.icon = result
                
                AppDelegate.performUIUpdatesOnMain({
                    self.skillIconImageView.image = UIImage(data: result!)
                    self.loadingIndicator.stopAnimating()
                    self.setNeedsLayout()
                })
            })
        }
    }

}
