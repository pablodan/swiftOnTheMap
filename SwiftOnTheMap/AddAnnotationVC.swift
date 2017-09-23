//
//  AddAnnotationVC.swift
//  SwiftOnTheMap
//
//  Created by Paul Omeally on 9/12/17.
//  Copyright © 2017 Paul Omeally. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class AddAnnotationVC: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var locationText: UITextField!
    
    @IBOutlet weak var UrlText: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var savePost: UIBarButtonItem!

    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    var locationManager = CLLocationManager()
    var currentLocation: String = ""
    
    // placeholder for location string
    var mapString: String = ""
    
    // bool for replace pin function
    var userPinExists = false
    
    let urlParse = networkClient.URLFromParameters(networkClient.Constants.Parse.Scheme, networkClient.Constants.Parse.Host, networkClient.Constants.Parse.Path, withPathExtension: networkClient.Constants.Methods.StudentLocation)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        findUserAnnotation()
        //hide save button
        self.savePost.isEnabled = false
    }
    override func viewWillAppear(_ animated: Bool) {
      
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        // set annotation data
        self.annotation = annotation
        StudentDS.sharedInstance.studentInfo?.lat = self.annotation.coordinate.latitude
        StudentDS.sharedInstance.studentInfo?.long = self.annotation.coordinate.longitude
        
        // get location string based on pin geolocation
        self.geoString {
            StudentDS.sharedInstance.studentInfo?.mapString = self.mapString
            // Update UI
            //self.currentLocation.text = self.mapString
            self.currentLocation = self.mapString
        }
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        // display pin
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .green
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        
        pinView?.animatesDrop = true
        return pinView
    }
    
    func geoString(completed: @escaping () -> ()){
        
            //set location
            let location = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
            // initialize geocoder to reverse engineer location string
            let reverseLocation = CLGeocoder()
            // variable to store result
            var result = ""
            reverseLocation.reverseGeocodeLocation(location) { (placemarks, error) in
                var placemark: CLPlacemark!
                // read placemark closest to user location
                placemark = placemarks?[0]
                //print(placemark.addressDictionary)
                
                // grab info from dict and append to result string
                if let city = placemark.addressDictionary!["City"] as? String {
                    result += city + " "
                }
                if let state = placemark.addressDictionary!["State"] as? String {
                    result += state + ", "
                }
                if let country = placemark.addressDictionary!["Country"] as? String {
                    result += country
                }
                // store to class variable
                self.mapString = result
                completed()
            }
        }
    
    func findUserAnnotation() {
        // method to locate any annotations by a given uniqueKey
        // creates array of user pins for replacement or deletion
        let url = URL(string:"https://parse.udacity.com/parse/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%22\(networkClient.Constants.UserSession.accountKey )%22%7D")
        
        networkClient.sharedInstance().doAllTasks(url: url!, task:"GET", jsonBody: "", truncatePrefix: 0, completionHandlerForAllTasks:  { (result, error) in
            if error != nil {
                print(error)
            }
            //print("######### FIND USER ###### \(result?["results"])")
            let locationsDict = result?["results"] as! [[String : Any]]
            for item in locationsDict {
                let newLocation = Student(studentData: item)
                StudentDS.sharedInstance.studentCollection.append(newLocation)
            }
            
            if StudentDS.sharedInstance.studentCollection.count > 0 {
                self.userPinExists = true
            }
        })
    }
    
    // DESTROY PINS FUNCTION TO DELETE USER PINS IN MULTIPLES.
    func destroyPins() {
        // take array of userPins to delete all objects of a given user
        
        for item in StudentDS.sharedInstance.studentCollection {
            print(item.firstName,item.mapString,item.mediaUrl,item.objectId)
            if let string = item.objectId as? String {
                let url = URL(string:"https://parse.udacity.com/parse/classes/StudentLocation/\(string)")
                print(url?.absoluteString)
                
                networkClient.sharedInstance().doAllTasks(url: url!, task: "DELETE", jsonBody: "", truncatePrefix: 0, completionHandlerForAllTasks: { (result, error) in
                    if error != nil {
                        print(error?.localizedDescription)
                    }
                    else {
                        print(result)
                    }
                })
            }
        }
        
    }
    
    func doReplacePin(_ jsonBody: String){
        // Call PUT HTTP to replace location object already in place
        
        let url = networkClient.URLFromParameters(networkClient.Constants.Parse.Scheme, networkClient.Constants.Parse.Host, networkClient.Constants.Parse.Path, withPathExtension: networkClient.Constants.Methods.StudentLocation + "/" + StudentDS.sharedInstance.studentCollection[0].objectId! as! String, withQuery:  "")
        
        networkClient.sharedInstance().doAllTasks(url: url, task: "PUT", jsonBody: jsonBody, truncatePrefix: 0, completionHandlerForAllTasks:  { (result, error) in
            if error != nil {
                //self.failedUpload(error!)
            } else {
                print(result)
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        })
    }
    
    
    func doSetPin(_ replacePin: Bool) {
        // check if the user updated their location by checking the text
        // if updated allow sharing
        
        if locationText.text != "" {
            
            // create alert to handle data and sharing
            
            let alert = UIAlertController(title: "You're on the Map!!", message: "Share a link!", preferredStyle: .alert)
            
            // Submit button
            let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (action) -> Void in
                
                // Get 1st TextField's text
                StudentDS.sharedInstance.studentInfo?.mediaUrl = alert.textFields![0].text
                StudentDS.sharedInstance.studentInfo?.createdAt = NSDate(timeIntervalSinceNow: 0)
                
                // set json for request
                
                let jsonBody = networkClient.sharedInstance().makeJSON( [networkClient.Constants.Parse.UniqueKey : networkClient.Constants.UserSession.accountKey as AnyObject, networkClient.Constants.Parse.FirstName : StudentDS.sharedInstance.studentInfo?.firstName as AnyObject, networkClient.Constants.Parse.LastName : StudentDS.sharedInstance.studentInfo?.lastName as AnyObject, networkClient.Constants.Parse.MapString : StudentDS.sharedInstance.studentInfo?.mapString as AnyObject, networkClient.Constants.Parse.MediaURL : StudentDS.sharedInstance.studentInfo?.mediaUrl as AnyObject, networkClient.Constants.Parse.Latitude : StudentDS.sharedInstance.studentInfo?.lat as AnyObject, networkClient.Constants.Parse.Longitude : StudentDS.sharedInstance.studentInfo?.long] as [String: AnyObject])
 
                
                if replacePin {
                    
                    // if there is a pin in place update it
                    self.doReplacePin(jsonBody)
                    
                } else {
                    
                    // otherwise create users first pin
                    let url = self.urlParse
                    networkClient.sharedInstance().doAllTasks(url: url, task: "POST", jsonBody: jsonBody, truncatePrefix: 0, completionHandlerForAllTasks:{ (results, error) in
                        
                        // Send values to completion handler
                        if let error = error {
                            //self.failedUpload(error)
                            
                        } else {
                            print(results)
                            DispatchQueue.main.async {
                                // dismiss view
                                self.dismiss(animated: true)
                            }
                            
                        }
                        
                        
                    }) // end completionHandlerForPost
                }
            })// end sumbit action
            
            // Cancel button
            let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in
                
            })
            
            // create text field to hold URL
            alert.addTextField { (textField) in
                textField.keyboardAppearance = .light
                textField.keyboardType = .default
                textField.autocorrectionType = .no
                textField.placeholder = "Enter a Link"
            }
            
            // add items to alert controller and present
            alert.addAction(submitAction)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
            
        } else {
            // if user has not updated location, notify them
            let alert = UIAlertController(title: "You're Not on the Map!!", message: "Tell us your location!", preferredStyle: .alert)
            
            // Cancel button
            let cancel = UIAlertAction(title: "Okay", style: .default, handler: { (action) -> Void in })
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
        }
        
    }
    
    func removePins() {
        self.mapView.removeAnnotations(self.mapView.annotations)
    }
    
    @IBAction func getLocation(_ sender: Any){
        
        removePins()
        
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = locationText.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (localSearchResponse, error) -> Void in
            
            
            // alert if location not found
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
                //activityIndicator.hide()
                return
            }
            
            // append annotation if result is found
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = self.locationText.text
            // get pin location
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:     localSearchResponse!.boundingRegion.center.longitude)
            
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            
            
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
            //enable save button
            self.savePost.isEnabled = true
            
     
            
        }
        
        
    }
    
    func doSubmitLocation(_ userPin: Bool){
        
        
        // call doSetPin function after checking previous locations
        if userPinExists {
            
            let alert = UIAlertController(title: "Would you like to overwrite your previously posted location?", message: "This cannot be undone.", preferredStyle: .alert)
            
            let noAction = UIAlertAction(title: "Nope", style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            })
            
            let overwriteAction = UIAlertAction(title: "Overwrite", style: .destructive, handler: { (action) in
                //self.destroyPins()
                self.doSetPin(true)
            })
            
            alert.addAction(noAction)
            alert.addAction(overwriteAction)
            present(alert, animated: true, completion: nil)
            
        } else {
            doSetPin(false)
        }
        
    }
    
    @IBAction func closeView(_ sender: Any){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveStudentLoction(_ sender: Any){
        
            self.locationManager.stopUpdatingLocation()
    
        doSubmitLocation(userPinExists)
        print(userPinExists)

    }

}
