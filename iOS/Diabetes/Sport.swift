//
//  Sport.swift
//  Diabetes
//
//  Created by Ed on 20/05/2017.
//  Copyright © 2017 GlassByte. All rights reserved.
//

import Foundation

struct Sport {
    enum Exercise {
        case aerobic
        case anaerobic
        case mixed
    }
    
    var name: String!
    var exercise: Exercise!
    var image: String!
    
    init(name: String, exercise: Exercise, image: String){
        self.name = name
        self.exercise = exercise
        self.image = image
    }
}
