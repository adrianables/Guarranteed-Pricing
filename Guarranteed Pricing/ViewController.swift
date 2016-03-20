//
//  ViewController.swift
//  Guarranteed Pricing
//
//  Created by DePauw on 3/18/16.
//  Copyright © 2016 True Tech Home Services. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet var username : UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func loginAttempt(sender: UIButton){
        // check internet connection
        
        // load firebase url
        let ref = Firebase(url: "https://<YOUR-FIREBASE-APP>.firebaseio.com")
        
        // sign in
        ref.authUser(self.username.text, self.password.text) {
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

