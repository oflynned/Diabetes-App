//
//  ExerciseIntensityViewController.swift
//  Diabetes
//
//  Created by Ed on 20/05/2017.
//  Copyright © 2017 GlassByte. All rights reserved.
//

import UIKit

class ExerciseIntensityViewController: UIViewController {
    
    @IBOutlet weak var intensitySlider: UISlider!
    @IBOutlet weak var intensityLabel: UILabel!
    @IBOutlet weak var addIntensityButton: UIButton!
    var chosenExerciseIntensity: ChosenExercise!
    var intensity: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        intensityLabel.text = Int(intensitySlider.value).description
        intensity = Int(intensitySlider.value)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func addIntensityAction(_ sender: Any) {
        chosenExerciseIntensity.intensity = intensity
        performSegue(withIdentifier: "goToExerciseDetails", sender: chosenExerciseIntensity)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToExerciseDetails" {
            if let destination = segue.destination as? ExerciseDetailsViewController {
                destination.chosenExerciseDetails = sender as? ChosenExercise
            }
        }
    }
    @IBAction func onSliderValueChanged(_ sender: UISlider) {
        intensityLabel.text = Int(intensitySlider.value).description
        intensity = Int(intensitySlider.value)
    }
}
