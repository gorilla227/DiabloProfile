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
            attributeTextLabel.attributedText = attributedNumberString(rawString,
                                                                            separator: " ",
                                                                            defaultAttributes: [NSForegroundColorAttributeName: getTextColor(attribute.color)],
                                                                            numberAttributes: [NSForegroundColorAttributeName: UIColor(red: 158.0 / 255.0, green: 150 / 255.0, blue: 205.0 / 255.0, alpha: 1.0)])
            listIconImageView.image = imageForAttributeListIcon(attribute.affixType)
            listIconImageView.hidden = false
            gemIconImageView.hidden = true
            indentationLevel = 0
        }
    }
    
    func configureCellForGem(obj: AnyObject) {
        if let gem = obj as? Gem, isJewel = gem.isJewel?.boolValue {
            if isJewel {
                // Jewel
                if let gemItem = gem.basicItem, rank = gem.jewelRank {
                    if let name = gemItem.name, colorKey = gemItem.displayColor {
                        let attributeString = NSMutableAttributedString(string: name, attributes: [NSForegroundColorAttributeName: getTextColor(colorKey)])
                        attributeString.appendAttributedString(NSAttributedString(string: " - Rank \(rank)", attributes: [NSForegroundColorAttributeName: UIColor.lightGrayColor()]))
                        attributeTextLabel.attributedText = attributeString
                    }
                }
            } else {
                // Gem
                if let gemAttribute = gem.attributes?.array.first as? ItemAttribute, attributeString = gemAttribute.text {
                    attributeTextLabel.text = attributeString
                    attributeTextLabel.textColor = UIColor.whiteColor()
                }
            }
            
            if let gemItem = gem.basicItem, icon = gemItem.icon {
                gemIconImageView.image = UIImage(data: icon)
            } else {
                // TODO: Download GemIcon
            }
            gemIconImageView.hidden = false
            listIconImageView.hidden = true
            indentationLevel = 0
        } else if let jewelAttribute = obj as? ItemAttribute {
            if let rawString = jewelAttribute.text, colorKey = jewelAttribute.color {
                let numberColor = (colorKey == "gray") ? UIColor.whiteColor() : UIColor(red: 158.0 / 255.0, green: 150 / 255.0, blue: 205.0 / 255.0, alpha: 1.0)
                attributeTextLabel.attributedText = attributedNumberString(rawString,
                                                                           separator: " ",
                                                                           defaultAttributes: [NSForegroundColorAttributeName: getTextColor(jewelAttribute.color)],
                                                                           numberAttributes: [NSForegroundColorAttributeName: numberColor])
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
    
    private func convertNumberToString(number: NSNumber, withFractionDigits: Int) -> String? {
        let numberFormatter = NSNumberFormatter()
        numberFormatter.maximumFractionDigits = withFractionDigits
        numberFormatter.minimumFractionDigits = withFractionDigits
        return numberFormatter.stringFromNumber(number)
    }
    
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
            case "gray":
                return UIColor.grayColor()
            default:
                break
            }
        }
        return UIColor.whiteColor()
    }
    
    private func imageForAttributeListIcon(affixType: String?) -> UIImage? {
        if let affixType = affixType {
            return UIImage(named: affixType + ".png")
        }
        return nil
    }
    
    private func attributedNumberString(rawString: String, separator: String, defaultAttributes: [String: AnyObject], numberAttributes: [String: AnyObject]) -> NSAttributedString {
        let result = NSMutableAttributedString()
        let stringArray = rawString.componentsSeparatedByString(separator)
        for string in stringArray {
            if string.rangeOfCharacterFromSet(NSCharacterSet.decimalDigitCharacterSet()) == nil {
                result.appendAttributedString(NSAttributedString(string: string, attributes: defaultAttributes))
            } else {
                result.appendAttributedString(NSAttributedString(string: string, attributes: numberAttributes))
            }
            
            if stringArray.last != string {
                result.appendAttributedString(NSAttributedString(string: separator))
            }
        }
        return result
    }
}
