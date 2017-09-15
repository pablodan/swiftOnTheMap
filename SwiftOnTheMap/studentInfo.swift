//
//  studentInfo.swift
//  SwiftOnTheMap
//
//  Created by Paul Omeally on 9/10/17.
//  Copyright © 2017 Paul Omeally. All rights reserved.
//

import Foundation
import MapKit

struct Student {
    
    var uniqueKey: String
    var objectId: String
    var firstName: String
    var lastName: String
    var long: Double
    var lat: Double
    var mediaUrl: String
    var createdAt: String
    var updatedAt: String
    let annotation = MKPointAnnotation()

    
    init(_ studentData:[String:AnyObject]){
        
        self.uniqueKey = studentData["key"] as? String ?? ""
        self.objectId = studentData["objectId"] as? String ?? ""
        self.firstName = studentData["firstName"] as? String ?? ""
        self.lastName = studentData["lastName"] as? String ?? ""
        self.long = studentData["longitude"] as? Double ?? Double(20.0)
        self.lat = studentData["latitude"]  as? Double ?? Double(0.0)
        self.mediaUrl = studentData["mediaURL"] as? String ?? ""
        self.createdAt = studentData["createdAt"] as? String ?? ""
        self.updatedAt = studentData["updatedAt"] as? String ?? ""
        let coordinates = CLLocationCoordinate2D(latitude: self.lat , longitude: self.long)
        self.annotation.coordinate = coordinates
        self.annotation.title = "\(self.firstName) \(self.lastName)"
        self.annotation.subtitle = self.mediaUrl
    }

}
