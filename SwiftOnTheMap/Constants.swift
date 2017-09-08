//
//  Constants.swift
//  SwiftOnTheMap
//
//  Created by Paul Omeally on 9/4/17.
//  Copyright © 2017 Paul Omeally. All rights reserved.
//

import Foundation

extension UdacityClient {

    // MARK: Constants
    
    struct UDConstants {
        
        // MARK: URLs

        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
    }
    
    struct ParseConstants{
        
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes/StudentLocation"
    }
    
    
    // MARK: Parameter Keys
    struct UDacityParameterKeys {
        static let SessionID = "session_id"
        static let Username = "username"
        static let Password = "password"
    }
    
    // MARK: TMDB Response Keys
    struct UDacityResponseKeys {
        static let SessionID = "session_id"
        
    }
    
    struct ParseKeys {
        static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let APIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
   

    
  
}
