//
//  networknetworkClient.swift
//  SwiftOnTheMap
//
//  Created by Paul Omeally on 9/16/17.
//  Copyright © 2017 Paul Omeally. All rights reserved.
//

import Foundation

class networkClient: NSObject {
    // MARK: Properties
    
    // shared session
    //var session = URLSession.shared
    //var requestToken: String? = nil
    //var sessionID : String? = nil
   // var userID : Int? = nil

    // MARK: Initializers
    
    //MARK: SHARED INSTANCE
    class func sharedInstance() -> networkClient {
        struct Singleton {
            static var sharedInstance = networkClient()
        }
        return Singleton.sharedInstance
    }
    
    override init() {
        super.init()
    }

    // MARK: log out
    func logOut(completed: @escaping (_ error: NSError?) -> ())  {        
            // do udacity log out
          let url = networkClient.URLFromParameters(Constants.UdacityClient.ApiScheme, Constants.UdacityClient.ApiHost, Constants.UdacityClient.ApiPath, withPathExtension: Constants.Methods.Session, withQuery: "")
       
        //was processSession
            processSession(url: url, task: "DELETE", jsonBody: "", truncatePrefix: 5, completionHandlerForAllTasks: { (result, error) in
                if error != nil {
                    print(error)
                    completed(error)
                } else {
                    print(result)
                    completed(nil)
                }
            })// end allTasks
    }

    // MARK: MAKE JSON
    
    func formatJson(_ json: [String:AnyObject]) -> String {
        
        let newJson = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        let body = NSString(data: newJson!, encoding: String.Encoding.utf8.rawValue)
        return body as! String
    }
    
    
    
    // method takes url, task, jsonBody, truncatePrefix, and a completion handler as parameters
    // url - prebuilt before passing in based on method being performed,
    // task - type (GET, PUT, DELETE, POST) as string to tell the server what to do
    // jsonBody - prebuilt before passing in based on method being performed,
    // truncatePrefix - Used to remove the first x characters in the data in the doRequestWithCompletion method
    //  -> truncatePrefix used for the Udacity Log in with a value of 5 to pass their security technique
    // completion handler to handle the result or error via passthroughs.
    
    
    //was processSession
    func processSession(url: URL, task: String, jsonBody: String, truncatePrefix: Int, completionHandlerForAllTasks: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        //build requeset based on HTTP method
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = task
        let urlstring = url.absoluteString
        
        if task == "PUT" {
            request.addValue(Constants.ParseParamValues.ParseID, forHTTPHeaderField: Constants.ParseClient.ParseHttpHeaderId)
            request.addValue(Constants.ParseParamValues.ApiKey, forHTTPHeaderField: Constants.ParseClient.ParseHttpHeaderKey)
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        } else {
            
            if (urlstring.range(of: "api.udacity") != nil)   {
                if task == "DELETE" {
                    var xsrfCookie: HTTPCookie? = nil
                    let sharedCookieStorage = HTTPCookieStorage.shared
                    for cookie in sharedCookieStorage.cookies! {
                        if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
                    }
                    if let xsrfCookie = xsrfCookie {
                        request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
                    }
                    
                }
                request.addValue("application/json", forHTTPHeaderField: "Accept")
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                
            } else {
                
                //Parse requests
                request.addValue(networkClient.Constants.ParseParams.ParseID, forHTTPHeaderField: "X-Parse-Application-Id")
                request.addValue(networkClient.Constants.ParseParams.ParseID, forHTTPHeaderField: "X-Parse-REST-API-Key")
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        }
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        return doRequestWithCompletion(request, truncatePrefix: truncatePrefix, completion: completionHandlerForAllTasks)
    }

    // GET LOCATIONS
    // helper for get locations data
    func downloadJSON(_ completion:  @escaping (_ result: AnyObject?, _ error: NSError?) -> Void ) -> URLSessionDataTask {
        // build url and submit for data in order
        
        let url = networkClient.URLFromParameters(networkClient.Constants.ParseClient.ApiScheme, networkClient.Constants.ParseClient.ApiHost, networkClient.Constants.ParseClient.ApiPath, withPathExtension: networkClient.Constants.Methods.StudentLocation , withQuery:  "?order=updatedAt")
        
        return networkClient.sharedInstance().processSession(url: url, task: "GET", jsonBody: "", truncatePrefix: 0, completionHandlerForAllTasks:  completion)
        
    }
    
    func getLocations(completed: @escaping (_ error: NSError?) -> ()) {
        
        // try to download data and scrub it
        // on success store in array of locations
        downloadJSON({ (result, error) in
            if error != nil {
                print(error?.localizedDescription)
                completed(error)
            } else {
                let locationsDict = result?["results"] as! [[String : Any]]
                for item in locationsDict {
                    var newLocation = Student(studentData: item)
                    if let dstring = item["updatedAt"] as? String {
                        newLocation.updatedAt = self.getDate(date: dstring)
                        //self.locations.append(newLocation)
                        StudentDS.sharedInstance.studentCollection.append(newLocation)
                    }
                }
            }
            
            print(result)
            self.sortLocations {
                //print(self.locations.description)
            }
            completed(nil)
        })
        
    }

    func getDate(date: String) -> NSDate {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let dateResult = dateFormatter.date(from: date)
        return dateResult as! NSDate
    }
    // MARK: SORT
    func sortLocations(completed: @escaping () -> ()) {
        // sort by updated by date
        for location in StudentDS.sharedInstance.studentCollection {
            // location.updatedAt = getdate(location.updatedAt)
        }
        StudentDS.sharedInstance.studentCollection.sort(by: { ($0.updatedAt as? NSDate)?.compare(($1.updatedAt as? NSDate)! as Date) == .orderedDescending})
        completed()
    }

    // MARK: GET MY USER INFO
    func getMyUser() {
        // request info based on account key
        // on success set struct to contain name and key
        let url = networkClient.URLFromParameters(Constants.UdacityClient.ApiScheme, Constants.UdacityClient.ApiHost, Constants.UdacityClient.ApiPath, withPathExtension: Constants.UdacityClient.UserPath as! String + Constants.AuthParams.accountKey as! String  , withQuery: nil)
        networkClient.sharedInstance().processSession(url: url, task: "GET", jsonBody: "", truncatePrefix: 5, completionHandlerForAllTasks:  {(results, error) in
            if let error = error {
                print(error)
            } else {
                let user = results?["user"] as! [String : Any]
                 StudentDS.sharedInstance.studentInfo = Student.init(objectId: "", uniqueKey: user["key"] as! String, firstName: user["first_name"] as! String, lastName: user["last_name"] as! String, mapString: "", mediaURL: "", latitude: 0, longitude: 0, createdAt: NSDate.init(timeIntervalSinceNow: 0), updatedAt:  NSDate.init(timeIntervalSinceNow: 0))
            }
            print(StudentDS.sharedInstance.studentInfo?.firstName, StudentDS.sharedInstance.studentInfo?.lastName, StudentDS.sharedInstance.studentInfo?.uniqueKey)
            
        })
    }

    // request - prebuilt when passed in,
    // truncate prefix - remove x from the front of the data before parsing it.
    // completion handler to process result or error via passthroughs
    func doRequestWithCompletion(_ request: NSMutableURLRequest, truncatePrefix: Int, completion: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        /* 4. Make the request */
        var currentSession = URLSession.shared
        let task = currentSession.dataTask(with: request as URLRequest) { (data, response, error) in
            print(request)
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completion(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                let errorString = (error as! URLError).localizedDescription
                sendError("There was an error with your request: \(errorString)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                let code = (response as? HTTPURLResponse)?.statusCode as! Int
                if code >= 300 && code <= 399 {
                    sendError("Your request was redirected. Error Code: \(code)")
                } else if code >= 400 && code <= 499 {
                    if code == 400 {
                        sendError("Bad Request. Error Code: \(code)")
                    } else if code == 401 {
                        sendError("Invalid Credentials. Error Code: \(code)")
                    } else if code == 403 {
                        sendError("FORBIDDEN: Check Your Credentials. Error Code: \(code)")
                    } else if code == 404 {
                        sendError("Not Found. Error Code: \(code)")
                    } else {
                        sendError("Client Error: \(code)")
                    }
                } else if code >= 500 && code <= 599 {
                    if code == 500 {
                        sendError("Internal Server Error: \(code)")
                    } else if code == 501 {
                        sendError("Not Implemented. Error Code: \(code)")
                    } else if code == 502 {
                        sendError("Bad Gateway. Error Code: \(code)")
                    } else if code == 503 {
                        sendError("Service Unavailable. Error Code: \(code)")
                    } else if code == 504 {
                        sendError("Gateway Timeout. Error Code: \(code)")
                    } else {
                        sendError("Server error: \(code)")
                    }
                } else {
                    sendError("Your request returned a status code other than 2xx! Response: \(code)")
                }
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard var data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            if truncatePrefix != 0 {
                let range = Range(truncatePrefix..<data.count)
                data = data.subdata(in: range)
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completion)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
        
    }
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        completionHandlerForConvertData(parsedResult, nil)
    }
    // create a URL from parameters
    
    class func URLFromParameters(_ scheme: String, _ host: String, _ path: String, withPathExtension: String? = nil, withQuery: String? = nil) -> URL{
        var parameters = [String:AnyObject]()
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path + (withPathExtension ?? "")
        components.query = (withQuery ?? "")
        
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }


    
}
