//
//  SkillDetails.swift
//  DiabloProfile
//
//  Created by Andy Xu on 9/28/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import UIKit

class SkillDetails: UIViewController {
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var activeSkillStackView: UIStackView!
    @IBOutlet weak var passiveSkillStackView: UIStackView!
    
    @IBOutlet weak var activeSkillNameLabel: UILabel!
    @IBOutlet weak var activeSkillIconImageView: UIImageView!
    @IBOutlet weak var activeSkillCategoryLabel: UILabel!
    @IBOutlet weak var activeSkillDescriptionLabel: UILabel!
    @IBOutlet weak var activeSkillBreakline: UIView!
    @IBOutlet weak var activeSkillRuneStackView: UIStackView!
    @IBOutlet weak var activeSkillRuneIconImageView: UIImageView!
    @IBOutlet weak var activeSkillRuneNameLabel: UILabel!
    @IBOutlet weak var activeSkillRuneDescriptionLabel: UILabel!
    
    @IBOutlet weak var passiveSkillNameLabel: UILabel!
    @IBOutlet weak var passiveSkillIconImageView: UIImageView!
    @IBOutlet weak var passiveSkillDescriptionLabel: UILabel!
    @IBOutlet weak var passiveSkillBreakline: UIView!
    @IBOutlet weak var passiveSkillFlavorLabel: UILabel!
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        activeSkillCategoryLabel.textColor = UIColor.brown
        activeSkillDescriptionLabel.textColor = UIColor.brown
    }
    
    override func viewDidLayoutSubviews() {
        preferredContentSize = CGSize(width: UIScreen.main.bounds.width, height: stackView.bounds.height + 10)
    }
    
    func configureSkill(skill: Skill, isActiveSkill: Bool) {
        if isActiveSkill {
            // Set ActiveSkill
            activeSkillStackView.isHidden = false
            passiveSkillStackView.isHidden = true
            
            activeSkillNameLabel.text = skill.name
            if let descriptionText = skill.fullDescription {
                activeSkillDescriptionLabel.attributedText = StringAndColor.attributeString(descriptionText, characterSet: StringAndColor.NumbersCharacterSet, defaultAttributes: [NSForegroundColorAttributeName: UIColor(red: 169.0 / 255.0, green: 152 / 255.0, blue: 119.0 / 255.0, alpha: 1.0)], specialAttributes: [NSForegroundColorAttributeName: UIColor.green])
            } else {
                activeSkillDescriptionLabel.text = nil
            }
            
            if let hero = skill.heroA,
                let gameData = AppDelegate.gameData(locale: hero.locale),
                let categorySlug = skill.categorySlug,
                let classKey = hero.heroClass,
                let heroClasses = gameData["class"] as? [String: AnyObject],
                let heroClass = heroClasses[classKey] as? [String: AnyObject],
                let skillCategories = heroClass["skillCategory"] as? [String: String],
                let categoryName = skillCategories[categorySlug] {
                
                activeSkillCategoryLabel.text = categoryName
            }
            if let skillIcon = skill.icon {
                activeSkillIconImageView.image = UIImage(data: skillIcon as Data)
                loadingIndicator.stopAnimating()
                view.layoutIfNeeded()
            } else if let skillIconURL = skill.skillIconImageURL() {
                activeSkillIconImageView.image = #imageLiteral(resourceName: "activeskill_icon_unloaded")
                loadingIndicator.startAnimating()
                
                print("DownloadImage from Web")
                BlizzardAPI.downloadImage(skillIconURL, completion: { (result, error) in
                    guard error == nil && result != nil else {
                        print(error?.domain, error?.localizedDescription)
                        return
                    }
                    
                    skill.icon = result
                    
                    AppDelegate.performUIUpdatesOnMain({
                        self.activeSkillIconImageView.image = UIImage(data: result!)
                        self.loadingIndicator.stopAnimating()
                        self.view.layoutIfNeeded()
                    })
                })
            }
            
            // Set Rune
            if let rune = skill.rune {
                activeSkillRuneStackView.isHidden = false
                activeSkillBreakline.isHidden = false
                
                activeSkillRuneNameLabel.text = rune.name
                if let descriptionText = rune.fullDescription {
                    activeSkillRuneDescriptionLabel.attributedText = StringAndColor.attributeString(descriptionText, characterSet: StringAndColor.NumbersCharacterSet, defaultAttributes: [NSForegroundColorAttributeName: UIColor(red: 169.0 / 255.0, green: 152 / 255.0, blue: 119.0 / 255.0, alpha: 1.0)], specialAttributes: [NSForegroundColorAttributeName: UIColor.green])
                } else {
                    activeSkillRuneDescriptionLabel.text = nil
                }
                
                if let runeIconImagePath = rune.runeIconImagePath(false) {
                    activeSkillRuneIconImageView.image = UIImage(named: runeIconImagePath)
                }
            } else {
                activeSkillRuneStackView.isHidden = true
                activeSkillBreakline.isHidden = true
            }
        } else {
            // Set Passive Skill
            activeSkillStackView.isHidden = true
            passiveSkillStackView.isHidden = false
            
            passiveSkillNameLabel.text = skill.name
            if let descriptionText = skill.fullDescription {
                passiveSkillDescriptionLabel.attributedText = StringAndColor.attributeString(descriptionText, characterSet: StringAndColor.NumbersCharacterSet, defaultAttributes: [NSForegroundColorAttributeName: UIColor(red: 169.0 / 255.0, green: 152 / 255.0, blue: 119.0 / 255.0, alpha: 1.0)], specialAttributes: [NSForegroundColorAttributeName: UIColor.green])
            } else {
                passiveSkillDescriptionLabel.text = nil
            }
            
            if let skillIcon = skill.icon {
                passiveSkillIconImageView.image = UIImage(data: skillIcon as Data)
                loadingIndicator.stopAnimating()
                view.layoutIfNeeded()
            } else if let skillIconURL = skill.skillIconImageURL() {
                passiveSkillIconImageView.image = #imageLiteral(resourceName: "passiveskill_icon_unloaded")
                loadingIndicator.startAnimating()
                
                print("DownloadImage from Web")
                BlizzardAPI.downloadImage(skillIconURL, completion: { (result, error) in
                    guard error == nil && result != nil else {
                        print(error?.domain, error?.localizedDescription)
                        return
                    }
                    
                    skill.icon = result
                    
                    AppDelegate.performUIUpdatesOnMain({
                        self.passiveSkillIconImageView.image = UIImage(data: result!)
                        self.loadingIndicator.stopAnimating()
                        self.view.layoutIfNeeded()
                    })
                })
            }
            
            // Set Flavor
            if let flavor = skill.flavor {
                passiveSkillFlavorLabel.isHidden = false
                passiveSkillBreakline.isHidden = false
                passiveSkillFlavorLabel.text = flavor
            } else {
                passiveSkillFlavorLabel.isHidden = true
                passiveSkillBreakline.isHidden = true
                passiveSkillFlavorLabel.text = nil
            }
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
