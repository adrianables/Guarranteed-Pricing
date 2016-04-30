//
//  HVAC.swift
//  Guaranteed Pricing
//
//  Created by DePauw on 3/30/16.
//  Copyright © 2016 DePauw. All rights reserved.
//

import Foundation
import UIKit

class HVAC: UITableViewController {
    
    let cellIdentifier = "item"
    let instanceOfApp = App()
    var hvacArray:[Service] = []
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        // add a listener for the async call to activate refreshList()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshList:", name:"refreshMyTableView", object: nil)
        
        // call async method in App.swift to download all of the content from the database
        instanceOfApp.downloadAllObjects()
    }
    
    /** refreshList is called when the async call from App.swift is finished */
    func refreshList(notification: NSNotification){
        
        // clear the local array if already containing items
        if(hvacArray.count > 0)
        {
            hvacArray.removeAll()
        }
        
        // loop through the array and get all the needed objects for this type
        for var i = 0; i < instanceOfApp.serviceArray.count; ++i {
            
            if(instanceOfApp.serviceArray[i].type == instanceOfApp.hvacTypeString)
            {
                hvacArray.append(instanceOfApp.serviceArray[i])
            }
        }

        // load the table
        self.tableView!.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hvacArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        let item = hvacArray[indexPath.row]
        cell.textLabel?.text = item.name
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let item = hvacArray[indexPath.row]
            
            let destination: AllListView = segue.destinationViewController as! AllListView
            destination.item = item
        }
    }
}