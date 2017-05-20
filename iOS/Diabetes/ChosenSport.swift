//
//  ChosenSport.swift
//  Diabetes
//
//  Created by Ed on 20/05/2017.
//  Copyright © 2017 GlassByte. All rights reserved.
//

import Foundation

class ChosenExercise {
    var sport: Sport
    var intensity: Int
    var duration: Int
    
    init(sport: Sport, intensity: Int, duration: Int) {
        self.sport = sport
        self.intensity = intensity
        self.duration = duration
    }
}
