//
//  EquipmentVC.swift
//  DiabloProfile
//
//  Created by Andy Xu on 8/29/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import UIKit

class EquipmentVC: UIViewController {
    @IBOutlet weak var shouldersImageView: UIImageView!
    @IBOutlet weak var handsImageView: UIImageView!
    @IBOutlet weak var leftFingerImageView: UIImageView!
    @IBOutlet weak var mainHandImageView: UIImageView!
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var torseImageView: UIImageView!
    @IBOutlet weak var waistImageView: UIImageView!
    @IBOutlet weak var legsImageView: UIImageView!
    @IBOutlet weak var feetImageView: UIImageView!
    @IBOutlet weak var neckImageView: UIImageView!
    @IBOutlet weak var bracersImageView: UIImageView!
    @IBOutlet weak var rightFingerImageView: UIImageView!
    @IBOutlet weak var offHandImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        headImageView.layer.borderColor = UIColor.greenColor().CGColor
        headImageView.layer.borderWidth = 1.0
        headImageView.layer.cornerRadius = 5.0
        headImageView.layer.masksToBounds = true
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
