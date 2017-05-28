//
//  ExerciseLengthViewController.swift
//  Diabetes
//
//  Created by Ed on 20/05/2017.
//  Copyright © 2017 GlassByte. All rights reserved.
//

import UIKit

class ExerciseLengthViewController: UIViewController {
    
    @IBOutlet weak var countStepper: UIStepper!
    @IBOutlet weak var durationCountLabel: UILabel!
    @IBOutlet weak var addDurationButton: UIButton!
    var sport: Sport!
    var duration: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        countStepper.value = 0
        durationCountLabel.text = Int(countStepper.value).description
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addDurationAction(_ sender: Any) {
        let nullMetaInfo = UserExerciseMetaInfo(isPlanned: false, isBeforeMeal: false, bloodGlucoseLevel: -1)
        let chosenExercise = ChosenExercise(sport: sport, duration: duration, intensity: -1, userMetaInfo: nullMetaInfo)
        performSegue(withIdentifier: "goToExerciseIntensity", sender: chosenExercise)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToExerciseIntensity" {
            if let destination = segue.destination as? ExerciseIntensityViewController {
                destination.chosenExerciseIntensity = sender as? ChosenExercise
            }
        }
    }

    @IBAction func onStepperClick(_ sender: UIStepper) {
        durationCountLabel.text = Int(sender.value).description
        duration = Int(sender.value)
    }
}
