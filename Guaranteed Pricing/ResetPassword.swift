//
//  ResetPassword.swift
//  Guaranteed Pricing
//
//  Created by DePauw on 5/4/16.
//  Copyright © 2016 DePauw. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ResetPassword: UIViewController {
    
    @IBOutlet weak var newPassword: UITextField!
    
    @IBOutlet weak var newPasswordConfirm: UITextField!
    
    @IBOutlet weak var changePasswordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func changePasswordClick(sender: UIButton) {
        
        let firstPass: String = newPassword.text!
        let secondPass: String = newPasswordConfirm.text!
        
        if firstPass == secondPass {
            App.sharedInstance.firebaseRef.changePasswordForUser(App.sharedInstance.currentUsername, fromOld: App.sharedInstance.passwordResetTemp,
                toNew: firstPass, withCompletionBlock: { error in
                    if error != nil {
                        
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
                        // user is logged in
                        let emailArray = App.sharedInstance.currentUsername.characters.split{$0 == "@"}.map(String.init)
                        let resetRef = App.sharedInstance.firebaseRef.childByAppendingPath("users/"+emailArray[0])
                        let passwordReset = ["password_reset": false]
                        resetRef.updateChildValues(passwordReset);
                        self.performSegueWithIdentifier("reset_successful", sender: self)
                    }
                    
            })
        } else {

                let alert = UIAlertController(title: "Do Not Match", message: "It appears your passwords do not match. Please try retyping them.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}