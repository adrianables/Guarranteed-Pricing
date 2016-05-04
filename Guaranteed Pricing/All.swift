//
//  All.swift
//  Guaranteed Pricing
//
//  Created by DePauw on 3/30/16.
//  Copyright © 2016 DePauw. All rights reserved.
//

import Foundation
import UIKit

class All: UITableViewController {
    
    @IBOutlet weak var cartButton: UIButton!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        // add a listener for the async call to activate refreshList()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshList:", name:"refreshMyTableView", object: nil)
        
        // call async method in App.swift to download all of the content from the database
        App.sharedInstance.downloadAllObjects()
    }

    
    @IBAction func logoutButton(sender: UIButton) {
        App.sharedInstance.firebaseRef.unauth()
        self.performSegueWithIdentifier("logout", sender: self)
    }
    
    
    @IBAction func openCart(sender: AnyObject) {
        
    }
    
    /** refreshList is called when the async call from App.swift is finished */
    func refreshList(notification: NSNotification){
        self.tableView!.reloadData()
    }
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return App.sharedInstance.serviceArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(App.sharedInstance.cellIdentifier, forIndexPath: indexPath)
        let item = App.sharedInstance.serviceArray[indexPath.row]
        cell.textLabel?.text = item.name
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let item = App.sharedInstance.serviceArray[indexPath.row]
            
            let destination: AllListView = segue.destinationViewController as! AllListView
            destination.item = item
        }
    }
}