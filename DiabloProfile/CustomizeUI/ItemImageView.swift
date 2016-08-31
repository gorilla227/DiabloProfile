//
//  ItemImageView.swift
//  DiabloProfile
//
//  Created by Andy Xu on 8/30/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import UIKit

class ItemImageView: UIImageView {
    let gemStackViewContainer: UIStackView = {
        let container = UIStackView()
        container.axis = .Horizontal
        container.alignment = .Center
        container.distribution = .EqualSpacing
        container.spacing = 0
        return container
    }()
    let gemStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .Vertical
        stackView.alignment = .Center
        stackView.distribution = .EqualSpacing
        stackView.spacing = 0
        return stackView
    }()
    let backgroundView = UIView()
    let equipImageView = UIImageView()
    let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
        indicator.color = UIColor.orangeColor()
        indicator.hidesWhenStopped = true
        indicator.stopAnimating()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.clearColor()
        backgroundView.layer.borderWidth = 1.0
        backgroundView.layer.cornerRadius = 5.0
        backgroundView.layer.masksToBounds = true
        equipImageView.contentMode = .ScaleAspectFill
        equipImageView.clipsToBounds = false
        
        addSubview(backgroundView)
        addSubview(equipImageView)
        addSubview(gemStackViewContainer)
        addSubview(loadingIndicator)
        
        loadingIndicator.centerXAnchor.constraintEqualToAnchor(centerXAnchor).active = true
        loadingIndicator.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
        gemStackViewContainer.addArrangedSubview(gemStackView)
    }

    func configureItemFrame(basicItem: BasicItem, scale: CGFloat) {
        if let displayColor = basicItem.displayColor {
            backgroundView.layer.borderColor = getBorderColor(displayColor).CGColor
            
            
            if let itemFrameBg = UIImage(named: "itemFrame_\(displayColor).png") {
                backgroundView.backgroundColor = UIColor(patternImage: itemFrameBg)
            } else {
                backgroundView.backgroundColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.8)
            }
        }
        
        backgroundView.frame = bounds
        equipImageView.frame = bounds
        
        if let icon = basicItem.icon {
            equipImageView.image = UIImage(data: icon)
        } else {
            if let imageURL = basicItem.iconImageURL("large") {
                loadingIndicator.startAnimating()
                BlizzardAPI.downloadImage(imageURL, completion: { (result, error) in
                    AppDelegate.performUIUpdatesOnMain({ 
                        self.loadingIndicator.stopAnimating()
                    })
                    
                    guard error == nil && result != nil else {
                        print(error?.domain, error?.localizedDescription)
                        return
                    }
                    
                    AppDelegate.performUIUpdatesOnMain({
                        basicItem.icon = result
                        self.equipImageView.image = UIImage(data: result!)
                    })
                })
            }
        }
        
        if let detailItem = basicItem.detailItem {
            addGemSocketImageViews(detailItem, scale: scale)
        } else {
            // TODO: Request DetailItem
            if let hero = basicItem.hero, let region = hero.region, let locale = hero.locale, let itemTooltipParams = basicItem.tooltipParams {
                loadingIndicator.startAnimating()
                BlizzardAPI.requestItemData(region, locale: locale, itemTooltipParams: itemTooltipParams, completion: { (result, error) in
                    AppDelegate.performUIUpdatesOnMain({ 
                        self.loadingIndicator.stopAnimating()
                    })
                    
                    guard error == nil else {
                        print(error?.domain, error?.localizedDescription)
                        return
                    }
                    
                    if let detailItemDict = result, let managedObjectContext = basicItem.managedObjectContext {
                        managedObjectContext.performBlock({ 
                            let detailItem = DetailItem(dictionary: detailItemDict, context: managedObjectContext)
                            detailItem.basicItem = basicItem
                            AppDelegate.performUIUpdatesOnMain({ 
                                self.addGemSocketImageViews(detailItem, scale: scale)
                            })
                        })
                    }
                })
            }
        }
    }
    
    private func addGemSocketImageViews(detailItem: DetailItem, scale: CGFloat) {
        if let gems = detailItem.gems?.allObjects as? [Gem] {
            // Remove all existed gemSocketImageView in stackView
            for gemSocketImageView in gemStackView.arrangedSubviews {
                gemStackView.removeArrangedSubview(gemSocketImageView)
            }
            
            gemStackViewContainer.frame = bounds
            // Add gemSocketImageView for each gem
            for gem in gems {
                let gemSocketImageView = GemSocketImageView(image: UIImage(named: "gem_frame.png"))
                gemSocketImageView.contentMode = .ScaleToFill
                
                gemSocketImageView.configureGem(gem, scale: scale)
                
                let horizonStackView = UIStackView(arrangedSubviews: [gemSocketImageView])
                horizonStackView.axis = .Horizontal
                horizonStackView.alignment = .Center
                horizonStackView.distribution = .EqualSpacing
                horizonStackView.spacing = 0
                
                gemStackView.addArrangedSubview(horizonStackView)
                
                gemSocketImageView.widthAnchor.constraintEqualToConstant(32.0 * scale).active = true
                gemSocketImageView.heightAnchor.constraintEqualToConstant(32.0 * scale).active = true
            }
        }
    }
    
    private func getBorderColor(colorKey: String) -> UIColor {
        switch colorKey {
        case "green":
            return UIColor.greenColor()
        case "orange":
            return UIColor.orangeColor()
        case "blue":
            return UIColor.blueColor()
        case "yellow":
            return UIColor.yellowColor()
        case "white":
            return UIColor.grayColor()
        default:
            return UIColor.clearColor()
        }
    }

}
