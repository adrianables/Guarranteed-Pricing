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
    
    @IBOutlet weak var forgotPassword: UIButton!
    
    let myRootRef = Firebase(url:"https://sizzling-inferno-451.firebaseio.com/")
    let segueIdentifier = "login_successful_segue"
    let seguePassword  = "forgot_password"
    let segueReset = "reset_password"
    var loggedInSuccessfully = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentUser()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func forgotPassClick(sender: AnyObject) {
        self.performSegueWithIdentifier(seguePassword, sender: self)
    }
    
    // Check and see if the current user is logged in, if so, move past this page.
    func getCurrentUser(){
        if App.sharedInstance.firebaseRef.authData != nil {
            self.loggedInSuccessfully = true
            self.performSegueWithIdentifier(segueIdentifier, sender: self)
            print("Should have left this page")
            
            // user authenticated
            print(myRootRef.authData)
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
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            } else {
                // user is logged in, check authData for data
                let usernameText = self.username.text!
                let passwordText = self.password.text!
                let emailArray = self.username.text!.characters.split{$0 == "@"}.map(String.init)
                App.sharedInstance.firebaseRef.childByAppendingPath("users/"+emailArray[0]).observeSingleEventOfType(.Value, withBlock: { snapshot in
                    
                    let shap = snapshot.value!.objectForKey("password_reset") as! Bool
                    let activated = snapshot.value!.objectForKey("active") as! Bool
                    
                    if shap == true {
                        // redirect to password reset page
                        App.sharedInstance.currentUsername = usernameText
                        App.sharedInstance.passwordResetTemp = passwordText
                        self.performSegueWithIdentifier(self.segueReset, sender: self)
                    }
                    else if activated == false {
                        let alert = UIAlertController(title: "Deactivated User", message: "Unfortunately, your account has been marked as deactivated. Please contact your company administrators to resolve this issue.", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                    else {
                        
                        // just log in
                        self.loggedInSuccessfully = true
                        self.performSegueWithIdentifier(self.segueIdentifier, sender: self)
                    }
                    
                    // Error Handling
                    }, withCancelBlock: { error in
                        if error != nil {
                            
                            var ErrorMessage = ""
                            
                            if let errorCode = FAuthenticationError(rawValue: error.code) {
                                
                                if(errorCode == FAuthenticationError.UserDoesNotExist)
                                {
                                    ErrorMessage = "Unfortunately, our system could not find this user."
                                }
                                else if(errorCode == FAuthenticationError.InvalidEmail)
                                {
                                    ErrorMessage = "Unfortunately, our system could not find this user."
                                }
                                else if(errorCode == FAuthenticationError.InvalidPassword)
                                {
                                    ErrorMessage = "Unfortunately, our system could log you in with that email and password. Please try again."
                                }
                                else if(errorCode == FAuthenticationError.NetworkError)
                                {
                                    ErrorMessage = "Unfortunately, it appears you are not connected to the internet."
                                }
                                else
                                {
                                    ErrorMessage = "Unfortunately, we're not sure what went wrong but we're looking into it."
                                }
                                
                                print(ErrorMessage)
                            }
                        }
                })
            }
            
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String ,sender: AnyObject?) -> Bool {
        return (identifier == self.segueIdentifier && self.loggedInSuccessfully) ||
        (identifier == self.seguePassword) || (identifier == self.segueReset)
    }
}
