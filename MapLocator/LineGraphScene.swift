//
//  LineGraphScene.swift
//  MapLocator
//
//  Created by Peter Windley Herman Jr on 4/29/16.
//  Copyright © 2016 Medigarage Studios LTD. All rights reserved.
//

import UIKit
import Charts

class LineGraphScene: UIViewController {
    
    @IBAction func saveChart(sender: AnyObject) {
        linechartview.saveToCameraRoll()
    }
    
    
    @IBOutlet weak var linechartview: LineChartView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let background = CAGradientLayer().turquoiseColor()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, atIndex: 0)
        
        self.title = searchText
        
        let months = ["2010","2011","2012","2013", "2014"]
        
        let unitsSold = [Array2010[3],Array2011[3],Array2012[3],Array2013[3],Array2014[3]]
        
         setLineChart(months, values: unitsSold)

        // Do any additional setup after loading the view.
    }
    
    
    func setLineChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Populaiton")
        
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
        
        linechartview.descriptionText = ""
        
        linechartview.data = data
        
        linechartview.leftAxis.axisMinValue = 0
        linechartview.rightAxis.drawLabelsEnabled = false
        
        
        }
        
    }

