//
//  ItemImageView.swift
//  DiabloProfile
//
//  Created by Andy Xu on 8/30/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import UIKit

protocol ItemImageViewDelegate {
    func itemImageViewTapped(itemImageView: ItemImageView)
}

class ItemImageView: UIImageView {
    @IBInspectable var showGem: Bool = true
    @IBInspectable var itemScale: CGFloat = 1.0
    @IBInspectable var allowItemOutOfWireFrame: Bool = false
    
    var delegate: ItemImageViewDelegate?
    lazy var tapGesture: UITapGestureRecognizer = {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureTapped))
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.numberOfTapsRequired = 1
        tapGesture.cancelsTouchesInView = true
        tapGesture.delaysTouchesBegan = true
        tapGesture.delaysTouchesEnded = false
        return tapGesture
    }()
    lazy var gemStackViewContainer: UIStackView = {
        let container = UIStackView()
        container.axis = .horizontal
        container.alignment = .center
        container.distribution = .equalSpacing
        container.spacing = 0
        return container
    }()
    lazy var gemStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 0
        return stackView
    }()
    let backgroundView = UIView()
    let equipImageView = UIImageView()
    let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicator.color = UIColor.orange
        indicator.hidesWhenStopped = true
        indicator.stopAnimating()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    
    var item: BasicItem?
    var legendaryPower: LegendaryPower?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        addGestureRecognizer(tapGesture)
        backgroundColor = UIColor.clear
        backgroundView.layer.borderWidth = 1.0
        backgroundView.layer.cornerRadius = 5.0
        backgroundView.layer.masksToBounds = true
        equipImageView.contentMode = contentMode
        equipImageView.clipsToBounds = false
        
        addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        backgroundView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        addSubview(equipImageView)
        equipImageView.translatesAutoresizingMaskIntoConstraints = false
        equipImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        equipImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        equipImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: itemScale).isActive = true
        equipImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: itemScale).isActive = allowItemOutOfWireFrame
        
        if showGem {
            addSubview(gemStackViewContainer)
            gemStackViewContainer.translatesAutoresizingMaskIntoConstraints = false
            gemStackViewContainer.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            gemStackViewContainer.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            gemStackViewContainer.topAnchor.constraint(equalTo: topAnchor).isActive = true
            gemStackViewContainer.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            
            gemStackViewContainer.addArrangedSubview(gemStackView)
        }
        addSubview(loadingIndicator)
        
        loadingIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    func configureItemFrame(_ basicItem: BasicItem, scale: CGFloat) {
        item = basicItem
        
        if let displayColor = basicItem.displayColor {
            backgroundView.layer.borderColor = StringAndColor.getBorderColor(displayColor).cgColor
            
            
            if let itemFrameBg = UIImage(named: "itemFrame_\(displayColor).png") {
                backgroundView.backgroundColor = UIColor(patternImage: itemFrameBg)
            } else {
                backgroundView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.8)
            }
        }
        
        if let icon = basicItem.icon {
            if let image = UIImage(data: icon) {
                equipImageView.image = image
                heightAnchor.constraint(greaterThanOrEqualTo: widthAnchor, multiplier: image.size.height / image.size.width).isActive = !showGem
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
                            self.heightAnchor.constraint(greaterThanOrEqualTo: self.widthAnchor, multiplier: image.size.height / image.size.width).isActive = !self.showGem
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
                            managedObjectContext.perform({ 
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
    
    func configureLegendaryPower(_ legendaryPower: LegendaryPower, type: Int) {
        self.legendaryPower = legendaryPower
        backgroundView.layer.borderColor = UIColor.clear.cgColor
        
        if legendaryPower.iconKey != nil {
            image = UIImage(named: "legendaryPowersBG_active.png")
            
            if let icon = legendaryPower.icon, let image = UIImage(data: icon) {
                equipImageView.image = image
            } else {
                if let imageURL = legendaryPower.iconImageURL("large") {
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
                            legendaryPower.icon = result
                            if let image = UIImage(data: result!) {
                                self.equipImageView.image = image
                            }
                        })
                    })
                }
            }
        } else {
            equipImageView.image = nil
            switch type {
            case 0:
                image = UIImage(named: "legendaryPowers_weapon.png")
            case 1:
                image = UIImage(named: "legendaryPowers_armor.png")
            case 2:
                image = UIImage(named: "legendaryPowers_jewelry.png")
            default:
                break
            }
        }
    }
    
    fileprivate func addGemSocketImageViews(_ detailItem: DetailItem, scale: CGFloat) {
        if let gems = detailItem.gems?.allObjects as? [Gem] {
            // Remove all existed gemSocketImageView in stackView
            for gemSocketImageView in gemStackView.arrangedSubviews {
                gemStackView.removeArrangedSubview(gemSocketImageView)
            }
            
            // Add gemSocketImageView for each gem
            for gem in gems {
                let gemSocketImageView = GemSocketImageView(image: UIImage(named: "gem_frame.png"))
                gemSocketImageView.contentMode = .scaleToFill
                
                gemSocketImageView.configureGem(gem, scale: scale)
                
                let horizonStackView = UIStackView(arrangedSubviews: [gemSocketImageView])
                horizonStackView.axis = .horizontal
                horizonStackView.alignment = .center
                horizonStackView.distribution = .equalSpacing
                horizonStackView.spacing = 0
                
                gemStackView.addArrangedSubview(horizonStackView)
                
                gemSocketImageView.widthAnchor.constraint(equalToConstant: 32.0 * scale).isActive = true
                gemSocketImageView.heightAnchor.constraint(equalToConstant: 32.0 * scale).isActive = true
            }
        }
    }
    
    func tapGestureTapped() {
        if let delegate = delegate {
            delegate.itemImageViewTapped(itemImageView: self)
        }
    }
}
