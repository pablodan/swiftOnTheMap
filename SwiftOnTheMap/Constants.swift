//
//  Constants.swift
//  SwiftOnTheMap
//
//  Created by Paul Omeally on 9/4/17.
//  Copyright © 2017 Paul Omeally. All rights reserved.
//

import Foundation

extension networkClient {

    struct Constants {
        
        //MARK: UdacityClient
        struct UdacityClient {
            static let ApiScheme = "https"
            static let ApiPath = "/api"
            static let UserPath = "/users/"
            static let ApiHost = "www.udacity.com"
        }
        
        //MARK: ParseClient
        struct ParseClient {
            static let ApiScheme = "https"
            static let ApiHost = "parse.udacity.com"
            static let ApiPath = "/parse/classes"
            static let UserPath = "/parse/users/"
            static let UniqueKey = "uniqueKey"
            static let MediaUrl = "mediaURL"
            static let MapString = "mapString"
            static let Latitude = "latitude"
            static let Longitude = "longitude"
            static let FirstName = "firstName"
            static let LastName = "lastName"
            static let ParseHttpHeaderId = "X-Parse-Application-Id"
            static let ParseHttpHeaderKey = "X-Parse-REST-API-Key"
            
            
        }
        
        // MARK: Parameter Keys
        struct ParseParams {  //was ParameterKeys
            //static let Method = "method"
            //static let ApiKey = "api_key"
            static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
            static let ParseID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        }
        
        // MARK: Parameter Values
        
        struct ParseParamValues {  //was ParameterValues
            //static let SearchMethod = "search"
            static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
            static let ParseID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        }
        
         // MARK: Methods
        struct Methods {
            static let Session = "/session"
            static let StudentLocation = "/StudentLocation"
            static let StudentInfo = "/users/"
            static let Get = "GET"
            static let Post = "POST"
            static let Put = "PUT"
            static let Delete = "DELETE"
        }
        
        //MARK: Bearer
        
        struct Bearer {
            static let Bearer = "application/json"
            
            
        }
         // MARK: Authorization
        struct AuthParams {  //wsa LoginKeys
            static let Udacity = "udacity"
            static let Username = "username"
            static let Password = "password"
            
            /*****************************/
            static let AccountID = "account"
            static let Registered = "registered"
            static let Key = "key"
            static let SessionID = "session"
            static let ID = "id"
            static let Expiration = "expiration"
            /************************************/
            static var accountKey = ""
            static var sessionID = ""
            static var sessionExpires = ""
            
        }
        
        
        /*struct LoginResponseKeys {  //now in AuthParams
            
            // MARK: Account
            static let AccountID = "account"
            static let Registered = "registered"
            static let Key = "key"
            static let SessionID = "session"
            static let ID = "id"
            static let Expiration = "expiration"
 
        }*/
        
       /*
        struct UserSession { //now in AuthParams
            static var accountKey = ""
            static var sessionID = ""
            static var sessionExpires = ""
  
        }*/
        
        
    }
  
}
