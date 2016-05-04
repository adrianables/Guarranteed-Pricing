//
//  All.swift
//  Guaranteed Pricing
//
//  Created by DePauw on 3/30/16.
//  Copyright © 2016 DePauw. All rights reserved.

import Foundation
import UIKit

class Misc: UITableViewController {
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return App.sharedInstance.getAllObjectsByType(App.sharedInstance.miscTypeString).count
    }
    
    
    @IBAction func logoutButtonClick(sender: UIButton) {
        App.sharedInstance.firebaseRef.unauth()
        self.performSegueWithIdentifier("logout", sender: self)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(App.sharedInstance.cellIdentifier, forIndexPath: indexPath)
        let item = App.sharedInstance.getAllObjectsByType(App.sharedInstance.miscTypeString)[indexPath.row]
        cell.textLabel?.text = item.name
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let item = App.sharedInstance.getAllObjectsByType(App.sharedInstance.miscTypeString)[indexPath.row]
            
            let destination: AllListView = segue.destinationViewController as! AllListView
            destination.item = item
        }
    }
}