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
            intensityDetailsLabel.text = "Mild\n Very light to light activity: Easy to breath and carry out a conversation. Feels like you can maintain for hours."
            break
        case 1:
            intensityDetailsLabel.text = "Moderate\n Moderate activity: Breathing heavily, can hold short conversation. Somewhat comfortable but becoming noticeably more challenging."
            break
        case 2:
            intensityDetailsLabel.text = "Intense\n Vigorous activity: Short of breath, can speak a sentence. Borderline uncomfortable."
            break
        case 3:
            intensityDetailsLabel.text = "Extremely intense\n very hard to max effort activity: Completely out of breath, barely or unable to talk. Can only maintain for very short time."
            break
        default:
            break
        }
    }
}
