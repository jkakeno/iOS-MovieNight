//
//  ReleaseYearViewController.swift
//  MovieNight
//
//  Created by Jun Kakeno on 11/6/18.
//  Copyright © 2018 Jun Kakeno. All rights reserved.
//

import UIKit

class ReleaseYearViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    @IBOutlet weak var minReleaseYear: UIPickerView!
    @IBOutlet weak var maxReleaseYear: UIPickerView!
    
    let years = [1990,1991,1992,1993,1994,1995,1996,1997,1998,1999,2000,2001, 2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015,2016,2017,2018]
    var user1Preference: UserPreference?
    var user2Preference:UserPreference?
    
    enum Button{
        case user1
        case user2
        case none
    }
    var button:Button = .none

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initialize picker
        self.minReleaseYear.delegate = self
        self.minReleaseYear.dataSource = self
        self.maxReleaseYear.delegate = self
        self.maxReleaseYear.dataSource = self
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return years.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(describing:years[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 0:
            let minReleaseYear = String(years[row])
            
            switch button{
            case .user1:
                //Store min year release to user 1 preference
                user1Preference?.minReleaseYear = minReleaseYear

            case .user2:
                //Store min year release to user 2 preference
                user2Preference?.minReleaseYear = minReleaseYear

            case .none: return
            }
            
        case 1:
            let maxReleaseYear = String(years[row])
            
            switch button{
            case .user1:
                //Store max year release to user 1 preference
                user1Preference?.maxReleaseYear = maxReleaseYear

            case .user2:
                //Store max year release to user 2 preference
                user2Preference?.maxReleaseYear = maxReleaseYear

            case .none: return
            }
            
        default :
            print("No picker")
        }
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch button{
        case .user1:
            if user1Preference?.minReleaseYear == nil{
                showAlert(message: "Select a minimum release year")
                return false
            }else if user1Preference?.maxReleaseYear == nil{
                showAlert(message: "Select a maximum release year")
                return false
            }else{
                return true
            }
        case .user2:
            if user2Preference?.minReleaseYear == nil{
                showAlert(message: "Select a minimum release year")
                return false
            }else if user2Preference?.maxReleaseYear == nil{
                showAlert(message: "Select a maximum release year")
                return false
            }else{
                return true
            }
        case .none: return false
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Get the segue that was speficied in story board
        if segue.identifier == "landScreen" {
            //Get a navigation controller
            let viewController = segue.destination
            //Get the task controller
            let landScreenViewController = viewController as! LandScreenViewController
            
            //Pass user 1 and user 2 preference to land screen view controller
            landScreenViewController.user1Preference = user1Preference
            landScreenViewController.user2Preference = user2Preference
        }
    }
    
    func showAlert(message:String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("\"OK\" button was pressed on alert.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
