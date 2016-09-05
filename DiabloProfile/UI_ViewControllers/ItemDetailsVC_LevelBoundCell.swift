//
//  ItemDetailsVC_LevelBoundCell.swift
//  DiabloProfile
//
//  Created by Andy on 16/9/3.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import UIKit

class ItemDetailsVC_LevelBoundCell: UITableViewCell {
    @IBOutlet weak var itemLevelLabel: UILabel!
    @IBOutlet weak var requiredLevelLabel: UILabel!
    @IBOutlet weak var accountBoundLabel: UILabel!
    
    let defaultTextColor = UIColor(red: 255.0 / 255.0, green: 230.0 / 255.0, blue: 201.0 / 255.0, alpha: 1.0)

    func configureCell(detailItem: DetailItem, gameData: [String: AnyObject]?) {
        if let itemLevel = detailItem.itemLevel?.integerValue, let rawString = gameData?["itemLevel"] as? String {
            let itemLevelString = StringAndColor.attributeString(rawString.stringByReplacingOccurrencesOfString("<lv>", withString: String(itemLevel)), characterSet: StringAndColor.NumbersCharacterSet, defaultAttributes: [NSForegroundColorAttributeName: defaultTextColor], specialAttributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
            itemLevelLabel.attributedText = itemLevelString
        }
        
        if let requiredLevel = detailItem.requiredLevel?.integerValue, let rawString = gameData?["requiredLevel"] as? String {
            let requiredLevelString = StringAndColor.attributeString(rawString.stringByReplacingOccurrencesOfString("<lv>", withString: String(requiredLevel)), characterSet: StringAndColor.NumbersCharacterSet, defaultAttributes: [NSForegroundColorAttributeName: defaultTextColor], specialAttributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
            requiredLevelLabel.attributedText = requiredLevelString
        }
        
        if let accountBound = detailItem.accountBound?.boolValue {
            accountBoundLabel.text = gameData?["accountBound"] as? String
            accountBoundLabel.textColor = defaultTextColor
            accountBoundLabel.hidden = !accountBound
        }
    }
}
