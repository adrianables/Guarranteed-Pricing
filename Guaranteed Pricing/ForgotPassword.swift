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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func retrievePasswordButton(sender: AnyObject){
        let ref = Firebase(url: "https://sizzling-inferno-451.firebaseio.com/")
        ref.resetPasswordForUser(self.email.text, withCompletionBlock: { error in
            if error != nil {
                // There was an error processing the request
                // an error occured while attempting login
                //* Create system error, connection, specific API firebase errors etc etc.
                //look up UIAlert view controller or msgbox
                if let errorCode = FAuthenticationError(rawValue: error.code) {
                    switch (errorCode) {
                    case .UserDoesNotExist:
                        print("Handle invalid user")
                    case .InvalidEmail:
                        print("Handle invalid email")
                    case .InvalidPassword:
                        print("Handle invalid password")
                    default:
                        print("Handle default situation")
                    }
                }
            } else {
                // Password reset sent successfully
                print("Sent successfully to email")
        }
        })
    }
}