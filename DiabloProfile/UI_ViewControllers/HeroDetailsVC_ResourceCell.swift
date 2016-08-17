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
        if let gameData = AppDelegate.gameData(), let stats = gameData[Hero.Keys.Stats] as? [String: String] {
            lifeTitleLabel.text = stats[Stats.Keys.Life]
            lifeValueLabel.text = hero.stats?.life?.stringValue ?? nil
            if let classes = gameData["class"] as? [String: AnyObject], let classKey = hero.heroClass, let heroClass = classes[classKey] as? [String: AnyObject], let resourceNames = heroClass["resource"] as? [String] {
                
                var resourceTitle = String()
                var resourceValue = String()
                if let primaryResourceTitle = resourceNames.first, let primaryResourceValue = hero.stats?.primaryResource?.stringValue {
                    resourceTitle = primaryResourceTitle
                    resourceValue = primaryResourceValue
                }
                
                if resourceNames.count == 2, let secondaryResourceTitle = resourceNames.last, let secondaryResourceValue = hero.stats?.secondaryResource?.stringValue {
                    resourceTitle += "/\(secondaryResourceTitle)"
                    resourceValue += "/\(secondaryResourceValue)"
                }
                
                resourceTitleLabel.text = resourceTitle
                resourceValueLabel.text = resourceValue
                
                resourceOrbImageView.image = resourceOrbImage(classKey)
            }
        }
    }

    private func resourceOrbImage(classKey: String) -> UIImage? {
        let imageFileName = "\(classKey)-orb.png"
        return UIImage(named: imageFileName)
    }
}
