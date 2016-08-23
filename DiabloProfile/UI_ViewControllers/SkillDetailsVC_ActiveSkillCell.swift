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
    
    let loadingIndicator = UIActivityIndicatorView()
    let activeSkillIcon_unloaded = UIImage(named: "activeskill_icon_unloaded.png")

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // Add background image
        let bgImage = UIImage(named: "skill_bg.jpg")
        let bgImageView = UIImageView(frame: self.bounds)
        bgImageView.image = bgImage
        bgImageView.contentMode = .ScaleToFill
        self.backgroundView = bgImageView
        
        // Add loadingIndicator
        loadingIndicator.color = UIColor.orangeColor()
        loadingIndicator.hidesWhenStopped = true
        skillIconImageView.addSubview(loadingIndicator)
    }

    func configureCell(skill: Skill, classKey: String, gameData: [String: AnyObject]) {
        // Set Skill
        skillNameLabel.text = skill.name
        skillDescriptionLabel.text = skill.fullDescription
        if let categorySlug = skill.categorySlug,
            let heroClasses = gameData["class"] as? [String: AnyObject],
            let heroClass = heroClasses[classKey] as? [String: AnyObject],
            let skillCategories = heroClass["skillCategory"] as? [String: String],
            let categoryName = skillCategories[categorySlug] {
            
            skillCategoryLabel.text = categoryName
        }
        
        if let skillIcon = skill.icon {
            skillIconImageView.image = UIImage(data: skillIcon)
            loadingIndicator.stopAnimating()
            setNeedsLayout()
        } else if let skillIconURL = skill.skillIconImageURL() {
            skillIconImageView.image = activeSkillIcon_unloaded
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
