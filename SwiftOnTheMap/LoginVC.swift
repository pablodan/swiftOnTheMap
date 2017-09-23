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
    var session = URLSession.shared
    let urlUdacity = networkClient.URLFromParameters(networkClient.Constants.Udacity.Scheme, networkClient.Constants.Udacity.Host, networkClient.Constants.Udacity.Path, withPathExtension: networkClient.Constants.Methods.Session)
   //let ai = ActivityIndicator(text:"Loading")
    

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
    
    func getKey(_ results: [String:AnyObject] ) {
        if let accountID = results[networkClient.Constants.LoginResponseKeys.AccountID]  as? [String:AnyObject] {
            networkClient.Constants.UserSession.accountKey = accountID[networkClient.Constants.LoginResponseKeys.Key] as! String
        } else {
            print("Failed to get account key")
        }
        if let sessionID = results[networkClient.Constants.LoginResponseKeys.SessionID] as? [String:AnyObject] {
            networkClient.Constants.UserSession.sessionID = sessionID[networkClient.Constants.LoginResponseKeys.ID] as! String
        } else {
            print("Failed to get session ID")
        }
    }
    func loginFailed(_ message: String) {
        //self.ai.hide()
        let alert = UIAlertController(title: message, message: "Please try again.", preferredStyle: .alert)
        let button = UIAlertAction(title: "Okay", style: .default, handler: nil)
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
            
            //UdacityClient.sharedInstance().taskForRequestType(UdacityClient.sharedInstance().udcURLFromParamaters("/session"), "POST", username: emailTxt.text, password: passwordTxt.text, presentVC: self)
            
            let parameters = [String:AnyObject]()
            
            // json for log in credentials pulling from text fields.
            
            let jsonBody = networkClient.sharedInstance().makeJSON([networkClient.Constants.LoginKeys.Udacity : networkClient.sharedInstance().makeJSON([networkClient.Constants.LoginKeys.Username : emailTxt.text as! String, networkClient.Constants.LoginKeys.Password : passwordTxt.text as! String ] as [String:AnyObject]) as AnyObject])
            
            // call task for post with url and jsonBody to get the log in results.
            networkClient.sharedInstance().doAllTasks(url: urlUdacity,task: "POST", jsonBody: jsonBody, truncatePrefix: 5, completionHandlerForAllTasks:{ (results, error) in
                // Send values to completion handler
                if let error = error {
                    print(error)
                    DispatchQueue.main.async {
                       self.loginFailed(error.localizedDescription)
                    }
                } else {
                    self.getKey(results as! [String : AnyObject])
                    print(networkClient.Constants.UserSession.accountKey,  networkClient.Constants.UserSession.sessionID)
                    
                    networkClient.sharedInstance().getMyUser()
                    
                    //self.doSegue()
                    performUIUpdatesOnMain {
                        self.performSegue(withIdentifier: "loginNav", sender: self)
                        self.passwordTxt.text = ""
                        self.emailTxt.text = ""
                    }
                    
                }
                
            })
        }
        
    }


}

