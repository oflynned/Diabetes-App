//
//  SportsSelectionViewController.swift
//  Diabetes
//
//  Created by Ed on 18/05/2017.
//  Copyright © 2017 GlassByte. All rights reserved.
//

import UIKit

final class SportsSelectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var SportsCollectionView: UICollectionView!
    
    /*
     aerobic:
        cycling, mountain biking, golf, walking, jogging, running, swimming, triathlon, rowing, spinning
     
     anaerobic:
        sprint swimming, weight lifting, body building, sprinting, archery, gymnastics, fencing
     
     mixed:
        football, rugby, basketball, baseball, hockey, tennis, squash, badminton, dancing, HIIT, water polo
    */
    
    var sports = [Sport]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // aerobic
        sports.append(Sport(name: "Cycling", exercise: Sport.Exercise.aerobic, image: "cycling"))
        sports.append(Sport(name: "Mountain Biking", exercise: Sport.Exercise.aerobic, image: "cycling"))
        sports.append(Sport(name: "Golf", exercise: Sport.Exercise.aerobic, image: "golf"))
        sports.append(Sport(name: "Walking", exercise: Sport.Exercise.aerobic, image: "running"))
        sports.append(Sport(name: "Jogging", exercise: Sport.Exercise.aerobic, image: "running"))
        sports.append(Sport(name: "Running", exercise: Sport.Exercise.aerobic, image: "running"))
        sports.append(Sport(name: "Swimming", exercise: Sport.Exercise.aerobic, image: "swimming"))
        sports.append(Sport(name: "Triathlon", exercise: Sport.Exercise.aerobic, image: "running"))
        sports.append(Sport(name: "Rowing", exercise: Sport.Exercise.aerobic, image: "rowing"))
        sports.append(Sport(name: "Spinning", exercise: Sport.Exercise.aerobic, image: "cycling"))
        
        // anaerobic
        sports.append(Sport(name: "Sprint Swimming", exercise: Sport.Exercise.anaerobic, image: "swimming"))
        sports.append(Sport(name: "Weight Lifting", exercise: Sport.Exercise.anaerobic, image: "weight_lifting"))
        sports.append(Sport(name: "Body Building", exercise: Sport.Exercise.anaerobic, image: "weight_lifting"))
        sports.append(Sport(name: "Sprinting", exercise: Sport.Exercise.anaerobic, image: "running"))
        sports.append(Sport(name: "Archery", exercise: Sport.Exercise.anaerobic, image: "archery"))
        sports.append(Sport(name: "Gymnastics", exercise: Sport.Exercise.anaerobic, image: "gymnastics"))
        sports.append(Sport(name: "Fencing", exercise: Sport.Exercise.anaerobic, image: "fencing"))
        
        // mixed
        sports.append(Sport(name: "Football", exercise: Sport.Exercise.mixed, image: "football"))
        sports.append(Sport(name: "Rugby", exercise: Sport.Exercise.mixed, image: "rugby"))
        sports.append(Sport(name: "Basketball", exercise: Sport.Exercise.mixed, image: "basketball"))
        sports.append(Sport(name: "Hockey", exercise: Sport.Exercise.mixed, image: "hockey"))
        sports.append(Sport(name: "Tennis", exercise: Sport.Exercise.mixed, image: "tennis"))
        sports.append(Sport(name: "Squash", exercise: Sport.Exercise.mixed, image: "tennis"))
        sports.append(Sport(name: "Badminton", exercise: Sport.Exercise.mixed, image: "tennis"))
        sports.append(Sport(name: "Dancing", exercise: Sport.Exercise.mixed, image: "dancing"))
        sports.append(Sport(name: "HIIT", exercise: Sport.Exercise.mixed, image: "running"))
        sports.append(Sport(name: "Water Polo", exercise: Sport.Exercise.mixed, image: "water_polo"))
        
        // order alphabetically
        sports = sports.sorted { $0.name<$1.name }
        
        self.SportsCollectionView.delegate = self
        self.SportsCollectionView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sports.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sport_cell", for: indexPath) as! SportViewCell
        cell.sportImageView.image = UIImage(named: sports[indexPath.row].image)
        cell.sportLabel.text = sports[indexPath.row].name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected: " + sports[indexPath.row].name)
        performSegue(withIdentifier: "goToExerciseLength", sender: sports[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToExerciseLength" {
            if let destination = segue.destination as? ExerciseLengthViewController {
                destination.sport = sender as? Sport
            }
        }
    }

}
