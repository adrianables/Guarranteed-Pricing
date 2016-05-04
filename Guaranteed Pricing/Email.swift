
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
        
        let refreshAlert = UIAlertController(title: name, message: "All data will be lost.", preferredStyle: UIAlertControllerStyle.Alert)
        
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
        
        let mailComposeViewController = configuredMailComposeViewController()
        
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["email@YourApp.com"])
        mailComposerVC.setSubject("App Feedback")
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
            default:
                break
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}