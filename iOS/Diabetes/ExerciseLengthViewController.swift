//
//  ExerciseLengthViewController.swift
//  Diabetes
//
//  Created by Ed on 20/05/2017.
//  Copyright © 2017 GlassByte. All rights reserved.
//

import UIKit

class ExerciseLengthViewController: UIViewController {
    
    @IBOutlet weak var addDurationButton: UIButton!
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
    
    @IBAction func addDurationAction(_ sender: Any) {
        let nullMetaInfo = UserExerciseMetaInfo(isPlanned: false, isBeforeMeal: false, bloodGlucoseLevel: -1)
        
        // TODO poll duration from bar
        let chosenExercise = ChosenExercise(sport: sport, duration: 0, intensity: -1, userMetaInfo: nullMetaInfo)
        performSegue(withIdentifier: "goToExerciseIntensity", sender: chosenExercise)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToExerciseIntensity" {
            if let destination = segue.destination as? ExerciseIntensityViewController {
                destination.chosenExerciseIntensity = sender as? ChosenExercise
            }
        }
    }

}
