//
//  uiHelper.swift
//  SwiftOnTheMap
//
//  Created by Paul Omeally on 9/7/17.
//  Copyright © 2017 Paul Omeally. All rights reserved.
//

import Foundation
import UIKit

class UIHelper {

     func handleUINavigation (presentVC: UIViewController)
     {
        
            let  alertController = UIAlertController()
            alertController.title = "Not registered"
            alertController.message = "Either the password or the username are wrong"
            

            presentVC.present(alertController, animated:true,completion: nil)
                
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                    alertController.dismiss(animated: true, completion: nil)
                }))
        
        }
    
    func DisplayErrorAlerts(msg: String, currentViewController: UIViewController?)
    {
    
            //print(msg)
            
            let  alertController = UIAlertController()
            alertController.title = "Not registered"
            alertController.message = msg
            
            performUIUpdatesOnMain {
                
                currentViewController?.present(alertController, animated: true, completion: nil)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                    alertController.dismiss(animated: true, completion: nil)
                }))
            }
            
    
    
    }
}
