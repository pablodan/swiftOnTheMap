//
//  NetworkClient.swift
//  SwiftOnTheMap
//
//  Created by Paul Omeally on 9/5/17.
//  Copyright © 2017 Paul Omeally. All rights reserved.
//

import Foundation
import UIKit

class UdacityClient:NSObject{
    
    // MARK :Props
    
    //shared session
    let session = URLSession.shared
    var sessionID : String? = nil
    var userID : Int? = nil
    var logoutPressed: Bool = false
    
    override init() {
        super.init()
    }
    class func sharedInstance() -> UdacityClient{
        struct Singleton {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
    func udcURLFromParamaters(_ pathExtension: String?) -> URL {
        
        var components = URLComponents()
        components.scheme = UdacityClient.UDConstants.ApiScheme
        components.host = UdacityClient.UDConstants.ApiHost
        components.path = UdacityClient.UDConstants.ApiPath + (pathExtension ?? "")
        return components.url!
    }
    
    //we use this method to parse data into an object of type [String:Anyobject] out of the udacity methods
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
        let newData = data.subdata(in: Range(5..<data.count)) /* subset response data! */
        do{jsonData = try JSONSerialization.jsonObject(with: newData, options:.allowFragments)}catch{
            print("the json data could not be obtained")
        }
        print(jsonData)
        print("here is the json Data")
        return jsonData as? [String:AnyObject]
    }
    
    //udacitymethod
    func taskForRequestType(_ methodtype: URL, _ type: String, username:String?, password:String?, presentVC: UIViewController){
        
        let request = NSMutableURLRequest(url: methodtype)
        var jsonData: [String:AnyObject]?
        print(methodtype)
        print("\(type)")
        switch type {
        case "POST":
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = "{\"udacity\": {\"username\":\"\(username!)\", \"password\": \"\(password!)\"}}".data(using: String.Encoding.utf8)
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest) { data, response, error in
                jsonData = self.closures(data, response, error)
                
                func displayError(string:String){
                    print(string)
                    
                     let  alertController = UIAlertController()
                    alertController.title = "Not registered"
                    alertController.message = "Either the password or the username are wrong"
                    
                    performUIUpdatesOnMain {
                        
                        presentVC.present(alertController, animated:true,completion: nil)
                        
                        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                            alertController.dismiss(animated: true, completion: nil)
                        }))
                    }
                }
 
 
                guard let sessionDirctionary = jsonData?["session"] as? [String:AnyObject]else{
                    displayError(string: "The session was not found")
                    return
                }
                
                
                self.sessionID = sessionDirctionary["id"]! as? String
                
                guard let accountDictionary = jsonData!["account"] as? [String: AnyObject]else{
                    displayError(string: "account was not found")
                    return
                }
                guard (accountDictionary["registered"]! as? Bool)  == true else{
                    displayError(string:"not registered")
                    print(type(of: accountDictionary["registered"]!))
                    return
                }
                //for some unknown reason userID = accountDictionary["key"] as? Int fails that is why need the constant number
                
                guard let number = accountDictionary["key"] as? String else{
                    displayError(string: "the user ID does not exist")
                    //print(accountDictionary["key"])
                    //print(accountDictionary["key"] as? Int)
                    return
                }
                
                performUIUpdatesOnMain {
                    let tabBarController = presentVC.storyboard!.instantiateViewController(withIdentifier: "mainTabBar") as! UITabBarController
                    presentVC.present(tabBarController, animated: true, completion: nil)
                }
                
                self.userID = Int(number)!
                //StudentModel.sharedInstance().dictionaryOfMyStudent["uniqueKey"] = Int(number)! as AnyObject
                
            }
            task.resume()
        case "DELETE":
            request.httpMethod = "DELETE"
            var xsrfCookie: HTTPCookie? = nil
            let sharedCookieStorage = HTTPCookieStorage.shared
            for cookie in sharedCookieStorage.cookies! {
                if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
            }
            if let xsrfCookie = xsrfCookie {
                request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
            }
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest) { data, response, error in
                // the udacityClosures gets data response and error returns a dictionary of type [String:AnyObject]?
                jsonData = self.closures(data, response, error)
                
                func displayError(string: String){
                    print("String")
                }
                guard let logoutDictionary = jsonData?["session"] as? [String:AnyObject]else{
                    displayError(string: "the session does not exist")
                    return
                }
                guard let logoutSessionID = logoutDictionary["id"] else{
                    displayError(string: "there is no session id")
                    return
                }
                
                
            //   performUIUpdatesOnMain {
                   // print(logoutSessionID)
                    
                   // let viewController = hostViewController.storyboard!.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                    
                //    hostViewController.present(viewController, animated: true, completion: nil)
                  //  hostViewController.dismiss(animated: true, completion: nil)
                    
               // }
            }
            task.resume()
        case "GET": //https://www.udacity.com/api/session/users/2412918542
            print("We are in case GET")
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest) { data, response, error in
                jsonData = self.closures(data, response, error)
                
                guard let user = jsonData?["user"] as? [String:AnyObject] else{
                    print("We could not find user")
                    return
                }
                guard let firstName = user["first_name"] else{
                    print("we can not find the first_name")
                    return
                }
                guard let lastName = user["last_name"] else{
                    print("we can not find the last_name")
                    return
                }
                
                guard let key = user["key"] else{
                    print("we can not find the last bame")
                    return
                }
                
                //let PostingController = hostViewController as! PostingControllView
               /*
                StudentModel.sharedInstance().dictionaryOfMyStudent["firstName"] = firstName as AnyObject
                StudentModel.sharedInstance().dictionaryOfMyStudent["lastName"] = lastName as AnyObject
                StudentModel.sharedInstance().dictionaryOfMyStudent["uniqueKey"] = key as AnyObject
                print(lastName)
                print(firstName)
                print(key)
              */
            }
            task.resume()
        default:
            print("Do not recognize the method type")
        }
    }
    
    
    

}

    
