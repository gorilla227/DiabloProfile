//
//  WarningView.swift
//  DiabloProfile
//
//  Created by Andy Xu on 8/21/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func presentWarningView(title: String?, message: String?) {
        let warning = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        warning.addAction(okAction)
        AppDelegate.performUIUpdatesOnMain({
            self.presentViewController(warning, animated: true, completion: nil)
        })
    }
}
