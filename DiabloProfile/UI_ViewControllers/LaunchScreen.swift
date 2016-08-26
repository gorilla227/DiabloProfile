//
//  LaunchScreen.swift
//  DiabloProfile
//
//  Created by Andy on 16/8/19.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import UIKit

class LaunchScreen: UIViewController {
    @IBOutlet weak var launchScreenImageView: UIImageView!
    
    override func viewDidAppear(animated: Bool) {
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(animationToShowMainScreen), userInfo: nil, repeats: false)
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        
        animationToShowMainScreen()
    }
    
    func animationToShowMainScreen() {
        UIView.animateWithDuration(2, animations: {
            self.launchScreenImageView.alpha = 0
            }) { (isCompleted) in
                if isCompleted {
                    self.performSegueWithIdentifier("ShowMainScreen", sender: nil)
                }
        }
    }
}
