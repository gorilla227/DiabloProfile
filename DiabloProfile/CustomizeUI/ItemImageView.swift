//
//  ItemImageView.swift
//  DiabloProfile
//
//  Created by Andy Xu on 8/30/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import UIKit

class ItemImageView: UIImageView {
    @IBInspectable var showGem: Bool = true
    
    lazy var gemStackViewContainer: UIStackView = {
        let container = UIStackView()
        container.axis = .Horizontal
        container.alignment = .Center
        container.distribution = .EqualSpacing
        container.spacing = 0
        return container
    }()
    lazy var gemStackView: UIStackView = {
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
    
    var item: BasicItem?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.clearColor()
        backgroundView.layer.borderWidth = 1.0
        backgroundView.layer.cornerRadius = 5.0
        backgroundView.layer.masksToBounds = true
        equipImageView.contentMode = contentMode
        equipImageView.clipsToBounds = false
        
        addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.leadingAnchor.constraintEqualToAnchor(leadingAnchor).active = true
        backgroundView.trailingAnchor.constraintEqualToAnchor(trailingAnchor).active = true
        backgroundView.topAnchor.constraintEqualToAnchor(topAnchor).active = true
        backgroundView.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
        backgroundView.centerXAnchor.constraintEqualToAnchor(centerXAnchor).active = true
        
        addSubview(equipImageView)
        equipImageView.translatesAutoresizingMaskIntoConstraints = false
        equipImageView.leadingAnchor.constraintEqualToAnchor(leadingAnchor).active = true
        equipImageView.trailingAnchor.constraintEqualToAnchor(trailingAnchor).active = true
        equipImageView.topAnchor.constraintEqualToAnchor(topAnchor).active = true
        equipImageView.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
        
        if showGem {
            addSubview(gemStackViewContainer)
            gemStackViewContainer.translatesAutoresizingMaskIntoConstraints = false
            gemStackViewContainer.leadingAnchor.constraintEqualToAnchor(leadingAnchor).active = true
            gemStackViewContainer.trailingAnchor.constraintEqualToAnchor(trailingAnchor).active = true
            gemStackViewContainer.topAnchor.constraintEqualToAnchor(topAnchor).active = true
            gemStackViewContainer.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
            
            gemStackViewContainer.addArrangedSubview(gemStackView)
        }
        addSubview(loadingIndicator)
        
        loadingIndicator.centerXAnchor.constraintEqualToAnchor(centerXAnchor).active = true
        loadingIndicator.centerYAnchor.constraintEqualToAnchor(centerYAnchor).active = true
    }

    func configureItemFrame(basicItem: BasicItem, scale: CGFloat) {
        item = basicItem
        
        if let displayColor = basicItem.displayColor {
            backgroundView.layer.borderColor = StringAndColor.getBorderColor(displayColor).CGColor
            
            
            if let itemFrameBg = UIImage(named: "itemFrame_\(displayColor).png") {
                backgroundView.backgroundColor = UIColor(patternImage: itemFrameBg)
            } else {
                backgroundView.backgroundColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.8)
            }
        }
        
        if let icon = basicItem.icon {
            if let image = UIImage(data: icon) {
                equipImageView.image = image
                heightAnchor.constraintGreaterThanOrEqualToAnchor(widthAnchor, multiplier: image.size.height / image.size.width).active = !showGem
            }
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
                        if let image = UIImage(data: result!) {
                            self.equipImageView.image = image
                            self.heightAnchor.constraintGreaterThanOrEqualToAnchor(self.widthAnchor, multiplier: image.size.height / image.size.width).active = !self.showGem
                        }
                    })
                })
            }
        }
        
        if showGem { // Display gems in ItemImageView
            if let detailItem = basicItem.detailItem {
                addGemSocketImageViews(detailItem, scale: scale)
            } else {
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
    }
    
    private func addGemSocketImageViews(detailItem: DetailItem, scale: CGFloat) {
        if let gems = detailItem.gems?.allObjects as? [Gem] {
            // Remove all existed gemSocketImageView in stackView
            for gemSocketImageView in gemStackView.arrangedSubviews {
                gemStackView.removeArrangedSubview(gemSocketImageView)
            }
            
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
}
