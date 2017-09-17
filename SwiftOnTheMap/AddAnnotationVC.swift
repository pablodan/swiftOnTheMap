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

    var currentLocation: String = ""
    var coreLocationManager = CLLocationManager()
    var locationManager:LocationManager!
    let mapRequest = MKLocalSearchRequest()
    var placeMark: MKPlacemark? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //hide save button
        self.savePost.isEnabled = false
    }
    override func viewWillAppear(_ animated: Bool) {
      
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

 
    @IBAction func getLocation(_ sender: Any){
        
        
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
            
    }
    
    @IBAction func closeView(_ sender: Any){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveStudentLoction(_ sender: Any){
        
   
    }

}
