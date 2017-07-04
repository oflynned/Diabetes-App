//
//  ExerciseDetailsViewController.swift
//  Diabetes
//
//  Created by Ed on 20/05/2017.
//  Copyright © 2017 GlassByte. All rights reserved.
//

import UIKit
import UserNotifications

class ExerciseDetailsViewController: UIViewController , UIPickerViewDelegate,UIPickerViewDataSource,  UNUserNotificationCenterDelegate{
    
    
    @IBAction func add_exercise(_ sender: Any) {
        
        
        
        
        
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "Diabetes App Notification", arguments: nil)
        content.subtitle = "Server not found"
        content.body = NSString.localizedUserNotificationString(forKey: "Please wait while server comes back online",arguments: nil)
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval:5, repeats:false)
        let request = UNNotificationRequest(identifier:"timeDone", content:content, trigger:trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
    }
    
    
    
    @IBOutlet weak var picker1: UIPickerView!
    
    @IBOutlet weak var picker2: UIPickerView!
    
    @IBOutlet weak var picker3: UIPickerView!
    
    var Array = ["0", "1", "2", "3","4", "5", "6", "7","8", "9"]
    
    
    
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
      
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound, .badge], completionHandler: {didAllow, error in})
                
        
        UNUserNotificationCenter.current().delegate = self
        
        picker1.delegate = self
        picker1.dataSource = self
        
        picker2.delegate = self
        picker2.dataSource = self
        
        picker3.delegate = self
        picker3.dataSource = self
        
        print(chosenExerciseDetails)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(.alert)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //
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
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Array[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Array.count
    }
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    
    
}
