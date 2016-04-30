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
    
    let cellIdentifier = "item"
    let instanceOfApp = App()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        // add a listener for the async call to activate refreshList()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshList:", name:"refreshMyTableView", object: nil)
        
        // call async method in App.swift to download all of the content from the database
        instanceOfApp.downloadAllObjects()
    }
    
    /** refreshList is called when the async call from App.swift is finished */
    func refreshList(notification: NSNotification){
        self.tableView!.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return instanceOfApp.serviceArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        let item = instanceOfApp.serviceArray[indexPath.row]
        cell.textLabel?.text = item.name
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let item = instanceOfApp.serviceArray[indexPath.row]
            
            let destination: AllListView = segue.destinationViewController as! AllListView
            destination.item = item
        }
    }
}