//
//  StudentListVC.swift
//  SwiftOnTheMap
//
//  Created by Paul Omeally on 9/23/17.
//  Copyright © 2017 Paul Omeally. All rights reserved.
//

import UIKit

class StudentListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var tableView: UITableView!
    let shareResource = UIApplication.shared
    
    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let studentCell = tableView.dequeueReusableCell(withIdentifier: "studentList", for: indexPath)

        if let firstName = StudentDS.sharedInstance.studentCollection[indexPath.row].firstName as? String,
         let lastName = StudentDS.sharedInstance.studentCollection[indexPath.row].lastName as? String,
         let mediaUrl = StudentDS.sharedInstance.studentCollection[indexPath.row].mediaUrl as? String
        {
            studentCell.textLabel?.text = "\(firstName as! String) \(lastName as! String)"
            studentCell.detailTextLabel?.text? = "\(mediaUrl as! String)"
            
        }
        else {
            
            studentCell.textLabel?.text? = "Missing"
        }
        
        return studentCell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentDS.sharedInstance.studentCollection.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let toOpen = tableView.cellForRow(at: indexPath)?.detailTextLabel?.text! {
            // mutable object to edit value
            var open = toOpen
            // remove spaces to prevent crash
            if open.range(of: " ") != nil{
                open = open.replacingOccurrences(of: " ", with: "")
            }
            // set prefix to aid safari
            if (open.range(of: "://") != nil){
                shareResource.open(URL(string: open)!, options: [:] , completionHandler: nil)
            } else {
                shareResource.open(URL(string: "http://\(open)")!, options: [:] , completionHandler: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let firstName = StudentDS.sharedInstance.studentCollection[indexPath.row].firstName as? String,
        let lastName = StudentDS.sharedInstance.studentCollection[indexPath.row].lastName as? String,
        let mediaUrl = StudentDS.sharedInstance.studentCollection[indexPath.row].mediaUrl as? String
        {
            return 42.0
            
        }
        
        else {
            return 0.0
        }
        
    }
    
    



 

}
