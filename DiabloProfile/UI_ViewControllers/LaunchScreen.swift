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
    var launched = false
    
    override func viewDidAppear(_ animated: Bool) {
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(animationToShowMainScreen), userInfo: nil, repeats: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if !launched {
            animationToShowMainScreen()
        }
    }
    
    func animationToShowMainScreen() {
        UIView.animate(withDuration: 2, animations: {
            self.launchScreenImageView.alpha = 0
        }, completion: { (isCompleted) in
            if isCompleted {
                self.performSegue(withIdentifier: "ShowMainScreen", sender: nil)
            }
        }) 
        launched = true
    }
}
