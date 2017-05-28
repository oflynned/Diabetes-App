//
//  ChosenSport.swift
//  Diabetes
//
//  Created by Ed on 20/05/2017.
//  Copyright © 2017 GlassByte. All rights reserved.
//

import Foundation

struct ChosenExercise {
    var sport: Sport!
    var duration: Int!
    var intensity: Int!
    var userMetaInfo: UserExerciseMetaInfo!
    
    init(sport: Sport, duration: Int, intensity: Int, userMetaInfo: UserExerciseMetaInfo) {
        self.sport = sport
        self.duration = duration
        self.intensity = intensity
        self.userMetaInfo = userMetaInfo
    }
}
