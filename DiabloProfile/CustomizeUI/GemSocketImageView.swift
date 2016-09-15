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
        imageView.contentMode = .scaleToFill
        self.addSubview(imageView)
        self.addSubview(self.loadingIndicator)
        self.loadingIndicator.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        self.loadingIndicator.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        indicator.color = UIColor.orange
        indicator.hidesWhenStopped = true
        indicator.stopAnimating()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    func configureGem(_ gem: Gem, scale: CGFloat) {
        gemImageView.widthAnchor.constraint(equalToConstant: 20 * scale).isActive = true
        gemImageView.heightAnchor.constraint(equalToConstant: 20 * scale).isActive = true
        gemImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        gemImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        if let gemIconData = gem.basicItem?.icon {
            gemImageView.image = UIImage(data: gemIconData as Data)
        } else {
            // Download Gem Icon
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
