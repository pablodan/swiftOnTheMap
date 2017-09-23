//
//  MapVC.swift
//  SwiftOnTheMap
//
//  Created by Paul Omeally on 9/10/17.
//  Copyright © 2017 Paul Omeally. All rights reserved.
//

import UIKit
import MapKit
import Foundation

class MapVC: UIViewController, MKMapViewDelegate  {

    @IBOutlet weak var mapView: MKMapView!
    var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
           self.refreshMapView()
    }


    func addAnnotations(_ locations: [Student])  {
        
        for location in locations {
            
            if let latitude = location.lat as! Double?, let longitude = location.long as! Double? {
                
                
                let lat = CLLocationDegrees(latitude)
                let long = CLLocationDegrees(longitude)
                
                // The lat and long are used to create a CLLocationCoordinates2D instance.
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                if let first = location.firstName as? String, let last = location.lastName as? String, let mediaURL = location.mediaUrl as? String {
                    // Here we create the annotation and set its coordiate, title, and subtitle properties
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(first) \(last)"
                    annotation.subtitle = mediaURL
                    // Finally we place the annotation in an array of annotations.
                    annotations.append(annotation)
                } else {
                    print("Error unwrapping values")
                }
            }
        }
        self.mapView.addAnnotations(annotations)
    }

    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
           let sharedDel = UIApplication.shared
            if let displayLbl = view.annotation?.subtitle,
                let url = URL(string: displayLbl!) {
                sharedDel.open(url, options: [String : Any](), completionHandler: nil)
            }
        }
    }
    
    @IBAction func navigatioToAddPin(_ sender: Any){
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let addAnnotationVC: AddAnnotationVC = storyboard.instantiateViewController(withIdentifier: "addPin") as! AddAnnotationVC
        
        present(addAnnotationVC, animated: true, completion: nil)
    
    }
    

    @IBAction func reloadMapview(_ sender: Any) {
        
        refreshMapView()
    }
    
    @IBAction func Logout(_ sender: Any){
    
        networkClient.sharedInstance().logOut { (error) in
            if error != nil {
                //self.doFailedAlert("Logout Failed",error!)
            } else {
                DispatchQueue.main.async {
                    //self.ai.hide()
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    // reload pin data and mapview
     func refreshMapView() {
        
      
        // display indictor
        
        //self.ai.show()
        
        //remove pins
        self.mapView.removeAnnotations(self.annotations)
        self.annotations.removeAll()
        
        // reset location data
        StudentDS.sharedInstance.studentCollection.removeAll()
        
        networkClient.sharedInstance().getLocations(completed: { (downloadError) in
            if downloadError != nil {
                self.errorAlert("Their was a problem fetching Data", downloadError!)
               // self.ai.hide()
            } else {
                // call main queue to update UI
                DispatchQueue.main.async {
                    self.reloadAnnotaions { (result, error) in
                        if error != nil{
                            print(error)
                        }
                        else {
                            self.addAnnotations(result as! [Student])
                        }
                   
                    }
                } // end async
            } // end else
        })// end get locations
    }
    
    func reloadAnnotaions(_ completion: (_ result : AnyObject?,_ Error : NSError?) -> Void) {
        // get locations and send back on completion
        let locations = StudentDS.sharedInstance.studentCollection
        completion(locations as AnyObject, nil)
        
    }
    
    func errorAlert(_ msg: String, _ error: NSError){
        performUIUpdatesOnMain {
            let alert = UIAlertController(title: msg, message: "\(error.localizedDescription)", preferredStyle: .alert)
            let action = UIAlertAction(title: "Error!", style: .destructive, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true)
            
        }
        
    }
}
