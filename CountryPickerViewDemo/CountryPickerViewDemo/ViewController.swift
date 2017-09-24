//
//  ViewController.swift
//  CountryPickerViewDemo
//
//  Created by Kizito Nwose on 18/09/2017.
//  Copyright © 2017 Kizito Nwose. All rights reserved.
//

import UIKit
import CountryPickerView

class DemoViewController: UITableViewController {

    @IBOutlet weak var searchBarPosition: UISegmentedControl!
    @IBOutlet weak var showPhoneCodeInView: UISwitch!
    @IBOutlet weak var showCountryCodeInView: UISwitch!
    @IBOutlet weak var showPreferredCountries: UISwitch!
    @IBOutlet weak var showPhoneCodeInList: UISwitch!
    @IBOutlet weak var countryPickerViewMain: CountryPickerView!
    
    @IBOutlet weak var phoneNumberField: UITextField!
    weak var countryPickerViewTextField: CountryPickerView!
    @IBOutlet weak var countryPickerViewIndependent: CountryPickerView!
    let countryPickerInternal = CountryPickerView()
    
    @IBOutlet weak var presentationStyle: UISegmentedControl!
    @IBOutlet weak var selectCountryButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
       
        let cp = CountryPickerView(frame: CGRect(x: 0, y: 0, width: 120, height: 20))
        phoneNumberField.leftView = cp
        phoneNumberField.leftViewMode = .always
        self.countryPickerViewTextField = cp

        countryPickerViewMain.tag = 1
        countryPickerViewTextField.tag = 2
        countryPickerViewIndependent.tag = 3
        
        [countryPickerViewMain, countryPickerViewTextField,
         countryPickerViewIndependent, countryPickerInternal].forEach {
            $0?.dataSource = self
        }
        
        countryPickerInternal.delegate = self
        countryPickerViewMain.countryDetailsLabel.font = UIFont.systemFont(ofSize: 20)
        
        [showPhoneCodeInView, showCountryCodeInView].forEach {
            $0.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        }
        
        selectCountryButton.addTarget(self, action: #selector(selectCountryAction(_:)), for: .touchUpInside)
    }
    
    func switchValueChanged(_ sender: UISwitch) {
        switch sender {
        case showCountryCodeInView:
            countryPickerViewMain.showCountryCodeInView = sender.isOn
        case showPhoneCodeInView:
            countryPickerViewMain.showPhoneCodeInView = sender.isOn
        default: break
        }
    }
    
    func selectCountryAction(_ sender: Any) {
        switch presentationStyle.selectedSegmentIndex {
        case 0:
            if let nav = navigationController {
                countryPickerInternal.showCountriesList(from: nav)
            }
        case 1: countryPickerInternal.showCountriesList(from: self)
        default: break
        }
    }
}

extension DemoViewController: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        // Only countryPickerInternal has it's delegate set
        let message = "Name: \(country.name) \nCode: \(country.code) \nPhone: \(country.phoneCode)"
        let alert = UIAlertController(title: "Selected Country", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension DemoViewController: CountryPickerViewDataSource {
    func preferredCountries(in countryPickerView: CountryPickerView) -> [Country]? {
        if countryPickerView.tag == countryPickerViewMain.tag && showPreferredCountries.isOn {
            var countries = [Country]()
            ["NG", "US", "GB"].forEach { code in
                if let country = countryPickerView.getCountryByCode(code) {
                    countries.append(country)
                }
            }
            return countries
        }
        return nil
    }
    
    func sectionTitleForPreferredCountries(in countryPickerView: CountryPickerView) -> String? {
        if countryPickerView.tag == countryPickerViewMain.tag && showPreferredCountries.isOn {
            return "Preferred Countries"
        }
        return nil
    }
    
    func navigationTitle(in countryPickerView: CountryPickerView) -> String? {
        return "Select a Country"
    }
    
    func closeButtonNavigationItem(in countryPickerView: CountryPickerView) -> UIBarButtonItem? {
        return nil
    }
    
    func searchBarPosition(in countryPickerView: CountryPickerView) -> SearchBarPosition {
        switch searchBarPosition.selectedSegmentIndex {
        case 0: return .tableViewHeader
        case 1: return .navigationBar
        default: return .hidden
        }
    }
    
    func showPhoneCodeInList(in countryPickerView: CountryPickerView) -> Bool? {
        return showPhoneCodeInList.isOn
    }
}

