//
//  PopulationGraphScene.swift
//  MapLocator
//
//  Created by Peter Windley Herman Jr on 4/22/16.
//  Copyright © 2016 Medigarage Studios LTD. All rights reserved.
//

import UIKit
import Charts


///TIME TO CHANGE TO TIME GRAPH OF POPULATION


class PopulationGraphScene: UIViewController {
    
    
    @IBAction func saveChart(sender: AnyObject) {
        pieChartView.saveToCameraRoll()
    }
    

    @IBOutlet weak var pieChartView: PieChartView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let background = CAGradientLayer().turquoiseColor()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, atIndex: 0)
                self.title = searchText

        let stringLabels = ["Vacant", "Occupied"]

        let intigerValues = [Array2014[4],Array2014[5]]
            
        setChart(stringLabels, values: intigerValues)

        
        }
        
        func setChart(dataPoints: [String], values: [Double]) {
            
            var dataEntries: [ChartDataEntry] = []
            
            for i in 0..<dataPoints.count {
                let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
                dataEntries.append(dataEntry)
            }
            
            let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "")
            let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
            pieChartView.data = pieChartData
            
            var colors: [UIColor] = []
            
            for i in 0..<dataPoints.count {
                let red = Double(arc4random_uniform(256))
                let green = Double(arc4random_uniform(256))
                let blue = Double(arc4random_uniform(256))
                
                let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
                colors.append(color)
            }
            
            pieChartDataSet.colors = colors
            pieChartView.descriptionText = ""

    }
}