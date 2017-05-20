//
//  Sport.swift
//  Diabetes
//
//  Created by Ed on 20/05/2017.
//  Copyright © 2017 GlassByte. All rights reserved.
//

import Foundation

class Sport {
    enum Exercise {
        case aerobic
        case anerobic
        case mixed
    }
    
    var name: String
    var exercise: Exercise
    var image: String
    
    init(name: String, exercise: Exercise, image: String){
        self.name = name
        self.exercise = exercise
        self.image = image
    }
}
