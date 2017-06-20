//
//  ExerciseIntensityViewController.swift
//  Diabetes
//
//  Created by Ed on 20/05/2017.
//  Copyright © 2017 GlassByte. All rights reserved.
//

import UIKit

class ExerciseIntensityViewController: UIViewController {
    
    @IBOutlet weak var intensityDetailsLabel: UILabel!
    @IBOutlet weak var intensitySelectionSegment: UISegmentedControl!
    @IBOutlet weak var addIntensityButton: UIButton!
    
    var chosenExerciseIntensity: ChosenExercise!
    var intensity: Int = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        intensityDetailsLabel.text = "Mild"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func addIntensityAction(_ sender: Any) {
        // need to tier this, only 4 segments, but is out of 10
        chosenExerciseIntensity.intensity = intensitySelectionSegment.selectedSegmentIndex
        performSegue(withIdentifier: "goToExerciseDetails", sender: chosenExerciseIntensity)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToExerciseDetails" {
            if let destination = segue.destination as? ExerciseDetailsViewController {
                destination.chosenExerciseDetails = sender as? ChosenExercise
            }
        }
    }
    
    @IBAction func onSegmentedControlClick(_ sender: UISegmentedControl) {
        
        switch intensitySelectionSegment.selectedSegmentIndex {
        case 0:
            intensityDetailsLabel.text = "Mild"
            break
        case 1:
            intensityDetailsLabel.text = "Moderate"
            break
        case 2:
            intensityDetailsLabel.text = "Intense"
            break
        case 3:
            intensityDetailsLabel.text = "Extremely intense"
            break
        default:
            break
        }
    }
}
