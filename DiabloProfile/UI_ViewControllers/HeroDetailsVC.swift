//
//  HeroDetailsVC.swift
//  DiabloProfile
//
//  Created by Andy on 16/8/16.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import UIKit

class HeroDetailsVC: UITableViewController {
    @IBOutlet weak var heroNameLabel: UILabel!
    @IBOutlet weak var heroLevelClassLabel: UILabel!
    @IBOutlet weak var hardcoreImageView: UIImageView!
    @IBOutlet weak var seasonImageView: UIImageView!
    @IBOutlet weak var headView: UIView!
    
    var hero: Hero?
    var selectedLegendaryPower: LegendaryPower?
    var gameData: [String: AnyObject]?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        tabBarItem.selectedImage = UIImage(named: "basic.png")?.withRenderingMode(.alwaysOriginal)
        tabBarItem.image = UIImage(named: "basic_unselected.png")?.withRenderingMode(.alwaysOriginal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let tabBarController = tabBarController as? HeroDetailsTabBarController, let hero = tabBarController.hero {
            loadData(hero)
        }
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        tableView.layoutIfNeeded()
        
        configureHeaderViewLayout()
    }
    
    fileprivate func configureHeaderViewLayout() {
        var frame = headView.frame
        frame.size.height = frame.size.width / 3
        headView.frame = frame
    }
    
    func initialViewController(_ locale: String?) {
        if let uiStrings = AppDelegate.uiStrings(locale: locale) {
            tabBarItem.title = uiStrings["tabGeneral"] as? String
        }
    }
    
    func loadData(_ hero: Hero) {
        self.hero = hero
        gameData = AppDelegate.gameData(locale: hero.locale)
        
        heroNameLabel.text = hero.name?.uppercased() ?? ""
        if let classes = gameData?["class"] as? [String: AnyObject],
            let classKey = hero.heroClass,
            let heroClass = classes[classKey] as? [String: AnyObject],
            let className = heroClass["name"] {
            heroLevelClassLabel.text = "\(hero.level!) (\(hero.paragonLevel!)) \(className)"
            
            if let imagePath = hero.titleBackgroundImagePath() {
                let backgroundImageView = UIImageView(frame: tableView.frame)
                backgroundImageView.image = UIImage(named: imagePath)
                backgroundImageView.contentMode = .scaleAspectFill
                tableView.backgroundView = backgroundImageView
            }
        }
        if let isHardcore = hero.hardcore?.boolValue {
            hardcoreImageView.isHidden = !isHardcore
        }
        if let isSeasonal = hero.seasonal?.boolValue {
            seasonImageView.isHidden = !isSeasonal
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return (hero != nil) ? 4 : 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0: // Life & Resource
            return 1
        case 1: // Attributes
            return 4
        case 2: // Stats
            return 3
        case 3: // Legendary Powers
            return 1
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0: // Life & Resource
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResourceCell", for: indexPath) as! HeroDetailsVC_ResourceCell
            cell.configureCell(hero!)
            return cell
        case 1: // Attributes
            let cell = tableView.dequeueReusableCell(withIdentifier: "StatCell", for: indexPath)
            switch indexPath.row {
            case 0:
                configureStatCell(cell, statKey: Stats.Keys.Strength)
            case 1:
                configureStatCell(cell, statKey: Stats.Keys.Dexterity)
            case 2:
                configureStatCell(cell, statKey: Stats.Keys.Intelligence)
            case 3:
                configureStatCell(cell, statKey: Stats.Keys.Vitality)
            default:
                break
            }
            return cell
        case 2: // Stats
            let cell = tableView.dequeueReusableCell(withIdentifier: "StatCell", for: indexPath)
            switch indexPath.row {
            case 0:
                configureStatCell(cell, statKey: Stats.Keys.Damage)
            case 1:
                configureStatCell(cell, statKey: Stats.Keys.Toughness)
            case 2:
                configureStatCell(cell, statKey: Stats.Keys.Healing)
            default:
                break
            }
            return cell
        case 3: // Legendary Powers
            let cell = tableView.dequeueReusableCell(withIdentifier: "LPCell", for: indexPath) as! HeroDetailsVC_LPCell
            if let powers = hero?.legendaryPowers?.array as? [LegendaryPower] {
                cell.configureCell(powers, selectedLegendaryPower: selectedLegendaryPower, delegate: self)
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    fileprivate func configureStatCell(_ cell: UITableViewCell, statKey: String) {
        if let stats = gameData?[Hero.Keys.Stats] as? [String: String] {
            cell.textLabel?.text = stats[statKey]
            if let value = hero?.stats?.value(forKey: statKey) as? NSNumber {
                cell.detailTextLabel?.text = value.stringValue
            }
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let gameData = gameData {
            switch section {
            case 1: // Attributes
                return gameData["attributesTitle"] as? String
            case 2: // Stats
                return gameData["statsTitle"] as? String
            case 3: // Legendary Powers
                return "Kanai's Cube Powers"
            default:
                return nil
            }
        }
        return nil
    }
}

extension HeroDetailsVC: ItemImageViewDelegate {
    func itemImageViewTapped(itemImageView: ItemImageView) {
        selectedLegendaryPower = itemImageView.legendaryPower
        if let selectedLegendaryPower = itemImageView.legendaryPower {
            if let attributes = selectedLegendaryPower.attribute?.allObjects as? [ItemAttribute], attributes.count > 0 {
                // Display attribute
                UIView.performWithoutAnimation {
                    self.tableView.reloadSections(IndexSet(integer: 3), with: .none)
                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 3), at: .top, animated: false)
                }
            } else {
                // Request Attribute
                if let tooltipParams = selectedLegendaryPower.tooltipParams, let region = selectedLegendaryPower.hero?.region, let locale = selectedLegendaryPower.hero?.locale {
                    BlizzardAPI.requestItemData(region, locale: locale, itemTooltipParams: tooltipParams, completion: { (result, error) in
                        guard error == nil else {
                            print(error?.domain, error?.localizedDescription)
                            return
                        }
                        
                        if let attributesArray = result?[BlizzardAPI.ResponseKeys.ItemKeys.Attributes] as? [[String: AnyObject]], let moc = selectedLegendaryPower.hero?.managedObjectContext {
                            selectedLegendaryPower.attribute = NSSet(array: [ItemAttribute]())
                            for attributeDict in attributesArray {
                                let attribute = ItemAttribute(dictionary: attributeDict, context: moc)
                                selectedLegendaryPower.addToAttribute(attribute)
                            }
                            AppDelegate.performUIUpdatesOnMain {
                                UIView.performWithoutAnimation {
                                    self.tableView.reloadSections(IndexSet(integer: 3), with: .none)
                                    self.tableView.scrollToRow(at: IndexPath(row: 0, section: 3), at: .top, animated: false)
                                }
                            }
                        }
                    })
                }
            }
        }
    }
}
