//
//  ItemDetailsVC.swift
//  DiabloProfile
//
//  Created by Andy Xu on 9/1/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import UIKit

class ItemDetailsVC: UITableViewController {
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    var basicItem: BasicItem?
    lazy var gameData: [String: AnyObject]? = {
        return AppDelegate.gameData(locale: self.basicItem?.hero?.locale)
    }()
    
    private var primaryAttributes = [ItemAttribute]()
    private var seconaryAttributes = [ItemAttribute]()
    private var gemsArray = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 10.0
        
        tableView.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.centerXAnchor.constraintEqualToAnchor(tableView.centerXAnchor).active = true
        loadingIndicator.centerYAnchor.constraintEqualToAnchor(tableView.centerYAnchor).active = true
        
        loadData()
    }
    
    func loadData() {
        
        if let basicItem = basicItem, let detailItem = basicItem.detailItem {
            if let name = basicItem.name {
                itemNameLabel.text = name.uppercaseString
            } else {
                itemNameLabel.text = ""
            }
            itemNameLabel.textColor = StringAndColor.getTextColor(basicItem.displayColor)
            
            // Load Item Attributes
            if let attributes = detailItem.attributes?.array as? [ItemAttribute] {
                primaryAttributes.removeAll()
                seconaryAttributes.removeAll()
                var passiveAttributes = [ItemAttribute]()
                for attribute in attributes {
                    if let category = attribute.category {
                        if category == "primary" {
                            primaryAttributes.append(attribute)
                        } else if category == "secondary" {
                            seconaryAttributes.append(attribute)
                        } else if category == "passive" {
                            passiveAttributes.append(attribute)
                        }
                    }
                }
                seconaryAttributes.appendContentsOf(passiveAttributes)
            }
            
            // Load Gems
            if let gems = detailItem.gems?.allObjects as? [Gem] {
                gemsArray.removeAll()
                for gem in gems {
                    if let isJewel = gem.isJewel?.boolValue where isJewel {
                        // Jewel
                        gemsArray.append(gem)
                        if let jewelAttributes = gem.attributes?.array as? [ItemAttribute] {
                            for attribute in jewelAttributes {
                                gemsArray.append(attribute)
                            }
                        }
                    } else {
                        // Gem
                        gemsArray.append(gem)
                    }
                }
            }
            
            // Load ItemSet
            
            tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 7
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0: // Summary
            return 1
        case 1: // Primary Attributes
            return primaryAttributes.count
        case 2: // Secondary and Passive Attributes
            return seconaryAttributes.count
        case 3: // Gems
            return gemsArray.count
        case 4: // Item Set
            if let itemSet = basicItem?.detailItem?.itemSet {
                let numOfBonus = itemSet.setBonus?.count ?? 0
                return numOfBonus + 1
            }
            return 0
        case 5: // Item Level / Required Level / Account Bound
            return 1
        case 6: // Flavor Text
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: // Summary
            let cell = tableView.dequeueReusableCellWithIdentifier("SummaryCell", forIndexPath: indexPath) as! ItemDetailsVC_SummaryCell
            if let basicItem = self.basicItem {
                cell.configureCell(basicItem)
            }
            return cell
        case 1: // Primary Attributes
            let cell = tableView.dequeueReusableCellWithIdentifier("AttributeCell", forIndexPath: indexPath) as! ItemDetailsVC_AttributeCell
            let attribute = primaryAttributes[indexPath.row]
            cell.configureCellForAttribute(attribute)
            return cell
        case 2: // Secondary and Passive Attributes
            let cell = tableView.dequeueReusableCellWithIdentifier("AttributeCell", forIndexPath: indexPath) as! ItemDetailsVC_AttributeCell
            let attribute = seconaryAttributes[indexPath.row]
            cell.configureCellForAttribute(attribute)
            return cell
        case 3: // Gems
            let cell = tableView.dequeueReusableCellWithIdentifier("AttributeCell", forIndexPath: indexPath) as! ItemDetailsVC_AttributeCell
            let gem = gemsArray[indexPath.row]
            cell.configureCellForGem(gem)
            return cell
        case 4: // Item Set
            if indexPath.row == 0 { // Itemset Name and items
                let cell = tableView.dequeueReusableCellWithIdentifier("SetCell", forIndexPath: indexPath) as! ItemDetailsVC_ItemSetCell
                if let itemSet = basicItem?.detailItem?.itemSet, setItemsEquipped = basicItem?.detailItem?.setItemsEquipped {
                    cell.configureCell(itemSet, setItemsEquipped: setItemsEquipped)
                }
                return cell
            } else { // Itemset Bonus
                let cell = tableView.dequeueReusableCellWithIdentifier("SetCell", forIndexPath: indexPath) as! ItemDetailsVC_ItemSetCell
                if let itemSet = basicItem?.detailItem?.itemSet {
                    let equipped = basicItem?.detailItem?.setItemsEquipped?.count ?? 0
                    if let setBonus = itemSet.setBonus?.array[indexPath.row - 1] as? SetBonus {
                        cell.configureCell(setBonus, equipped: equipped, gameData: gameData)
                    }
                }
                return cell
            }
        case 5: // Item Level / Required Level / Account Bound
            let cell = tableView.dequeueReusableCellWithIdentifier("LevelBoundCell", forIndexPath: indexPath) as! ItemDetailsVC_LevelBoundCell
            if let detailItem = basicItem?.detailItem {
                cell.configureCell(detailItem, gameData: gameData)
            }
            return cell
        case 6: // Flavor Text
            let cell = tableView.dequeueReusableCellWithIdentifier("FlavorCell", forIndexPath: indexPath)
            cell.textLabel?.text = basicItem?.detailItem?.flavor
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1: // Primary Attributes
            return gameData?["primaryAttribute"] as? String
        case 2: // Seconary and Passive Attributes
            return gameData?["secondaryAttribute"] as? String
        default:
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = UIColor.whiteColor()
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1, 2, 4:
            return tableView.sectionHeaderHeight
        default:
            return CGFloat.min
        }
    }

}
