//
//  studentDataSource.swift
//  SwiftOnTheMap
//
//  Created by Paul Omeally on 9/10/17.
//  Copyright © 2017 Paul Omeally. All rights reserved.
//

import Foundation

class StudentDS {
    
    var students = [Student]()
    var studentInfo: Student? = nil
    var studentCollection = [String: AnyObject]()
    
    static let sharedInstance = StudentDS()
    private init() {}
}
