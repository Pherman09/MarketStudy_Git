//
//  introScene.swift
//  MapLocator
//
//  Created by Peter Windley Herman Jr on 4/22/16.
//  Copyright © 2016 Medigarage Studios LTD. All rights reserved.
//

import UIKit

class introScene: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("start")

        let background = CAGradientLayer().turquoiseColor()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, atIndex: 0)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var getStartedButton: UIButton!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        UIView.animateWithDuration(4, animations: {
            self.getStartedButton.alpha = 0
            self.getStartedButton.alpha = 0.025
            self.getStartedButton.alpha = 0.05
            self.getStartedButton.alpha = 0.075
            self.getStartedButton.alpha = 1.0
        })
    }

}
