
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

class Email: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate  {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var total: UILabel!
    
    @IBOutlet weak var check: UIButton!
    
    var customerEmail: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        showButtonIfNeedBe()
        showTotal()
    }
    
    // A String builder function which takes the double value and converts it to the local currency style
    func showTotal(){
        let formatter = NSNumberFormatter()
        formatter.numberStyle = .CurrencyStyle
        total.text = formatter.stringFromNumber(App.sharedInstance.getCartTotal())
    }
    
    // disables the checkout button if the cart is empty
    func showButtonIfNeedBe(){
        if App.sharedInstance.cartArray.count == 0 {
            check.enabled = false
        } else {
            check.enabled = true
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return App.sharedInstance.cartArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.textLabel?.text = App.sharedInstance.cartArray[indexPath.row].name
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let name: String = App.sharedInstance.cartArray[indexPath.row].name
        
        let refreshAlert = UIAlertController(title: name, message: "This will remove it from the cart.", preferredStyle: UIAlertControllerStyle.Alert)
        
        // remove
        refreshAlert.addAction(UIAlertAction(title: "Delete", style: .Default, handler: { (action: UIAlertAction!) in
            App.sharedInstance.cartArray.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            
            // debugging tool
            // App.sharedInstance.printCart()
            
            self.showTotal()
            self.showButtonIfNeedBe()
        }))
        
        // cancel
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in
            refreshAlert.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        presentViewController(refreshAlert, animated: true, completion: nil)
    }

    @IBAction func emailAction(sender: AnyObject) {
        
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Customer Email", message: "Enter your email address. Example: john@service.com", preferredStyle: .Alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.text = ""
        })
        
        //3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            print("Text field: \(textField.text)")
            self.customerEmail = textField.text!
            
            // show the email
            let mailComposeViewController = self.configuredMailComposeViewController()
            
            if MFMailComposeViewController.canSendMail() {
                self.presentViewController(mailComposeViewController, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
        }))
        
        // 4. Present the alert.
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["alexandermiller_2016@depauw.edu"])
        mailComposerVC.setSubject("True Tech Home Services:")
        mailComposerVC.setMessageBody("Hi Team!\n\nI would like to share the following feedback..\n", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let alert=UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: UIAlertControllerStyle.Alert);
        //show it
        showViewController(alert, sender: self);
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
        switch result {
            case MFMailComposeResultCancelled:
                print("Cancelled mail")
            case MFMailComposeResultSent:
                print("Mail Sent")
            
                var tempString: String = ""
                
                for var i = 0; i < App.sharedInstance.cartArray.count; i++
                {
                    tempString = tempString + "," + App.sharedInstance.cartArray[i].name
                }
                
                // get the date and be ready to store it on firebase
                let date = NSDate()
                let calendar = NSCalendar.currentCalendar()
                let components = calendar.components([.Day , .Month , .Year], fromDate: date)
                
                let year =  components.year
                let month = components.month
                let day = components.day
                
                let dateString = String(month) + "/" + String(day) + "/" + String(year)
                
                // create an instance of the invoice using a random id
                let postRef = App.sharedInstance.firebaseRef.childByAppendingPath("invoices")
                let post1 = ["client": customerEmail, "services": tempString, "date": dateString, "tech": App.sharedInstance.currentUsername]
                let post1Ref = postRef.childByAutoId()
                post1Ref.updateChildValues(post1)
            
            default:
                break
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}