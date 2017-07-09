//
//  ExerciseDetailsViewController.swift
//  Diabetes
//
//  Created by Ed on 20/05/2017.
//  Copyright © 2017 GlassByte. All rights reserved.
//

import UIKit
import UserNotifications
import Foundation

class ExerciseDetailsViewController: UIViewController , UIPickerViewDelegate,UNUserNotificationCenterDelegate{
    
    
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
    
    @IBAction func onPOSTapped(_ sender: Any) {
        
        let parameters = ["method": "mdi", "epoch": "before", "planning": "unplanned",
                          "exercise_type": "anaerobic", "exercise_intensity": "intense",
                          "exercise_duration": 0, "bg_level": 16] as [String : Any]
        
        
        guard let url = URL(string:"https://ec2-54-194-202-146.eu-west-1.compute.amazonaws.com/api/v1/recommendations/get-recommendation") else {return}
        
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody =  try?JSONSerialization.data(withJSONObject: parameters, options: []) else{return}
        
        request.httpBody  = httpBody
        
        let session = URLSession.shared
        session.dataTask(with:request){(data,response,error) in
            if let response = response{
                print(response)
            }
            if let data = data {
                do{
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                }
                catch{
                    print(error)
                }
            }
        }.resume()
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
      
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound, .badge], completionHandler: {didAllow, error in})
                
        
        UNUserNotificationCenter.current().delegate = self
        
 
      

        
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

    
    
    
}
