//
//  ParseClient.swift
//  SwiftOnTheMap
//
//  Created by Paul Omeally on 9/10/17.
//  Copyright © 2017 Paul Omeally. All rights reserved.
//

import Foundation
import UIKit


class ParseCL: NSObject{
    
    
    override init() {
        super.init()
    }

    class func sharedInstance() -> ParseCL{
        struct Singleton {
            static var sharedInstance = ParseCL()
        }
        return Singleton.sharedInstance
    }
    
    //the function creates a URL that is ASCII character
    func URLParseMethod(_ parameters: [String: AnyObject]?, _ pathExtension: String?) -> URL {
        
        var components = URLComponents()
        components.scheme = UdacityClient.ParseConstants.ApiScheme
        components.host = UdacityClient.ParseConstants.ApiHost
        components.path = UdacityClient.ParseConstants.ApiPath + (pathExtension ?? "")
        
        guard let parameters = parameters else{
            return components.url!
        }
        
        components.queryItems = [URLQueryItem]()
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }

    func closures(_ data: Data?, _ response:URLResponse?, _ error:Error?)->[String: AnyObject]?{
        
        var jsonData: Any!
        guard (error == nil) else {
            print("There was an error with your request: \(error)")
            return nil
        }
        /* GUARD: Did we get a successful 2XX response? */
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode >= 200 && statusCode <= 299 else {
            print("Your request returned a status code \((response as? HTTPURLResponse)?.statusCode)")
            //print("\(response as? HTTPURLResponse)?.statusCode)")
            return nil
        }
        /* GUARD: Was there any data returned? */
        guard let data = data else {
            print("No data was returned by the request!")
            return nil
        }
        /* subset response data! */
        do{jsonData = try JSONSerialization.jsonObject(with: data, options:.allowFragments)}catch{
            print("the json data could not be obtained")
        }
        print(jsonData)
        print("here is the json Data")
        return jsonData as? [String:AnyObject]
    }

    func parseGetMethod(_ methodtype: URL, _ completionHandeler: @escaping ([[String:AnyObject]],Error?) -> Void ){
        
        let request = NSMutableURLRequest(url: methodtype)
        var jsonData: [String:AnyObject]?
        //var finalStudentArray: [student]?
        print("the methodtype is \(methodtype)")
        request.httpMethod = "GET"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            jsonData = self.closures(data, response, error)
            
            //we check if there is an error
            if error == nil {
                // if error is nil we force down cast the localStudentArray
                let localStudentArray = jsonData?["results"] as! [[String: AnyObject]]
                //perform updates on main with no error and localStudentArray
                performUIUpdatesOnMain {
                    completionHandeler(localStudentArray, error)
                }
            }else{
                //we have an error in this case we set localStudentArray as an empty array and perform the completion handelet with localStudentArray and a no nil error
                let localStudentArray = [[String:AnyObject]]()
                performUIUpdatesOnMain {
                    completionHandeler(localStudentArray, error)
                }
            }
            
        }
        task.resume()
    }
    
    func parsePUTorPostMethod(_ methodtype: URL, _ type:String, _ hostViewController: UIViewController, _ completionHandeler: @escaping ([String:AnyObject]) -> Void ){
        
        let request = NSMutableURLRequest(url: methodtype)
        var jsonData: [String:AnyObject]?
        print("the methodtype is \(methodtype), type \(type)")
        request.httpMethod = type
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //print(StudentDS.sharedInstance().studentCollection)
        request.httpBody = "{\"uniqueKey\": \"\(StudentDS.sharedInstance.studentCollection["uniqueKey"]!)\", \"firstName\": \"\(StudentDS.sharedInstance.studentCollection["firstName"]!)\", \"lastName\": \"\(StudentDS.sharedInstance.studentCollection["lastName"]!)\",\"mapString\": \"\(StudentDS.sharedInstance.studentCollection["mapString"]!)\", \"mediaURL\": \"\(StudentDS.sharedInstance.studentCollection["mediaURL"]!)\",\"latitude\":\(StudentDS.sharedInstance.studentCollection["latitude"]!), \"longitude\": \(StudentDS.sharedInstance.studentCollection["longitude"]!)}".data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        let session = URLSession.shared
        //print("this is the unique key \(StudentDS.sharedInstance().studentCollection["uniqueKey"]!)")
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            jsonData = self.closures(data, response, error)
            
            
            guard let jsonData = jsonData else{
                print("the jsonData for the method \(methodtype) of type \(type) failed")
                return
            }
            completionHandeler(jsonData)
            
        }
        task.resume()
        
        
    }
    
    
}
