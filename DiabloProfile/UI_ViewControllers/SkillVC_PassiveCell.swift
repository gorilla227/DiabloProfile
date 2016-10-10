//
//  SkillVC_PassiveCell.swift
//  DiabloProfile
//
//  Created by Andy on 2016/9/24.
//  Copyright © 2016年 Andy Xu. All rights reserved.
//

import UIKit

class SkillVC_PassiveCell: UITableViewCell {
    @IBOutlet weak var skillIconImageView: UIImageView!
    @IBOutlet weak var skillNameLabel: UILabel!

    let loadingIndicator = UIActivityIndicatorView()
    let bgView = UIImageView(image: UIImage(named: "passiveSkillBG.png"))
    let bgViewSelected = UIImageView(image: UIImage(named: "passiveSkillBG_bright.png"))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contentView.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 250 / 77).isActive = true

        backgroundView = bgView
        bgView.contentMode = .scaleAspectFit
        bgView.highlightedImage = UIImage(named: "skillBG_light.png")
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        bgView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        bgView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        bgView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
        bgView.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 250 / 77).isActive = true
        
        loadingIndicator.color = UIColor.orange
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.startAnimating()
        skillIconImageView.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.centerXAnchor.constraint(equalTo: skillIconImageView.centerXAnchor).isActive = true
        loadingIndicator.centerYAnchor.constraint(equalTo: skillIconImageView.centerYAnchor).isActive = true
        
        skillIconImageView.image = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            selectedBackgroundView = bgViewSelected
            bgViewSelected.contentMode = .scaleAspectFit
            bgViewSelected.translatesAutoresizingMaskIntoConstraints = false
            bgViewSelected.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
            bgViewSelected.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
            bgViewSelected.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
            bgViewSelected.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true
            bgViewSelected.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 250 / 77).isActive = true
        } else {
            selectedBackgroundView = nil
        }    }
    
    func configureCell(skill: Skill) {
        skillNameLabel.text = skill.name
        
        if let skillIcon = skill.icon {
            skillIconImageView.image = UIImage(data: skillIcon as Data)
            loadingIndicator.stopAnimating()
            layoutIfNeeded()
        } else if let skillIconURL = skill.skillIconImageURL() {
            skillIconImageView.image = nil
            loadingIndicator.startAnimating()
            
            print("DownloadImage from Web")
            BlizzardAPI.downloadImage(skillIconURL, completion: { (result, error) in
                guard error == nil && result != nil else {
                    print(error?.domain, error?.localizedDescription)
                    return
                }
                
                AppDelegate.performUIUpdatesOnMain({
                    skill.icon = result
                    self.skillIconImageView.image = UIImage(data: result!)
                    self.loadingIndicator.stopAnimating()
                    self.layoutIfNeeded()
                })
            })
        }
    }

}
