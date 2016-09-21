//
//  HeroDetailsVC_LPCell.swift
//  DiabloProfile
//
//  Created by Andy Xu on 9/17/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import UIKit

class HeroDetailsVC_LPCell: UITableViewCell {

    @IBOutlet weak var weaponImageView: ItemImageView!
    @IBOutlet weak var weaponLabel: UILabel!
    @IBOutlet weak var armorImageView: ItemImageView!
    @IBOutlet weak var armorLabel: UILabel!
    @IBOutlet weak var jewelryImageView: ItemImageView!
    @IBOutlet weak var jewelryLabel: UILabel!
    @IBOutlet weak var legendaryPowerNameLabel: UILabel!
    @IBOutlet weak var legendaryPowerDescriptionLabel: UILabel!
    
    var legendaryPowers: [LegendaryPower]?
    
    func configureCell(_ legendaryPowers: [LegendaryPower], selectedLegendaryPower: LegendaryPower?, delegate: ItemImageViewDelegate?) {
        self.legendaryPowers = legendaryPowers
        if legendaryPowers.count == 3 {
            let legendaryPower_Weapon = legendaryPowers[0]
            weaponImageView.configureLegendaryPower(legendaryPower_Weapon, type: 0)
            weaponImageView.delegate = delegate
            
            let legendaryPower_Armor = legendaryPowers[1]
            armorImageView.configureLegendaryPower(legendaryPower_Armor, type: 1)
            armorImageView.delegate = delegate
            
            let legendaryPower_Jewelry = legendaryPowers[2]
            jewelryImageView.configureLegendaryPower(legendaryPower_Jewelry, type: 2)
            jewelryImageView.delegate = delegate
        }
        legendaryPowerSelected(selectedLegendaryPower: selectedLegendaryPower)
    }
    
    func legendaryPowerSelected(selectedLegendaryPower: LegendaryPower?) {
        if let selectedLegendaryPower = selectedLegendaryPower {
            if let attributes = selectedLegendaryPower.attribute?.allObjects as? [ItemAttribute], attributes.count > 0 {
                // Display attribute
                var descriptionStrings = [String]()
                for attribute in attributes {
                    if let string = attribute.text, let category = attribute.category, category == "passive" {
                        descriptionStrings.append(string)
                    }
                }
                legendaryPowerNameLabel.text = selectedLegendaryPower.name
                legendaryPowerNameLabel.textColor = StringAndColor.getTextColor(selectedLegendaryPower.displayColor)
                legendaryPowerDescriptionLabel.text = descriptionStrings.joined(separator: "\n")
                legendaryPowerDescriptionLabel.textColor = StringAndColor.getTextColor(selectedLegendaryPower.displayColor)
                layoutIfNeeded()
            }
        } else {
            legendaryPowerNameLabel.text = nil
            legendaryPowerDescriptionLabel.text = nil
            layoutIfNeeded()
        }
    }
}
