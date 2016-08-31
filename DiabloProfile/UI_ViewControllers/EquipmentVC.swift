//
//  EquipmentVC.swift
//  DiabloProfile
//
//  Created by Andy Xu on 8/29/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import UIKit

class EquipmentVC: UIViewController {
    @IBOutlet weak var shouldersImageView: ItemImageView!
    @IBOutlet weak var handsImageView: ItemImageView!
    @IBOutlet weak var leftFingerImageView: ItemImageView!
    @IBOutlet weak var mainHandImageView: ItemImageView!
    @IBOutlet weak var headImageView: ItemImageView!
    @IBOutlet weak var torsoImageView: ItemImageView!
    @IBOutlet weak var waistImageView: ItemImageView!
    @IBOutlet weak var legsImageView: ItemImageView!
    @IBOutlet weak var feetImageView: ItemImageView!
    @IBOutlet weak var neckImageView: ItemImageView!
    @IBOutlet weak var bracersImageView: ItemImageView!
    @IBOutlet weak var rightFingerImageView: ItemImageView!
    @IBOutlet weak var offHandImageView: ItemImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!

    @IBOutlet weak var shouldersHorizonConstraint: NSLayoutConstraint!
    @IBOutlet weak var neckHorizonConstraint: NSLayoutConstraint!
    @IBOutlet weak var handsHorizonConstraint: NSLayoutConstraint!
    @IBOutlet weak var bracersHorizonConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftFingerHorizonConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightFingerHorizonConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainHandHorizonConstraint: NSLayoutConstraint!
    @IBOutlet weak var offHandHorizonConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var heroNameLabel: UILabel!
    
    var hero: Hero?
    lazy var scale: CGFloat = self.backgroundImageView.bounds.height / 645
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidLayoutSubviews() {
        shouldersHorizonConstraint.constant = -82 * scale
        neckHorizonConstraint.constant = 79 * scale
        handsHorizonConstraint.constant = -107 * scale
        bracersHorizonConstraint.constant = 109 * scale
        leftFingerHorizonConstraint.constant = -107 * scale
        rightFingerHorizonConstraint.constant = 109 * scale
        mainHandHorizonConstraint.constant = -107 * scale
        offHandHorizonConstraint.constant = 109 * scale
        print("Scale: \(scale)")
        
        if let tabBarController = tabBarController as? HeroDetailsTabBarController, let hero = tabBarController.hero {
            loadData(hero)
        }
    }

    func loadData(hero: Hero) {
        self.hero = hero
        
        // Load Background
        if let classKey = hero.heroClass, let gender = hero.gender?.boolValue {
            let genderString = gender ? "female" : "male"
            let itemBackgroundImageFileName = "\(classKey)-\(genderString)_item_bg.jpg"
            
            backgroundImageView.image = UIImage(named: itemBackgroundImageFileName)
        }
        
        // Load Hero Name
        if let heroName = hero.name {
            heroNameLabel.text = heroName
        }
        
        // Load Items
        if let items = hero.items?.allObjects as? [BasicItem] {
            for item in items {
                if let slot = item.slot {
                    switch slot {
                    case BasicItem.SlotKeys.Torso:
                        torsoImageView.configureItemFrame(item, scale: scale)
                    case BasicItem.SlotKeys.MainHand:
                        mainHandImageView.configureItemFrame(item, scale: scale)
                    case BasicItem.SlotKeys.OffHand:
                        offHandImageView.configureItemFrame(item, scale: scale)
                    case BasicItem.SlotKeys.Bracers:
                        bracersImageView.configureItemFrame(item, scale: scale)
                    case BasicItem.SlotKeys.Feet:
                        feetImageView.configureItemFrame(item, scale: scale)
                    case BasicItem.SlotKeys.Hands:
                        handsImageView.configureItemFrame(item, scale: scale)
                    case BasicItem.SlotKeys.Head:
                        headImageView.configureItemFrame(item, scale: scale)
                    case BasicItem.SlotKeys.LeftFinger:
                        leftFingerImageView.configureItemFrame(item, scale: scale)
                    case BasicItem.SlotKeys.RightFinger:
                        rightFingerImageView.configureItemFrame(item, scale: scale)
                    case BasicItem.SlotKeys.Legs:
                        legsImageView.configureItemFrame(item, scale: scale)
                    case BasicItem.SlotKeys.Neck:
                        neckImageView.configureItemFrame(item, scale: scale)
                    case BasicItem.SlotKeys.Shoulders:
                        shouldersImageView.configureItemFrame(item, scale: scale)
                    case BasicItem.SlotKeys.Waist:
                        waistImageView.configureItemFrame(item, scale: scale)
                    default:
                        break
                    }
                }
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
