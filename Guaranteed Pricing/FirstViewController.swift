//
//  FirstViewController.swift
//  Guaranteed Pricing
//
//  Created by DePauw on 3/13/16.
//  Copyright © 2016 DePauw. All rights reserved.
//

import UIKit
import Firebase

class FirstViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Create a reference to a Firebase location
        let myRootRef = Firebase(url:"https://sizzling-inferno-451.firebaseio.com/")
        // Write data to Firebase
        //myRootRef.setValue("Do you have data? You'll love Firebase.")
        myRootRef.authUser(username: self.username.text, password: "correcthorsebatterystaple") {
            error, authData in
            if error != nil {
                // an error occured while attempting login
            } else {
                // user is logged in, check authData for data
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

