//
//  ExerciseIntensityViewController.swift
//  Diabetes
//
//  Created by Ed on 20/05/2017.
//  Copyright © 2017 GlassByte. All rights reserved.
//

import UIKit

class ExerciseIntensityViewController: UIViewController {
    
    @IBOutlet weak var addIntensityButton: UIButton!
    var chosenExerciseIntensity: ChosenExercise!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func addIntensityAction(_ sender: Any) {
        // TODO poll duration from bar
        chosenExerciseIntensity.intensity = 0
        performSegue(withIdentifier: "goToExerciseDetails", sender: chosenExerciseIntensity)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToExerciseDetails" {
            if let destination = segue.destination as? ExerciseDetailsViewController {
                destination.chosenExerciseDetails = sender as? ChosenExercise
            }
        }
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
