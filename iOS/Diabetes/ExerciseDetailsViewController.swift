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
class ExerciseDetailsViewController: UIViewController ,  UNUserNotificationCenterDelegate{
    
    var nsdata : Any!
    var chosenExerciseDetails: ChosenExercise!
    var bloodGlucoseLevel: Float!
    

    
    
    @IBAction func onPOSTapped(_ sender: Any) {
        

        let exercise_type = String(describing: chosenExerciseDetails.sport.exercise.self)
        let exercise_genre = String(describing: chosenExerciseDetails.sport.genre.self)
        let exercise_duration = Int(chosenExerciseDetails.duration.self)
        var exercise_planning = String(chosenExerciseDetails.userMetaInfo.isPlanned.self)
        var exercise_meal = String(chosenExerciseDetails.userMetaInfo.isBeforeMeal.self)
         var exercise_intensity = Int( chosenExerciseDetails.intensity.self)
        var exercise_intensity1 = String()
        var exercise_epoch = String()
        
        
        var current_date = chosenExerciseDetails.userMetaInfo.approxTime
        print("cd",current_date)
        let exercise_date = chosenExerciseDetails.userMetaInfo.exerciseTime
        print("ed",exercise_date)
        
        if(exercise_date!==nil)
        {
            exercise_epoch = "after"
        }
        if(current_date! >= exercise_date!)
        {
            exercise_epoch = "after"
        }
        if(current_date! < exercise_date!)
        {
            exercise_epoch = "before"
        }
        if(current_date! == exercise_date!)
        {
            exercise_epoch = "before"
        }

        print("ep",exercise_epoch)

    
        
        
        
        if(exercise_planning == "false"){
            exercise_planning = "planned"
        }
        else{
            exercise_planning = "unplanned"
        }
       
        if(exercise_meal == "false"){
           exercise_meal = "within_3_hrs_of_meal"
        }
        else{
           exercise_meal = "more_than_3_hrs_after_meal"
        }
        
        if(exercise_intensity == 0){
            exercise_intensity1 = "mild"
        }
        if(exercise_intensity == 1){
            exercise_intensity1 = "moderate"
        }
        if(exercise_intensity == 2){
            exercise_intensity1 = "intense"
        }
        if(exercise_intensity == 3){
            exercise_intensity1 = "extremely_intense"
        }

        
       
        print("====",exercise_intensity1)
        print("====",type(of:exercise_intensity) )
        //print("Value is \(exercise_duration1 as Int?)")
        print(chosenExerciseDetails)

    
        
        
     
        
        let parameters = [		"email":"suleaa@hotmail.ie",
                          		"method": "mdi",
                          		"epoch": exercise_epoch,
                          		"planning": exercise_planning,
                          		"exercise_type": exercise_type,
                          		"exercise_intensity": exercise_intensity1,
                          		"meal_timing": exercise_meal,
                          		"exercise_genre": exercise_genre,
                          		"exercise_duration": 0,
                          		"bg_level":20] as [String : Any]
        
        
        guard let url = URL(string:"https://neurobranchbeta.com/api/v1/recommendations/get") else {return}
        
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody =  try?JSONSerialization.data(withJSONObject: parameters, options: []) else{return}
        
        request.httpBody  = httpBody
        var string4: String?
        let session = URLSession.shared
        session.dataTask(with:request){(data,response,error) in
            if let response = response{
                //print("response",response)
            }
            if let data = data {
                do{
                let json =  try JSONSerialization.jsonObject(with: data, options: [])
                    if json is [String] {
                        // obj is a string array
                       // print("json",json)
                     
                        for obj in json as! [AnyObject]{
                            if obj is String {
                                if string4 == nil {
                                    string4 = obj as! String
                               
                                }
                                else {
                                    string4 = "\n" + string4! + ", \n" + (obj as! String)
                                }
                                
                            }
                            else{
                            print("PROBLEM1")
                            }
                        }
                    }
                    else {
                        // obj is not a string array or else
                        //print(type(of: json))
                    }
                    //print("string4",string4)
                    
                    let content = UNMutableNotificationContent()
                    content.title = NSString.localizedUserNotificationString(forKey: "Diabetes App", arguments: nil)
                    content.subtitle = "Reccomendation"
                    content.body = NSString.localizedUserNotificationString(forKey: string4!,arguments: nil)
                
                    content.badge = 1
               
                    
                    
                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval:5, repeats:false)
                    let request2 = UNNotificationRequest(identifier:"timeDone", content:content, trigger:trigger)
                    UNUserNotificationCenter.current().add(request2, withCompletionHandler: nil)
                    
                    
                    
                    
                 
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
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound, .badge], completionHandler: {didAllow, error in})
                
        
        UNUserNotificationCenter.current().delegate = self

        
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
        print("Planned Clicked")
        chosenExerciseDetails.userMetaInfo.isPlanned=false
        
        UIView.animate(withDuration: 0.3) {
            self.lastEatenLayout.isHidden = !state
        }
    }
    
    @IBAction func onUnplannedExerciseClick(_ sender: Any) {
        let state = isPlannedExerciseSwitch.isOn
        isPlannedExerciseSwitch.setOn(!state, animated: true)
        chosenExerciseDetails.userMetaInfo.isPlanned=true

        UIView.animate(withDuration: 0.3) {
            self.lastEatenLayout.isHidden = state
        }
    }
    
    @IBAction func isBeforeMealClick(_ sender: Any) {
        let state = isAfterMealSwitch.isOn
        print("is before/within")
        chosenExerciseDetails.userMetaInfo.isBeforeMeal=false
        isAfterMealSwitch.setOn(!state, animated: true)
    }
    
    @IBAction func isAfterMealClick(_ sender: Any) {
        let state = isBeforeMealSwitch.isOn
         chosenExerciseDetails.userMetaInfo.isBeforeMeal=true
        isBeforeMealSwitch.setOn(!state, animated: true)
    }
    
    @IBAction func onAddExerciseClick(_ sender: Any) {
        chosenExerciseDetails.userMetaInfo.isPlanned = isPlannedExerciseSwitch.isOn
        chosenExerciseDetails.userMetaInfo.isBeforeMeal = isBeforeMealSwitch.isOn
        chosenExerciseDetails.userMetaInfo.approxTime = approxExerciseTime.date
        chosenExerciseDetails.userMetaInfo.bloodGlucoseLevel = Float(bloodGlucoseTextField.text!)
        
    }
    
    @IBAction func timePicker(_ sender: Any) {
     
        let state = approxExerciseTime.date
        print(state)
        print(type(of:state))
        chosenExerciseDetails.userMetaInfo.exerciseTime = state
        print("chosen", chosenExerciseDetails.userMetaInfo.exerciseTime)
        
        
    }
    
    
    
    func createAlert(title: String, message: String) {
        let submitAction = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in })
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(submitAction)
        present(alert, animated: true, completion: nil)
    }
    
    
}
