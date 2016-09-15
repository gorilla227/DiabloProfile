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
    
    func configureCell(_ basicItem: BasicItem) {
        if let gameData = AppDelegate.gameData(locale: basicItem.hero?.locale), let detailItem = basicItem.detailItem {
            itemTypeNameLabel.text = detailItem.typeName
            itemTypeNameLabel.textColor = StringAndColor.getTextColor(basicItem.displayColor)
            itemImageView.configureItemFrame(basicItem, scale: 1)
            if let slotKey = basicItem.slot, let itemSlots = gameData["itemSlot"] as? [String: String], let slot = itemSlots[slotKey] {
                slotLabel.text = slot
            }
            
            if let dps = detailItem.dps , dps.doubleValue > 0 {
                if let dpsText = StringAndColor.convertNumberToString(dps, withFractionDigits: 1) {
                    dpsArmorValueLabel.text = dpsText
                    dpsArmorTitleLabel.text = gameData["damagePerSecond"] as? String
                    dpsArmorValueLabel.isHidden = false
                    dpsArmorTitleLabel.isHidden = false
                }
            } else if let armor = detailItem.armor , armor.doubleValue > 0 {
                dpsArmorValueLabel.text = armor.stringValue
                dpsArmorTitleLabel.text = gameData["armor"] as? String
                dpsArmorValueLabel.isHidden = false
                dpsArmorTitleLabel.isHidden = false
            } else {
                dpsArmorValueLabel.isHidden = true
                dpsArmorTitleLabel.isHidden = true
            }
            
            if let blockChance = detailItem.blockChance, let blockAmountMin = detailItem.blockAmountMin, let blockAmountMax = detailItem.blockAmountMax , blockAmountMin.doubleValue > 0 && blockAmountMax.doubleValue > 0 {
                damageRangeLabel.attributedText = StringAndColor.attributeString(blockChance, characterSet: StringAndColor.NumbersCharacterSet, defaultAttributes: [NSForegroundColorAttributeName: UIColor.gray], specialAttributes: [NSForegroundColorAttributeName: UIColor.white])
                damageRangeLabel.isHidden = false
                if var blockAmountString = gameData["blockAmount"] as? String {
                    blockAmountString = blockAmountString.replacingOccurrences(of: "<min>", with: String(blockAmountMin.intValue))
                    blockAmountString = blockAmountString.replacingOccurrences(of: "<max>", with: String(blockAmountMax.intValue))
                    attacksPerSecondLabel.attributedText = StringAndColor.attributeString(blockAmountString, characterSet: StringAndColor.NumbersCharacterSet, defaultAttributes: [NSForegroundColorAttributeName: UIColor.gray], specialAttributes: [NSForegroundColorAttributeName: UIColor.white])
                    attacksPerSecondLabel.isHidden = false
                } else {
                    attacksPerSecondLabel.isHidden = true
                }
                
            } else if let damageRange = detailItem.damageRange, let attacksPerSecondText = detailItem.attacksPerSecondText {
                damageRangeLabel.attributedText = StringAndColor.attributeString(damageRange, characterSet: StringAndColor.NumbersCharacterSet, defaultAttributes: [NSForegroundColorAttributeName: UIColor.gray], specialAttributes: [NSForegroundColorAttributeName: UIColor.white])
                damageRangeLabel.isHidden = false
                attacksPerSecondLabel.attributedText = StringAndColor.attributeString(attacksPerSecondText, characterSet: StringAndColor.NumbersCharacterSet, defaultAttributes: [NSForegroundColorAttributeName: UIColor.gray], specialAttributes: [NSForegroundColorAttributeName: UIColor.white])
                attacksPerSecondLabel.isHidden = false
            } else {
                damageRangeLabel.isHidden = true
                attacksPerSecondLabel.isHidden = true
            }
        }
    }
}
