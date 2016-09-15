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
    
    fileprivate var primaryAttributes = [ItemAttribute]()
    fileprivate var seconaryAttributes = [ItemAttribute]()
    fileprivate var gemsArray = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 10.0
        
        tableView.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: tableView.centerYAnchor).isActive = true
        
        loadData()
    }
    
    func loadData() {
        
        if let basicItem = basicItem, let detailItem = basicItem.detailItem {
            if let name = basicItem.name {
                itemNameLabel.text = name.uppercased()
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
                seconaryAttributes.append(contentsOf: passiveAttributes)
            }
            
            // Load Gems
            if let gems = detailItem.gems?.allObjects as? [Gem] {
                gemsArray.removeAll()
                for gem in gems {
                    if let isJewel = gem.isJewel?.boolValue , isJewel {
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 7
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath as NSIndexPath).section {
        case 0: // Summary
            let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryCell", for: indexPath) as! ItemDetailsVC_SummaryCell
            if let basicItem = self.basicItem {
                cell.configureCell(basicItem)
            }
            return cell
        case 1: // Primary Attributes
            let cell = tableView.dequeueReusableCell(withIdentifier: "AttributeCell", for: indexPath) as! ItemDetailsVC_AttributeCell
            let attribute = primaryAttributes[(indexPath as NSIndexPath).row]
            cell.configureCellForAttribute(attribute)
            return cell
        case 2: // Secondary and Passive Attributes
            let cell = tableView.dequeueReusableCell(withIdentifier: "AttributeCell", for: indexPath) as! ItemDetailsVC_AttributeCell
            let attribute = seconaryAttributes[(indexPath as NSIndexPath).row]
            cell.configureCellForAttribute(attribute)
            return cell
        case 3: // Gems
            let cell = tableView.dequeueReusableCell(withIdentifier: "AttributeCell", for: indexPath) as! ItemDetailsVC_AttributeCell
            let gem = gemsArray[(indexPath as NSIndexPath).row]
            cell.configureCellForGem(gem)
            return cell
        case 4: // Item Set
            if (indexPath as NSIndexPath).row == 0 { // Itemset Name and items
                let cell = tableView.dequeueReusableCell(withIdentifier: "SetCell", for: indexPath) as! ItemDetailsVC_ItemSetCell
                if let itemSet = basicItem?.detailItem?.itemSet, let setItemsEquipped = basicItem?.detailItem?.setItemsEquipped {
                    cell.configureCell(itemSet, setItemsEquipped: setItemsEquipped)
                }
                return cell
            } else { // Itemset Bonus
                let cell = tableView.dequeueReusableCell(withIdentifier: "SetCell", for: indexPath) as! ItemDetailsVC_ItemSetCell
                if let itemSet = basicItem?.detailItem?.itemSet {
                    let equipped = basicItem?.detailItem?.setItemsEquipped?.count ?? 0
                    if let setBonus = itemSet.setBonus?.array[(indexPath as NSIndexPath).row - 1] as? SetBonus {
                        cell.configureCell(setBonus, equipped: equipped, gameData: gameData)
                    }
                }
                return cell
            }
        case 5: // Item Level / Required Level / Account Bound
            let cell = tableView.dequeueReusableCell(withIdentifier: "LevelBoundCell", for: indexPath) as! ItemDetailsVC_LevelBoundCell
            if let detailItem = basicItem?.detailItem {
                cell.configureCell(detailItem, gameData: gameData)
            }
            return cell
        case 6: // Flavor Text
            let cell = tableView.dequeueReusableCell(withIdentifier: "FlavorCell", for: indexPath)
            cell.textLabel?.text = basicItem?.detailItem?.flavor
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1: // Primary Attributes
            return primaryAttributes.isEmpty ? nil : gameData?["primaryAttribute"] as? String
        case 2: // Seconary and Passive Attributes
            return seconaryAttributes.isEmpty ? nil : gameData?["secondaryAttribute"] as? String
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textColor = UIColor.white
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1:
            return primaryAttributes.isEmpty ? CGFloat.leastNormalMagnitude : tableView.sectionHeaderHeight
        case 2:
            return seconaryAttributes.isEmpty ? CGFloat.leastNormalMagnitude : tableView.sectionHeaderHeight
//        case 4:
//            return basicItem?.detailItem?.itemSet == nil ? CGFloat.leastNormalMagnitude : tableView.sectionHeaderHeight
        default:
            return CGFloat.leastNormalMagnitude
        }
    }
}
