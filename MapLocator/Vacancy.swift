//
//  Vacancy.swift
//  MapLocator
//
//  Created by Peter Windley Herman Jr on 4/30/16.
//  Copyright © 2016 Medigarage Studios LTD. All rights reserved.
//

import UIKit
import Charts

class Vacancy: UIViewController {

    
    
    @IBAction func saveChart(sender: AnyObject) {
        lineChartView.saveToCameraRoll()
        
    }
    @IBOutlet weak var lineChartView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let background = CAGradientLayer().turquoiseColor()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, atIndex: 0)
        
        
        self.title = searchText
        
        let months = ["2010","2011","2012","2013", "2014"]
        
        let unitsSold = [Array2010[4],Array2011[4],Array2012[4],Array2013[4],Array2014[4]]
        
        setLineChart(months, values: unitsSold)
        
        // Do any additional setup after loading the view.
    }
    
    
    func setLineChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Vacant Units")
        
        lineChartDataSet.axisDependency = .Left // Line will correlate with left axis values
        lineChartDataSet.setColor(UIColor.redColor().colorWithAlphaComponent(0.5)) // our line's opacity is 50%
        lineChartDataSet.setCircleColor(UIColor.redColor()) // our circle will be dark red
        lineChartDataSet.lineWidth = 2.0
        lineChartDataSet.circleRadius = 6.0 // the radius of the node circle
        lineChartDataSet.fillAlpha = 65 / 255.0
        lineChartDataSet.fillColor = UIColor.blueColor()
        lineChartDataSet.highlightColor = UIColor.whiteColor()
        lineChartDataSet.drawCircleHoleEnabled = true
        
        let data: LineChartData = LineChartData(xVals: values, dataSet: lineChartDataSet)
        data.setValueTextColor(UIColor.whiteColor())
        
        lineChartView.descriptionText = ""
        
        lineChartView.data = data
        
        lineChartView.leftAxis.axisMinValue = 0
        lineChartView.rightAxis.drawLabelsEnabled = false
        
        
    }
    
}

