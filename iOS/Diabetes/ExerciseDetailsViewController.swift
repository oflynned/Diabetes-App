//
//  ExerciseDetailsViewController.swift
//  Diabetes
//
//  Created by Ed on 20/05/2017.
//  Copyright © 2017 GlassByte. All rights reserved.
//

import UIKit
import UserNotifications

class ExerciseDetailsViewController: UIViewController {
    
    @IBAction func getNotBut(_ sender: Any) {
        let content = UNMutableNotificationContent()
        
        content.title = "Test Notification - Pre workout "
        content.subtitle = "Test Subtitle - Overall text here"
        content.body = "insulin recommendation here"
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval:5, repeats:false)
        let request = UNNotificationRequest(identifier: "timeDone", content:content, trigger:trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    @IBOutlet weak var isPlannedExerciseSwitch: UISwitch!
    @IBOutlet weak var isUnplannedExerciseSwitch: UISwitch!
    
    @IBOutlet weak var isBeforeMealSwitch: UISwitch!
    @IBOutlet weak var isAfterMealSwitch: UISwitch!
    
    @IBOutlet weak var bloodGlucoseTextField: UITextField!
    @IBOutlet weak var bloogGlucoseUnitsLabel: UILabel!
    
    @IBOutlet weak var addExerciseButton: UIButton!
    
    @IBOutlet weak var approxExerciseTime: UIDatePicker!
    
    @IBOutlet weak var lastEatenLayout: UIStackView!
    
    var chosenExerciseDetails: ChosenExercise!
    var bloodGlucoseLevel: Float!

    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound, .badge], completionHandler: {didAllow, error in })
        
        print(chosenExerciseDetails)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onPlannedExerciseClick(_ sender: Any) {
        let state = isUnplannedExerciseSwitch.isOn
        isUnplannedExerciseSwitch.setOn(!state, animated: true)
        
        UIView.animate(withDuration: 0.3) {
            self.lastEatenLayout.isHidden = !state
        }
    }

    @IBAction func onUnplannedExerciseClick(_ sender: Any) {
        let state = isPlannedExerciseSwitch.isOn
        isPlannedExerciseSwitch.setOn(!state, animated: true)
        
        UIView.animate(withDuration: 0.3) {
            self.lastEatenLayout.isHidden = state
        }
    }
    
    @IBAction func isBeforeMealClick(_ sender: Any) {
        let state = isAfterMealSwitch.isOn
        isAfterMealSwitch.setOn(!state, animated: true)
    }
    
    @IBAction func isAfterMealClick(_ sender: Any) {
        let state = isBeforeMealSwitch.isOn
        isBeforeMealSwitch.setOn(!state, animated: true)
    }
    
    @IBAction func onAddExerciseClick(_ sender: Any) {
        chosenExerciseDetails.userMetaInfo.isPlanned = isPlannedExerciseSwitch.isOn
        chosenExerciseDetails.userMetaInfo.isBeforeMeal = isBeforeMealSwitch.isOn
        chosenExerciseDetails.userMetaInfo.approxTime = approxExerciseTime.date
        chosenExerciseDetails.userMetaInfo.bloodGlucoseLevel = Float(bloodGlucoseTextField.text!)
        
        print(chosenExerciseDetails)
    }
    
    func createAlert(title: String, message: String) {
        let submitAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in })
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(submitAction)
        present(alert, animated: true, completion: nil)
    }
}
