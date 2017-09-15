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
    @IBOutlet weak var mapView: MKMapView!

    var currentLocation: String = ""
    var coreLocationManager = CLLocationManager()
    var locationManager:LocationManager!
    let mapRequest = MKLocalSearchRequest()
    var placeMark: MKPlacemark? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func getLocation(_ sender: Any){
        
        StudentDS.sharedInstance.studentCollection["mapString"] = locationText.text as AnyObject
       
        mapRequest.naturalLanguageQuery = locationText.text
        mapRequest.region = mapView.region
        let search = MKLocalSearch(request: mapRequest)
        search.start { response, _ in
            //function to display an error if the place is not found
            func displayError(string:String){
                print(string)
      
                let  alertController = UIAlertController()
                alertController.title = "Not found"
                alertController.message = "We were not able to find the location, please try again"
                self.present(alertController, animated:true,completion: nil)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                    alertController.dismiss(animated: true, completion: nil)
                }))
            }
            
            guard let response = response else {
                //self.activityIndicator.stopAnimating()
                displayError(string:"There was no response")
                return
            }
            
            self.placeMark = response.mapItems[0].placemark
            StudentDS.sharedInstance.studentCollection["latitude"] = self.placeMark!.coordinate.latitude as AnyObject
            StudentDS.sharedInstance.studentCollection["longitude"] = self.placeMark!.coordinate.longitude as AnyObject
            
            
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = self.placeMark!.coordinate
            annotation.title = self.placeMark?.name
            if let city = self.placeMark?.locality,
                let state = self.placeMark?.administrativeArea {
                annotation.subtitle = "\(city) \(state)"
            }
            
            performUIUpdatesOnMain {
                self.mapView.addAnnotation(annotation)
                let span = MKCoordinateSpanMake(0.05, 0.05)
                let region = MKCoordinateRegionMake(self.placeMark!.coordinate, span)
                
                //self.activityIndicator.stopAnimating()
                //self.activityIndicator.hidesWhenStopped = true
                self.mapView.setRegion(region, animated: true)
              }
            }
    }
    
    @IBAction func closeView(_ sender: Any){
        self.dismiss(animated: true, completion: nil)
        
    }

}
