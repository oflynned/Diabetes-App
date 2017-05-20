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
        sprint swimming, weight lifting, body building, track (long jump, javelin, shotput, high jump, pole vault, sprinting), archery, gymnastics (bars, beams, floor, rings, vault, horse), fencing
     
     mixed:
        football, rugby, basketball, baseball, hockey, tennis, sqyash, badminton, dancing, HIIT, water polo
    */
    
    var sports = [Sport]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sports.append(Sport(name: "Football", exercise: Sport.Exercise.aerobic, image: "football"))
        sports.append(Sport(name: "Cycling", exercise: Sport.Exercise.aerobic, image: "cycling"))
        sports.append(Sport(name: "Basketball", exercise: Sport.Exercise.aerobic, image: "basketball"))
        sports.append(Sport(name: "Rugby", exercise: Sport.Exercise.aerobic, image: "rugby"))
        sports.append(Sport(name: "Running", exercise: Sport.Exercise.aerobic, image: "running"))
        sports.append(Sport(name: "Swimming", exercise: Sport.Exercise.aerobic, image: "swimming"))
        
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
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected: " + sports[indexPath.row].name)
    }

}
