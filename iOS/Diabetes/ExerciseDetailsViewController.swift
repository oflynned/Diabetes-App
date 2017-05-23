//
//  ExerciseDetailsViewController.swift
//  Diabetes
//
//  Created by Ed on 20/05/2017.
//  Copyright © 2017 GlassByte. All rights reserved.
//

import UIKit

class ExerciseDetailsViewController: UIViewController {
    
    @IBOutlet weak var isPlannedExerciseSwitch: UISwitch!
    @IBOutlet weak var isUnplannedExerciseSwitch: UISwitch!
    
    @IBOutlet weak var isBeforeMealSwitch: UISwitch!
    @IBOutlet weak var isAfterMealSwitch: UISwitch!
    
    @IBOutlet weak var bloodGlucoseTextField: UITextField!
    @IBOutlet weak var bloogGlucoseUnitsLabel: UILabel!
    
    @IBOutlet weak var addExerciseButton: UIButton!
    
    var chosenExerciseDetails: ChosenExercise!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(chosenExerciseDetails)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPlannedExerciseClick(_ sender: Any) {
        let state = isUnplannedExerciseSwitch.isOn
        isUnplannedExerciseSwitch.setOn(!state, animated: true)
    }

    @IBAction func onUnplannedExerciseClick(_ sender: Any) {
        let state = isPlannedExerciseSwitch.isOn
        isPlannedExerciseSwitch.setOn(!state, animated: true)
    }
    
    @IBAction func isBeforeMealClick(_ sender: Any) {
        let state = isAfterMealSwitch.isOn
        isAfterMealSwitch.setOn(!state, animated: true)
    }
    
    @IBAction func isAfterMealClick(_ sender: Any) {
        let state = isBeforeMealSwitch.isOn
        isBeforeMealSwitch.setOn(!state, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
