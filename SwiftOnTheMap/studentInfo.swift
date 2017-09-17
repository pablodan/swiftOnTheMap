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
    
    var uniqueKey: String?
    var objectId: String?
    var firstName: String?
    var lastName: String?
    var long: Double?
    var lat: Double?
    var mediaUrl: String?
    var createdAt: NSDate?
    var updatedAt: NSDate?
    var mapString: String?
    let annotation = MKPointAnnotation()

    
    init(studentData:[String:Any]){
        
        self.uniqueKey = studentData["key"] as? String
        self.objectId = studentData["objectId"] as? String
        self.firstName = studentData["firstName"] as? String
        self.lastName = studentData["lastName"] as? String
        self.long = studentData["longitude"] as? Double
        self.lat = studentData["latitude"]  as? Double
        self.mediaUrl = studentData["mediaURL"] as? String
        self.createdAt = studentData["createdAt"] as? NSDate
        self.updatedAt = studentData["updatedAt"] as? NSDate

    }
    
    init(objectId: String, uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Double, longitude: Double, createdAt: NSDate, updatedAt: NSDate) {
        self.objectId = objectId
        self.uniqueKey = uniqueKey
        self.firstName = firstName
        self.lastName = lastName
        self.mapString = mapString
        self.mediaUrl = mediaURL
        self.lat = latitude
        self.long = longitude
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        
    }
    


}
