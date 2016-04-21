//
//  All.swift
//  Guaranteed Pricing
//
//  Created by DePauw on 3/30/16.
//  Copyright © 2016 DePauw. All rights reserved.
//

import Foundation
import UIKit
import Firebase

struct Service {
    var name: String
    var description: String
}

class All: UITableViewController {
    
    var items: [Service] = []
    let cellIdentifier = "item"
    
    @IBOutlet var Description : UITextField!
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        let ref = Firebase(url:"https://sizzling-inferno-451.firebaseio.com/services")
        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
            for child in snapshot.children {
                
                let name = child.value!!.objectForKey("name") as! String
                let description = child.value!!.objectForKey("description") as! String
               
                let service = Service(name: name, description: description)
                
                self.items.append(service)
            }
            // do some stuff once
            //            print(snapshot.value)
            
            // get these values and put them in the cell's text view. key is more important
            //            print(snapshot.key)
            
            
            
            // add to the array and just this array
            
            
            self.tableView!.reloadData()
        })
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "CellIdentifier" {
//            player = Player(name: nameTextField.text!, game: "Chess", rating: 1)
//        }
//    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        // Fetch Fruit
        let item = items[indexPath.row]
        
        // Configure Cell
        cell.textLabel?.text = item.name
        return cell
    }
    
//    // onclick printing
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        print(items[indexPath.row])
//        self.performSegueWithIdentifier("CellIdentifier", sender: self)
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let item = self.items[indexPath.row]
            
            let destination: AllListView = segue.destinationViewController as! AllListView
            destination.item = item
        }
    }
}