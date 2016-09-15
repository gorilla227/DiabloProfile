//
//  ItemDetailsVC_ItemSetCell.swift
//  DiabloProfile
//
//  Created by Andy on 16/9/3.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import UIKit

class ItemDetailsVC_ItemSetCell: UITableViewCell {
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var itemNameLabel: UILabel!

    func configureCell(_ itemSet: ItemSet, setItemsEquipped: [String]) {
        itemNameLabel.text = itemSet.name
        
        for view in stackView.arrangedSubviews {
            if view != itemNameLabel {
                stackView.removeArrangedSubview(view)
                view.removeFromSuperview()
            }
        }
        
        if let items = itemSet.items?.allObjects as? [BasicItem] {
            for setItem in items {
                let setItemLabel = InsetUILabel()
                setItemLabel.insetsLeft = 10.0
                setItemLabel.font = UIFont.systemFont(ofSize: 12.0)
                setItemLabel.lineBreakMode = .byWordWrapping
                setItemLabel.numberOfLines = 0
                stackView.addArrangedSubview(setItemLabel)
                setItemLabel.text = setItem.name
                if let id = setItem.id {
                    setItemLabel.textColor = setItemsEquipped.contains(id) ? UIColor.white : UIColor.gray
                }
            }
        }
    }
    
    func configureCell(_ setBonus: SetBonus, equipped: Int, gameData: [String: AnyObject]?) {
        if let requiredNumber = setBonus.required?.intValue, let rawString = gameData?["itemSet"] as? String {
            let requiredString = rawString.replacingOccurrences(of: "<required>", with: String(requiredNumber))
            let attributedString = StringAndColor.attributeString(requiredString, characterSet: StringAndColor.NumbersCharacterSet, defaultAttributes: [NSForegroundColorAttributeName: equipped >= requiredNumber ? UIColor.green : UIColor.gray], specialAttributes: [NSForegroundColorAttributeName: UIColor.white])
            itemNameLabel.attributedText = attributedString
            
            for view in stackView.arrangedSubviews {
                if view != itemNameLabel {
                    stackView.removeArrangedSubview(view)
                    view.removeFromSuperview()
                }
            }
            
            if let bonusAttributes = setBonus.attributes?.allObjects as? [ItemAttribute] {
                for attribute in bonusAttributes {
                    let setBonusDescriptionLabel = InsetUILabel()
                    setBonusDescriptionLabel.insetsLeft = 10.0
                    setBonusDescriptionLabel.font = UIFont.systemFont(ofSize: 12.0)
                    setBonusDescriptionLabel.lineBreakMode = .byWordWrapping
                    setBonusDescriptionLabel.numberOfLines = 0
                    stackView.addArrangedSubview(setBonusDescriptionLabel)
                    let attributedString = StringAndColor.attributeString(attribute.text!, characterSet: StringAndColor.NumbersCharacterSet, defaultAttributes: [NSForegroundColorAttributeName: equipped >= requiredNumber ? UIColor.green : UIColor.gray], specialAttributes: [NSForegroundColorAttributeName: UIColor.white])
                    setBonusDescriptionLabel.attributedText = attributedString
                }
            }
        }
        layoutIfNeeded()
    }
}
