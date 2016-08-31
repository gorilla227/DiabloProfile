//
//  GemSocketImageView.swift
//  DiabloProfile
//
//  Created by Andy Xu on 8/30/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import UIKit

class GemSocketImageView: UIImageView {
    lazy var gemImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleToFill
        self.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
        indicator.color = UIColor.orangeColor()
        indicator.hidesWhenStopped = true
        indicator.stopAnimating()
        self.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor).active = true
        indicator.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
        return indicator
    }()

    
    func configureGem(gem: Gem, scale: CGFloat) {
        gemImageView.widthAnchor.constraintEqualToConstant(20 * scale).active = true
        gemImageView.heightAnchor.constraintEqualToConstant(20 * scale).active = true
        gemImageView.centerXAnchor.constraintEqualToAnchor(centerXAnchor).active = true
        gemImageView.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true

        if let gemIconData = gem.basicItem?.icon {
            gemImageView.image = UIImage(data: gemIconData)
        } else {
            // TODO: Download Gem Icon
            gemImageView.image = UIImage(named: "rune_a.png")
            if let iconURL = gem.basicItem?.iconImageURL("small") {
                loadingIndicator.startAnimating()
                BlizzardAPI.downloadImage(iconURL, completion: { (result, error) in
                    AppDelegate.performUIUpdatesOnMain({ 
                        self.loadingIndicator.stopAnimating()
                    })
                    
                    guard error == nil && result != nil else {
                        print(error?.domain, error?.localizedDescription)
                        return
                    }
                    
                    AppDelegate.performUIUpdatesOnMain({ 
                        gem.basicItem?.icon = result
                        self.gemImageView.image = UIImage(data: result!)
                    })
                })
            }
        }
    }
}
