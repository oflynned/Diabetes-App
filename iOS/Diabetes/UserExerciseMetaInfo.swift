//
//  UserExerciseMetaInfo.swift
//  Diabetes
//
//  Created by Ed on 23/05/2017.
//  Copyright © 2017 GlassByte. All rights reserved.
//

import Foundation

struct UserExerciseMetaInfo {
    var isPlanned: Bool!
    var isBeforeMeal: Bool!
    var bloodGlucoseLevel: Float!
    
    init(isPlanned: Bool, isBeforeMeal: Bool, bloodGlucoseLevel: Float) {
        self.isPlanned = isPlanned
        self.isBeforeMeal = isBeforeMeal
        self.bloodGlucoseLevel = bloodGlucoseLevel
    }
}
