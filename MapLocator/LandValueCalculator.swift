//
//  LandValueCalculator.swift
//  MapLocator
//
//  Created by Peter Windley Herman Jr on 4/30/16.
//  Copyright © 2016 Medigarage Studios LTD. All rights reserved.
//

import UIKit

class LandValueCalculator: UIViewController {
    @IBOutlet weak var averageRentLabel: UILabel!
    @IBOutlet weak var averageVacancyRateLabel: UILabel!
    @IBOutlet weak var averageRen: UITextField!
    @IBOutlet weak var numOfUnits: UITextField!
    @IBOutlet weak var vacancyRate: UITextField!
    @IBOutlet weak var expenses: UITextField!
    @IBOutlet weak var capRate: UITextField!
    @IBOutlet weak var constructionCost: UITextField!
    @IBOutlet weak var parcelSize: UITextField!

    @IBOutlet weak var landPrice: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLabels()
    }
    
    @IBAction func getLandPrice(sender: AnyObject) {
       let averageRentD =  Double(self.averageRen.text!)
       let numOfUnitsD = Double(self.numOfUnits.text!)
       let vacancyRateD = Double(self.vacancyRate.text!)
       let expensesD = Double(self.expenses.text!)
       let capRateD = Double(self.capRate.text!)
       let constructionCostD = Double(self.constructionCost.text!)
       let parcelSizeD = Double(self.parcelSize.text!)
        
        
        let grossRent = 12 * averageRentD! * (numOfUnitsD! * (1-vacancyRateD!))
        print(grossRent)
        
        let NOI = grossRent - expensesD!
        print(NOI)
        
        let totalDevValue = (NOI/capRateD!) - constructionCostD!
        
        
        print(totalDevValue)
        let perSqftValue = totalDevValue/parcelSizeD!
        let perSqftValueText = String(format:"%f.1", perSqftValue)
        
        self.landPrice.text = "$" + perSqftValueText
    }

    func setLabels() {
        let avgRent = Array2014[2]
        let averageRentText = String(format:"%f.1", avgRent)
        self.averageRentLabel.text = "$" + averageRentText
        
        let avgVacancy = (Array2014[4]/(Array2014[5] + Array2014[4]))
        let averageVacancyText = String(format:"%f.1", avgVacancy)
        self.averageVacancyRateLabel.text = averageVacancyText
        
    }
    

}
