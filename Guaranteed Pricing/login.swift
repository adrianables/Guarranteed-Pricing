//
//  login.swift
//  Guaranteed Pricing
//
//  Created by DePauw on 3/21/16.
//  Copyright © 2016 DePauw. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Login: UIViewController {
    @IBOutlet var username : UITextField!
    @IBOutlet var password: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentUser()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Check and see if the current user is logged in, if so, move past this page.
    func getCurrentUser(){
        let ref = Firebase(url: "https://sizzling-inferno-451.firebaseio.com/")
        if ref.authData != nil {
            // user authenticated
            print(ref.authData)
            // user is logged in, check authData for data
            // TODO: get this below working. Just needs to move from login to next page.
            self.performSegueWithIdentifier("login_successful_segue", sender: self)
        }
    }
    
    @IBAction func loginAttempt(sender: AnyObject) {
        // Create a reference to a Firebase location
        let myRootRef = Firebase(url:"https://sizzling-inferno-451.firebaseio.com/")
        // Write data to Firebase
        //myRootRef.setValue("Do you have data? You'll love Firebase.")
        myRootRef.authUser(self.username.text, password: self.password.text) {
            error, authData in
            print("Request returned!");
            if error != nil {
                // an error occured while attempting login
                //* Create system error, connection, specific API firebase errors etc etc.
                //look up UIAlert view controller or msgbox
                if let errorCode = FAuthenticationError(rawValue: error.code) {
                    switch (errorCode) {
                    case .UserDoesNotExist:
                        print("Handle invalid user")
                        let refreshAlert = UIAlertController(title: "Refresh", message: "All data will be lost.", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                            print("Handle Ok logic here")
                        }))
                    case .InvalidEmail:
                        print("Handle invalid email")
                        let refreshAlert = UIAlertController(title: "Refresh", message: "All data will be lost.", preferredStyle: UIAlertControllerStyle.Alert)
                        
                        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                            print("Handle Ok logic here")
                        }))
                    case .InvalidPassword:
                        print("Handle invalid password")
                    default:
                        print("Handle default situation")
                    }
                }
            } else {
                // user is logged in, check authData for data
                print("Successful login!");
                self.performSegueWithIdentifier("login_successful_segue", sender: self)
            }
            
        }
        print("Sending request...")
        
//        let refreshAlert = UIAlertController(title: "Refresh", message: "All data will be lost.", preferredStyle: UIAlertControllerStyle.Alert)
//        
//        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
//            print("Handle Ok logic here")
//        }))
//        
//        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
//            print("Handle Cancel Logic here")
//        }))
//        
//        presentViewController(refreshAlert, animated: true, completion: nil)
    }
}
