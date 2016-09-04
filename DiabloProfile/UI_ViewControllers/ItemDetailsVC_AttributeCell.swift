//
//  ItemDetailsVC_AttributeCell.swift
//  DiabloProfile
//
//  Created by Andy on 16/9/1.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import UIKit

class ItemDetailsVC_AttributeCell: UITableViewCell {
    @IBOutlet weak var listIconImageView: UIImageView!
    @IBOutlet weak var gemIconImageView: UIImageView!
    @IBOutlet weak var attributeTextLabel: UILabel!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    func configureCellForAttribute(attribute: ItemAttribute) {
        if let rawString = attribute.text {
            attributeTextLabel.attributedText = StringAndColor.attributeString(rawString, characterSet: StringAndColor.NumbersCharacterSet, defaultAttributes: [NSForegroundColorAttributeName: StringAndColor.getTextColor(attribute.color)], specialAttributes: [NSForegroundColorAttributeName: UIColor(red: 158.0 / 255.0, green: 150 / 255.0, blue: 205.0 / 255.0, alpha: 1.0)])
            listIconImageView.image = imageForAttributeListIcon(attribute.affixType)
            listIconImageView.hidden = false
            gemIconImageView.hidden = true
            indentationLevel = 0
        }
    }
    
    func configureCellForGem(obj: AnyObject) {
        if let gem = obj as? Gem, isJewel = gem.isJewel?.boolValue {
            if isJewel {
                // Jewel Name
                if let gemItem = gem.basicItem, rank = gem.jewelRank {
                    if let name = gemItem.name, colorKey = gemItem.displayColor {
                        let attributeString = NSMutableAttributedString(string: name, attributes: [NSForegroundColorAttributeName: StringAndColor.getTextColor(colorKey)])
                        attributeString.appendAttributedString(NSAttributedString(string: " - Rank \(rank)", attributes: [NSForegroundColorAttributeName: UIColor.lightGrayColor()]))
                        attributeTextLabel.attributedText = attributeString
                    }
                }
            } else {
                // Gem Attribute
                if let gemAttribute = gem.attributes?.array.first as? ItemAttribute, attributeString = gemAttribute.text {
                    attributeTextLabel.text = attributeString
                    attributeTextLabel.textColor = UIColor.whiteColor()
                }
            }
            
            if let gemItem = gem.basicItem, icon = gemItem.icon {
                gemIconImageView.image = UIImage(data: icon)
            } else {
                // TODO: Download GemIcon
                // Download Gem Icon
                if let iconURL = gem.basicItem?.iconImageURL("small") {
                    BlizzardAPI.downloadImage(iconURL, completion: { (result, error) in
                        
                        guard error == nil && result != nil else {
                            print(error?.domain, error?.localizedDescription)
                            return
                        }
                        
                        AppDelegate.performUIUpdatesOnMain({
                            gem.basicItem?.icon = result
                            self.gemIconImageView.image = UIImage(data: result!)
                        })
                    })
                }
            }
            gemIconImageView.hidden = false
            listIconImageView.hidden = true
            indentationLevel = 0
        } else if let jewelAttribute = obj as? ItemAttribute {
            // Jewel Attributes
            if let rawString = jewelAttribute.text, colorKey = jewelAttribute.color {
                let attributedText = NSMutableAttributedString(attributedString: StringAndColor.attributeString(rawString, characterSet: StringAndColor.NumbersCharacterSet, defaultAttributes: [NSForegroundColorAttributeName: StringAndColor.getTextColor(colorKey)], specialAttributes: [NSForegroundColorAttributeName: UIColor.whiteColor()]))
                
                // Set (Required Rank XX) to redColor
                if let range = StringAndColor.rangeOfLastRoundBracketString(rawString) {
                    attributedText.setAttributes([NSForegroundColorAttributeName: UIColor.redColor()], range: range)
                }
                attributeTextLabel.attributedText = attributedText
            }
            listIconImageView.image = imageForAttributeListIcon(jewelAttribute.affixType)
            listIconImageView.hidden = false
            gemIconImageView.hidden = true
            indentationLevel = 1
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        leadingConstraint.constant = CGFloat(indentationLevel) * indentationWidth + 5.0
    }
    
    private func imageForAttributeListIcon(affixType: String?) -> UIImage? {
        if let affixType = affixType {
            return UIImage(named: affixType + ".png")
        }
        return nil
    }
}
