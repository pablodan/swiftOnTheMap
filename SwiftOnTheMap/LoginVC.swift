//
//  ViewController.swift
//  SwiftOnTheMap
//
//  Created by Paul Omeally on 9/4/17.
//  Copyright © 2017 Paul Omeally. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func warningAlerts(_ msg: String){
       
        let alert = UIAlertController(title: "OK", message: msg, preferredStyle: .alert)
        
        let button = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(button)
        
        present(alert, animated: true)
    }
    
    @IBAction func Login(_ sender: AnyObject){
       
      //check if username and password textfield are empty
        
        if emailTxt.text!.isEmpty || passwordTxt.text!.isEmpty {
            //display message
            performUIUpdatesOnMain{
              self.warningAlerts("Please enter username and password to continue!")
            }
            
        }
        
        else {
           //lets try and authenticate user
            
            UdacityClient.sharedInstance().taskForRequestType(UdacityClient.sharedInstance().udcURLFromParamaters("/session"), "POST", username: emailTxt.text, password: passwordTxt.text, presentVC: self)
        }
        
    }


}

