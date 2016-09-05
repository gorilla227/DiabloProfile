//
//  HeroDetailsVC_ResourceCell.swift
//  DiabloProfile
//
//  Created by Andy Xu on 8/17/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import UIKit

class HeroDetailsVC_ResourceCell: UITableViewCell {
    @IBOutlet weak var lifeTitleLabel: UILabel!
    @IBOutlet weak var lifeValueLabel: UILabel!
    @IBOutlet weak var resourceValueLabel: UILabel!
    @IBOutlet weak var resourceTitleLabel: UILabel!
    @IBOutlet weak var resourceOrbImageView: UIImageView!

    func configureCell(hero: Hero) {
        if let gameData = AppDelegate.gameData(locale: hero.locale), let stats = gameData[Hero.Keys.Stats] as? [String: String] {
            if let lifeValue = hero.stats?.life {
                if lifeValue.integerValue > 1000 {
                    lifeValueLabel.text = "\(lifeValue.integerValue / 1000)k"
                } else {
                    lifeValueLabel.text = lifeValue.stringValue
                }
            }
            lifeTitleLabel.text = stats[Stats.Keys.Life]?.uppercaseString ?? ""

            if let classes = gameData["class"] as? [String: AnyObject], let classKey = hero.heroClass, let heroClass = classes[classKey] as? [String: AnyObject], let resourceNames = heroClass["resource"] as? [String] {
                
                var resourceTitle = String()
                var resourceValue = String()
                if let primaryResourceTitle = resourceNames.first, let primaryResourceValue = hero.stats?.primaryResource?.stringValue {
                    resourceTitle = primaryResourceTitle
                    resourceValue = primaryResourceValue
                }
                
                if resourceNames.count == 2, let secondaryResourceTitle = resourceNames.last, let secondaryResourceValue = hero.stats?.secondaryResource?.stringValue {
                    resourceTitle += "\n\(secondaryResourceTitle)"
                    resourceValue += "\n\(secondaryResourceValue)"
                }
                
                resourceTitleLabel.text = resourceTitle.uppercaseString
                resourceValueLabel.text = resourceValue
                
                resourceOrbImageView.image = resourceOrbImage(classKey)
                
                switch classKey {
                case "monk", "crusader" :
                    resourceValueLabel.textColor = UIColor.blackColor()
                default:
                    resourceValueLabel.textColor = UIColor.whiteColor()
                }
            }
        }
    }

    private func resourceOrbImage(classKey: String) -> UIImage? {
        let imageFileName = "\(classKey)_resource_orb.png"
        return UIImage(named: imageFileName)
    }
}
