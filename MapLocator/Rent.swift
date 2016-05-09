//
//  Rent.swift
//  MapLocator
//
//  Created by Peter Windley Herman Jr on 4/30/16.
//  Copyright © 2016 Medigarage Studios LTD. All rights reserved.
//

import UIKit
import Charts

class Rent: UIViewController {
    
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
        
        let unitsSold = [Array2010[2],Array2011[2],Array2012[2],Array2013[2],Array2014[2]]
        
        setLineChart(months, values: unitsSold)
        
        // Do any additional setup after loading the view.
    }
    
    
    func setLineChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Median Rent (dollars)")
        
        lineChartDataSet.axisDependency = .Left // Line will correlate with left axis values
        lineChartDataSet.setColor(UIColor.blueColor().colorWithAlphaComponent(0.5))
        lineChartDataSet.setCircleColor(UIColor.blueColor())
        lineChartDataSet.lineWidth = 2.0
        lineChartDataSet.circleRadius = 6.0
        lineChartDataSet.fillAlpha = 65 / 255.0
        lineChartDataSet.fillColor = UIColor.blueColor()
        lineChartDataSet.highlightColor = UIColor.whiteColor()
        lineChartDataSet.drawCircleHoleEnabled = true
        
        let data: LineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
        data.setValueTextColor(UIColor.blackColor())
        
        lineChartView.descriptionText = ""
        
        lineChartView.data = data
        
        lineChartView.leftAxis.axisMinValue = 0
        lineChartView.rightAxis.drawLabelsEnabled = false
        lineChartView.xAxis.labelPosition = .Bottom
        lineChartView.rightAxis.drawGridLinesEnabled = false
        lineChartView.xAxis.avoidFirstLastClippingEnabled = true
        lineChartView.xAxis.setLabelsToSkip(0)
        
        lineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
    }
    
}

