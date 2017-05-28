//
//  Recommendation.swift
//  Diabetes
//
//  Created by Ed on 25/05/2017.
//  Copyright © 2017 GlassByte. All rights reserved.
//

import Foundation
import SwiftyJSON

class Recommendation {
    var response: String!
    
    required init(json: JSON) {
        response = json["response"].stringValue
    }
}
