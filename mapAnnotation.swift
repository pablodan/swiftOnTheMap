//
//  mapAnnotation.swift
//  SwiftOnTheMap
//
//  Created by Paul Omeally on 9/19/17.
//  Copyright © 2017 Paul Omeally. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class mapAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        
        
    }
    
    
}
