
//
//  Email.swift
//  Guaranteed Pricing
//
//  Created by DePauw on 5/3/16.
//  Copyright © 2016 DePauw. All rights reserved.
//

import Foundation
import UIKit
import MessageUI

class Email: UIViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate  {
    
    var body: String = ""
    
    @IBOutlet weak var checkoutButton: UIButton!
    @IBOutlet weak var checkoutTotal: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func checkoutButtonClick(sender: AnyObject) {
        let picker = MFMailComposeViewController()
        picker.mailComposeDelegate = self
        picker.setToRecipients(["alexandermiller_2016@depauw.edu"])
        picker.setSubject("Subject")
        picker.setMessageBody("Body", isHTML: false)
        
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        body = textView.text
        
        if text == "\n" {
            textView.resignFirstResponder()
            
            return false
        }
        
        return true
    }
}