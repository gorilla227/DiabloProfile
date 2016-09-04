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

    func configureCell(itemSet: ItemSet, setItemsEquipped: [String]) {
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
                setItemLabel.font = UIFont.systemFontOfSize(12.0)
                setItemLabel.lineBreakMode = .ByWordWrapping
                setItemLabel.numberOfLines = 0
                stackView.addArrangedSubview(setItemLabel)
                setItemLabel.text = setItem.name
                if let id = setItem.id {
                    setItemLabel.textColor = setItemsEquipped.contains(id) ? UIColor.whiteColor() : UIColor.grayColor()
                }
            }
        }
    }
    
    func configureCell(setBonus: SetBonus, equipped: Int) {
        if let requiredNumber = setBonus.required?.integerValue {
            let attributedString = StringAndColor.attributeString("(\(requiredNumber)) Set:", characterSet: StringAndColor.NumbersCharacterSet, defaultAttributes: [NSForegroundColorAttributeName: equipped >= requiredNumber ? UIColor.greenColor() : UIColor.grayColor()], specialAttributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
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
                    setBonusDescriptionLabel.font = UIFont.systemFontOfSize(12.0)
                    setBonusDescriptionLabel.lineBreakMode = .ByWordWrapping
                    setBonusDescriptionLabel.numberOfLines = 0
                    stackView.addArrangedSubview(setBonusDescriptionLabel)
                    let attributedString = StringAndColor.attributeString(attribute.text!, characterSet: StringAndColor.NumbersCharacterSet, defaultAttributes: [NSForegroundColorAttributeName: equipped >= requiredNumber ? UIColor.greenColor() : UIColor.grayColor()], specialAttributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
                    setBonusDescriptionLabel.attributedText = attributedString
                }
            }
        }
    }
}
