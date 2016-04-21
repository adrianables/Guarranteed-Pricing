//
//  AllListView.swift
//  Guaranteed Pricing
//
//  Created by DePauw on 4/14/16.
//  Copyright © 2016 DePauw. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class AllListView: UITableViewController {
    
    @IBOutlet var Description: UILabel!
    
    var item: Service?
    let cellIdentifier = "item"
    
    override func viewDidLoad(){
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = self.item {
            return 16;
        }
        return 0;
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        if let item = self.item {
            var name = ""
            var description = ""
            
            switch indexPath.row {
            case 0: name = "Name:"
                description = item.name
            case 1: name = "Description"
                description = item.description
            default: name = "error"
                description = "error"
            }
            
            
            cell.textLabel?.text = name
            cell.detailTextLabel?.text = description
        }
        
        
        
        
        
        return cell
    }
    
    //    // onclick printing
    //    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    //        print(items[indexPath.row])
    //        self.performSegueWithIdentifier("CellIdentifier", sender: self)
    //    }
}
    


