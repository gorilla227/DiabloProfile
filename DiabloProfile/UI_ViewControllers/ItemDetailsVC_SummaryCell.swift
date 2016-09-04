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
    
    func configureCell(basicItem: BasicItem) {
        if let gameData = AppDelegate.gameData(locale: basicItem.hero?.locale), detailItem = basicItem.detailItem {
            itemTypeNameLabel.text = detailItem.typeName
            itemTypeNameLabel.textColor = StringAndColor.getTextColor(basicItem.displayColor)
            itemImageView.configureItemFrame(basicItem, scale: 1)
            if let slotKey = basicItem.slot, let itemSlots = gameData["itemSlot"] as? [String: String], let slot = itemSlots[slotKey] {
                slotLabel.text = slot
            }
            
            if let dps = detailItem.dps where dps.doubleValue > 0 {
                if let dpsText = StringAndColor.convertNumberToString(dps, withFractionDigits: 1) {
                    dpsArmorValueLabel.text = dpsText
                    dpsArmorTitleLabel.text = gameData["damagePerSecond"] as? String
                    dpsArmorValueLabel.hidden = false
                    dpsArmorTitleLabel.hidden = false
                }
            } else if let armor = detailItem.armor where armor.doubleValue > 0 {
                dpsArmorValueLabel.text = armor.stringValue
                dpsArmorTitleLabel.text = gameData["armor"] as? String
                dpsArmorValueLabel.hidden = false
                dpsArmorTitleLabel.hidden = false
            } else {
                dpsArmorValueLabel.hidden = true
                dpsArmorTitleLabel.hidden = true
            }
            
            if let blockChance = detailItem.blockChance, let blockAmountMin = detailItem.blockAmountMin, let blockAmountMax = detailItem.blockAmountMax where blockAmountMin.doubleValue > 0 && blockAmountMax.doubleValue > 0 {
                damageRangeLabel.attributedText = StringAndColor.attributeString(blockChance, characterSet: StringAndColor.NumbersCharacterSet, defaultAttributes: [NSForegroundColorAttributeName: UIColor.grayColor()], specialAttributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
                damageRangeLabel.hidden = false
                if var blockAmountString = gameData["blockAmount"] as? String {
                    blockAmountString = blockAmountString.stringByReplacingOccurrencesOfString("<min>", withString: String(blockAmountMin.integerValue))
                    blockAmountString = blockAmountString.stringByReplacingOccurrencesOfString("<max>", withString: String(blockAmountMax.integerValue))
                    attacksPerSecondLabel.attributedText = StringAndColor.attributeString(blockAmountString, characterSet: StringAndColor.NumbersCharacterSet, defaultAttributes: [NSForegroundColorAttributeName: UIColor.grayColor()], specialAttributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
                    attacksPerSecondLabel.hidden = false
                } else {
                    attacksPerSecondLabel.hidden = true
                }
                
            } else if let damageRange = detailItem.damageRange, let attacksPerSecondText = detailItem.attacksPerSecondText {
                damageRangeLabel.attributedText = StringAndColor.attributeString(damageRange, characterSet: StringAndColor.NumbersCharacterSet, defaultAttributes: [NSForegroundColorAttributeName: UIColor.grayColor()], specialAttributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
                damageRangeLabel.hidden = false
                attacksPerSecondLabel.attributedText = StringAndColor.attributeString(attacksPerSecondText, characterSet: StringAndColor.NumbersCharacterSet, defaultAttributes: [NSForegroundColorAttributeName: UIColor.grayColor()], specialAttributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
                attacksPerSecondLabel.hidden = false
            } else {
                damageRangeLabel.hidden = true
                attacksPerSecondLabel.hidden = true
            }
        }
    }
}
