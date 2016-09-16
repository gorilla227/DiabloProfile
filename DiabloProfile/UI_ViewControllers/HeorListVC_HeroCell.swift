//
//  HeorListVC_HeroCell.swift
//  DiabloProfile
//
//  Created by Andy Xu on 9/16/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import UIKit

class HeorListVC_HeroCell: UITableViewCell {
    @IBOutlet weak var heroImageView: UIImageView!
    @IBOutlet weak var heroNameLabel: UILabel!
    @IBOutlet weak var heroLevelLabel: UILabel!
    @IBOutlet weak var eliteKillsLabel: UILabel!

    func configureCell(hero: Hero) {
        if let heroName = hero.name,
            let level = hero.level,
            let heroClassKey = hero.heroClass,
            let gameData = AppDelegate.gameData(locale: hero.locale), let heroClasses = gameData["class"] as? [String: [String: AnyObject]],
            let heroClass = heroClasses[heroClassKey],
            let heroClassName = heroClass["name"],
            let elitesKills = hero.elitesKills {
            
            heroNameLabel.text = "\(heroName)"
            heroLevelLabel.text = "\(level) \(heroClassName)"
            eliteKillsLabel.text = elitesKills.stringValue + " Elite Kills"
            
            if let classIconImagePath = hero.classIconImagePath() {
                heroImageView.image = UIImage(named: classIconImagePath)
            }
        }
    }
    
    func configureCell(heroData: [String: Any], locale: String?) {
        if let name = heroData[Hero.Keys.Name] as? String,
            let level = heroData[Hero.Keys.Level] as? NSNumber,
            let heroClassKey = heroData[Hero.Keys.HeroClass] as? String,
            let gameData = AppDelegate.gameData(locale: locale), let heroClasses = gameData["class"] as? [String: [String: AnyObject]],
            let heroClass = heroClasses[heroClassKey],
            let heroClassName = heroClass["name"],
            let elitesKills = heroData[Hero.Keys.ElitesKills] as? NSNumber {
            
            heroNameLabel.text = name
            heroLevelLabel.text = "\(level) \(heroClassName)"
            eliteKillsLabel.text = elitesKills.stringValue + " Elite Kills"
            
            if let gender = heroData[Hero.Keys.Gender] as? Bool {
                let genderKey = gender ? "female" : "male"
                heroImageView.image = UIImage(named: Hero.classIconImagePath(classKey: heroClassKey, genderKey: genderKey))
            }
        }
    }
}
