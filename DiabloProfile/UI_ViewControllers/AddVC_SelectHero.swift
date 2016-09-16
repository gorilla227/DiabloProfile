//
//  AddVC_SelectHero.swift
//  DiabloProfile
//
//  Created by Andy Xu on 8/16/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import UIKit

class AddVC_SelectHero: UITableViewController {
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    var heroes: [[String: Any]]?
    var battleTag: String?
    var region: String?
    var locale: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = battleTag
        
        configureLoadingIndicator()
    }
    
    fileprivate func configureLoadingIndicator() {
        tableView.addSubview(loadingIndicator)
        loadingIndicator.center = tableView.center
    }
    
    fileprivate func loadDataUIRespond(_ loading: Bool) {
        AppDelegate.performUIUpdatesOnMain {
            if loading {
                self.loadingIndicator.startAnimating()
                self.tableView.isUserInteractionEnabled = false
            } else {
                self.loadingIndicator.stopAnimating()
                self.tableView.isUserInteractionEnabled = true
            }
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return heroes?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HeroCell", for: indexPath) as! HeorListVC_HeroCell
        let hero = heroes![indexPath.row]

        // Configure the cell...
        cell.configureCell(heroData: hero, locale: locale)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hero = heroes![indexPath.row]
        if let region = region, let locale = locale, let battleTag = battleTag, let heroId = hero[Hero.Keys.ID] as? NSNumber {
            loadDataUIRespond(true)
            
            BlizzardAPI.requestHeroProfile(region, locale: locale, battleTag: battleTag, heroId: heroId, completion: { (result, error) in
                self.loadDataUIRespond(false)
                
                guard error == nil else {
                    if let errorInfo = error?.userInfo[NSLocalizedDescriptionKey] as? [String: String] {
                        let warning = UIAlertController(title: errorInfo[BlizzardAPI.ResponseKeys.ErrorCode], message: errorInfo[BlizzardAPI.ResponseKeys.ErrorReason], preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        warning.addAction(okAction)
                        AppDelegate.performUIUpdatesOnMain({
                            self.present(warning, animated: true, completion: nil)
                        })
                    }
                    return
                }
                
                AppDelegate.performUIUpdatesOnMain({
                    self.performSegue(withIdentifier: "HeroDetailSegue", sender: result)
                })
            })
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "HeroDetailSegue" {
            let heroDetailVC = segue.destination as! HeroDetailsTabBarController
            heroDetailVC.heroData = sender as? [String: AnyObject]
        }
    }

}
