//
//  ItemDetailsVC_SummaryCell.swift
//  DiabloProfile
//
//  Created by Andy Xu on 9/2/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import UIKit

class ItemDetailsVC_SummaryCell: UITableViewCell {
    @IBOutlet weak var itemImageView: ItemImageView!
    @IBOutlet weak var itemTypeNameLabel: UILabel!
    @IBOutlet weak var dpsArmorValueLabel: UILabel!
    @IBOutlet weak var dpsArmorTitleLabel: UILabel!
    @IBOutlet weak var damageRangeLabel: UILabel!
    @IBOutlet weak var attacksPerSecondLabel: UILabel!
    @IBOutlet weak var slotLabel: UILabel!
    
    private func getTextColor(colorKey: String?) -> UIColor {
        if let colorKey = colorKey {
            switch colorKey {
            case "green":
                return UIColor.greenColor()
            case "orange":
                return UIColor.orangeColor()
            case "blue":
                return UIColor(red: 146.0 / 255.0, green: 128.0 / 255.0, blue: 248.0 / 255.0, alpha: 1.0)
            case "yellow":
                return UIColor.yellowColor()
            case "white":
                return UIColor.whiteColor()
            default:
                break
            }
        }
        return UIColor.whiteColor()
    }
    
    private func convertNumberToString(number: NSNumber, withFractionDigits: Int) -> String? {
        let numberFormatter = NSNumberFormatter()
        numberFormatter.maximumFractionDigits = withFractionDigits
        numberFormatter.minimumFractionDigits = withFractionDigits
        return numberFormatter.stringFromNumber(number)
    }
    
    func configureCell(basicItem: BasicItem) {
        if let gameData = AppDelegate.gameData(locale: basicItem.hero?.locale), detailItem = basicItem.detailItem {
            itemTypeNameLabel.text = detailItem.typeName
            itemTypeNameLabel.textColor = getTextColor(basicItem.displayColor)
            itemImageView.configureItemFrame(basicItem, scale: 1)
            if let slotKey = basicItem.slot, let itemSlots = gameData["itemSlot"] as? [String: String], let slot = itemSlots[slotKey] {
                slotLabel.text = slot
            }
            
            if let dps = detailItem.dps where dps.doubleValue > 0 {
                if let dpsText = convertNumberToString(dps, withFractionDigits: 1) {
                    dpsArmorValueLabel.text = dpsText
                    dpsArmorTitleLabel.text = "Damage Per Second"
                    dpsArmorValueLabel.hidden = false
                    dpsArmorTitleLabel.hidden = false
                }
            } else if let armor = detailItem.armor where armor.doubleValue > 0 {
                dpsArmorValueLabel.text = armor.stringValue
                dpsArmorTitleLabel.text = "Armor"
                dpsArmorValueLabel.hidden = false
                dpsArmorTitleLabel.hidden = false
            } else {
                dpsArmorValueLabel.hidden = true
                dpsArmorTitleLabel.hidden = true
            }
            
            if let blockChance = detailItem.blockChance, let blockAmountMin = detailItem.blockAmountMin, let blockAmountMax = detailItem.blockAmountMax where blockAmountMin.doubleValue > 0 && blockAmountMax.doubleValue > 0 {
                damageRangeLabel.text = blockChance
                damageRangeLabel.hidden = false
                attacksPerSecondLabel.text = "\(blockAmountMin.integerValue)-\(blockAmountMax.integerValue) Block Amount"
                attacksPerSecondLabel.hidden = false
            } else if let damageRange = detailItem.damageRange, let attacksPerSecondText = detailItem.attacksPerSecondText {
                damageRangeLabel.text = damageRange
                damageRangeLabel.hidden = false
                attacksPerSecondLabel.text = attacksPerSecondText
                attacksPerSecondLabel.hidden = false
            } else {
                damageRangeLabel.hidden = true
                attacksPerSecondLabel.hidden = true
            }
        }
    }
}
