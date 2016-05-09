//
//  ViewControllerGraphPicker.swift
//  MapLocator
//
//  Created by Peter Windley Herman Jr on 4/22/16.
//  Copyright © 2016 Medigarage Studios LTD. All rights reserved.
//

import UIKit

var Array2014 = [Double]()
var Array2013 = [Double]()
var Array2012 = [Double]()
var Array2011 = [Double]()
var Array2010 = [Double]()

class ViewControllerGraphPicker: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let background = CAGradientLayer().turquoiseColor()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, atIndex: 0)
        
        Array2014 = Array(universalArray[0...7])
        print(Array2014)
        Array2013 = Array(universalArray[8...15])
        print(Array2013)
        Array2012 = Array(universalArray[16...23])
        print(Array2012)
        Array2011 = Array(universalArray[24...31])
        print(Array2011)
        Array2010 = Array(universalArray[32...39])
        print(Array2010)

    }

}
