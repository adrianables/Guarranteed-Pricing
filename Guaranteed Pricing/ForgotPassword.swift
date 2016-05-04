//
//  ForgotPassword.swift
//  Guaranteed Pricing
//
//  Created by DePauw on 3/30/16.
//  Copyright © 2016 DePauw. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ForgotPassword: UIViewController {
    
    @IBOutlet var email: UITextField!
    
    @IBOutlet weak var backButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backButtonClcik(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {});
    }
    
    @IBAction func retrievePasswordButton(sender: AnyObject){
        print("called")
        let ref = Firebase(url: "https://sizzling-inferno-451.firebaseio.com/")
        ref.resetPasswordForUser(self.email.text, withCompletionBlock: { error in
            if error != nil {
                
                print("here")
                
                // There was an error processing the request
                // an error occured while attempting login
                //* Create system error, connection, specific API firebase errors etc etc.
                //look up UIAlert view controller or msgbox
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
                // Password reset sent successfully
                print("Sent successfully to email")
                
                // set the status of the individual to password reset
                let emailArray = self.email.text!.characters.split{$0 == "@"}.map(String.init)
                let resetRef = App.sharedInstance.firebaseRef.childByAppendingPath("users/"+emailArray[0])
                let passwordReset = ["password_reset": true]
                resetRef.updateChildValues(passwordReset);
                
                let alert = UIAlertController(title: "Sent successfully to email", message: "Check your email for the special code to paste in the password box of the login page", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
                    alert.dismissViewControllerAnimated(true, completion: nil)
                    self.dismissViewControllerAnimated(true, completion: {});
                }))
                self.presentViewController(alert, animated: true, completion: nil)
        }
        })
    }
}