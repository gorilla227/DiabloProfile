//
//  AddVC_SearchBattleTag.swift
//  DiabloProfile
//
//  Created by Andy Xu on 8/15/16.
//  Copyright © 2016 Andy Xu. All rights reserved.
//

import UIKit

class AddVC_SearchBattleTag: UITableViewController {
    @IBOutlet weak var regionAndLocalePicker: UIPickerView!
    @IBOutlet weak var battleTagTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    
    var battleTag: String?
    var region: String?
    var locale: String?
    
    let configurations = AppDelegate.configurations()
    lazy var regionsAndLocales: [[String: AnyObject]]? = {
        if let regionsAndLocales = self.configurations?[BlizzardAPI.BasicKeys.RegionAndLocale] as? [[String: AnyObject]] {
            return regionsAndLocales
        }
        return nil
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePickerViewLayout()
        configureSearchButtonAppearance()
        configureLoadingIndicator()
        updateUIForLocalization()
    }
    
    fileprivate func configurePickerViewLayout() {
        var frame = regionAndLocalePicker.frame
        frame.size.height = frame.size.width / 3
        regionAndLocalePicker.frame = frame
    }
    
    fileprivate func configureSearchButtonAppearance() {
        searchButton.layer.cornerRadius = 5.0
        searchButton.layer.masksToBounds = true
    }
    
    fileprivate func configureLoadingIndicator() {
        tableView.addSubview(loadingIndicator)
        loadingIndicator.center = tableView.center
    }
    
    fileprivate func updateUIForLocalization() {
        let regionIndex = regionAndLocalePicker.selectedRow(inComponent: 0)
        let localeIndex = regionAndLocalePicker.selectedRow(inComponent: 1)
        if let regionDict = regionsAndLocales?[regionIndex],
        let locales = regionDict[BlizzardAPI.BasicKeys.Locales] as? [String],
            let regionString = regionDict[BlizzardAPI.BasicKeys.Region] as? String {
            
            let localeString = locales[localeIndex]
            region = regionString
            locale = localeString
            
            if let uiStrings = AppDelegate.uiStrings(locale: locale),
                let searchTitle = uiStrings["searchButtonTitle"] as? String,
                let battleTagPlaceholder = uiStrings["battleTagPlaceholder"] as? String {
                
                searchButton.setTitle(searchTitle, for: UIControlState())
                battleTagTextField.placeholder = battleTagPlaceholder
                navigationItem.title = searchTitle
            }
        }
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "SelectHeroSegue" {
            let selectHeroVC = segue.destination as! AddVC_SelectHero
            selectHeroVC.battleTag = battleTag
            selectHeroVC.heroes = sender as? [[String: Any]]
            selectHeroVC.region = region
            selectHeroVC.locale = locale
        }
    }

    // MARK: - IBActions
    @IBAction func cancelButtonOnClicked(_ sender: AnyObject) {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func searchButtonOnClicked(_ sender: AnyObject) {
        battleTagTextField.endEditing(true)
        if let region = region, let locale = locale, let battleTag = battleTag {
            loadDataUIRespond(true)
            BlizzardAPI.requestCareerProfile(region, locale: locale, battleTag: battleTag, completion: { (result, error) in
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
                    self.performSegue(withIdentifier: "SelectHeroSegue", sender: result)
                })
            })
        }
    }
}

extension AddVC_SearchBattleTag: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return regionsAndLocales?.count ?? 0
        case 1:
            let regionIndex = pickerView.selectedRow(inComponent: 0)
            if let region = regionsAndLocales?[regionIndex],
                let locales = region[BlizzardAPI.BasicKeys.Locales] as? [String] {
                return locales.count
            }
            return 0
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            if let region = regionsAndLocales?[row]{
                return region[BlizzardAPI.BasicKeys.Region] as? String
            }
        case 1:
            let regionIndex = pickerView.selectedRow(inComponent: 0)
            if let region = regionsAndLocales?[regionIndex],
                let locales = region[BlizzardAPI.BasicKeys.Locales] as? [String] {
                return locales[row]
            }
        default:
            break
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            pickerView.reloadComponent(1)
            pickerView.selectRow(0, inComponent: 1, animated: true)
        default:
            break
        }
        updateUIForLocalization()
    }
}

extension AddVC_SearchBattleTag: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let string = textField.text {
            let fixString = string.replacingOccurrences(of: " ", with: "").capitalized
            textField.text = fixString
            battleTag = fixString
        } else {
            battleTag = ""
        }
    }
}
