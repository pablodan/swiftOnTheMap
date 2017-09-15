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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //reload mapview and display data
        //mapView.removeAnnotation(mapView.annotations as! MKAnnotation)
        
        let parseParams = ["order":"-updatedAt" as AnyObject,"limit":100 as AnyObject]
        
        ParseCL.sharedInstance().parseGetMethod(ParseCL.sharedInstance().URLParseMethod(parseParams, nil)){ localStudentArray, error in
            
            //check if we have connectivity error
            guard (error?.localizedDescription != "The Internet connection appears to be offline.")else{
                // self.connectivityAlert(_title: "No internet Connection", "Can not load since there is no internet connectivity, please connect to the internet and try again")
                return
            }
            // check if we have an error of other type
            guard (error == nil) else{
                // self.connectivityAlert(_title: "Error", "There was an error \(error?.localizedDescription)")
                print("we do see this")
                return
            }
            
            self.closureToPopulateTheMap(localStudentArray)
        }

    }

    func closureToPopulateTheMap(_ dictionary:[[String:AnyObject]]){
        StudentDS.sharedInstance.students = dictionary.map({Student($0)})
        var annotations = [MKPointAnnotation]()
        
        for students in StudentDS.sharedInstance.students{
            annotations.append(students.annotation)
        }
        
        // When the array is complete, we add the annotations to the map.
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
    

}
