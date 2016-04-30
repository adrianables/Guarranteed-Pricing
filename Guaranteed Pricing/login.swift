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
    let myRootRef = Firebase(url:"https://sizzling-inferno-451.firebaseio.com/")
    let segueIdentifier = "login_successful_segue"
    var loggedInSuccessfully = false
    
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
        if myRootRef.authData != nil {
            
            // user authenticated
            print(myRootRef.authData)
            
            // user is logged in, check authData for data
            self.performSegueWithIdentifier(segueIdentifier, sender: self)
        }
    }
    
    @IBAction func loginAttempt(sender: AnyObject) {
        myRootRef.authUser(self.username.text, password: self.password.text) {
            error, authData in
            print("Request returned!");
            
            if error != nil {
                
                self.loggedInSuccessfully = false
                
                var ErrorTitle = ""
                var ErrorMessage = ""
                
                if let errorCode = FAuthenticationError(rawValue: error.code) {
                    
                    if(errorCode == FAuthenticationError.UserDoesNotExist)
                    {
                        ErrorTitle = "User not found"
                        ErrorMessage = "Unfortunately, our system could not find this user."
                    }
                    else if(errorCode == FAuthenticationError.InvalidEmail)
                    {
                        ErrorTitle = "User not found"
                        ErrorMessage = "Unfortunately, our system could not find this user."
                    }
                    else if(errorCode == FAuthenticationError.InvalidPassword)
                    {
                        ErrorTitle = "Incorrect Credentials"
                        ErrorMessage = "Unfortunately, our system could log you in with that email and password. Please try again."
                    }
                    else if(errorCode == FAuthenticationError.NetworkError)
                    {
                        ErrorTitle = "Network not found"
                        ErrorMessage = "Unfortunately, it appears you are not connected to the internet."
                    }
                    else
                    {
                        ErrorTitle = "Unknown Error"
                        ErrorMessage = "Unfortunately, we're not sure what went wrong but we're looking into it."
                    }
                    
                    ErrorMessage = ErrorMessage + " If you continue to experience this, please contact the developers at truetechprogrammers@gmail.com"
                    
                    let alert = UIAlertController(title: ErrorTitle, message: ErrorMessage, preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Button", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            } else {
                // user is logged in, check authData for data
                self.loggedInSuccessfully = true
                self.performSegueWithIdentifier(self.segueIdentifier, sender: self)
                
            }
            
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String ,sender: AnyObject?) -> Bool {
        return (identifier == self.segueIdentifier && self.loggedInSuccessfully)
    }
}
