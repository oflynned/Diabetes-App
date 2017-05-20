//
//  ExerciseLengthViewController.swift
//  Diabetes
//
//  Created by Ed on 20/05/2017.
//  Copyright © 2017 GlassByte. All rights reserved.
//

import UIKit

class ExerciseLengthViewController: UIViewController {
    
    var sport: Sport!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print(sport.name + " was selected")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
