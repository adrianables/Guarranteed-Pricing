//
//  Reachability.swift
//  Guaranteed Pricing
//
//  Created by DePauw on 3/21/16.
//  Copyright © 2016 DePauw. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Reachability: UINavigationController, UITableViewDelegate, UITableViewDataSource {
    var items: [String] = []
    var tableView: UITableView!
    let cellIdentifier = "CellIdentifier"
    
    @IBOutlet var Description : UITextField!
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.tableView = UITableView(frame:self.view!.frame)
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        self.view?.addSubview(self.tableView)
        
        let ref = Firebase(url:"https://sizzling-inferno-451.firebaseio.com/services")
        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
            for child in snapshot.children {
                
                let name = child.value!!.objectForKey("name") as! String
                
                self.items.append(name)
            }
            // do some stuff once
            //            print(snapshot.value)
            
            // get these values and put them in the cell's text view. key is more important
            //            print(snapshot.key)
            
            
            
            // add to the array and just this array
            
            
            self.tableView!.reloadData()
        })
    }
    
    @IBAction func cellTransition(sender: AnyObject) {
        let myRootRef = Firebase(url:"https://sizzling-inferno-451.firebaseio.com/")
        
        self.performSegueWithIdentifier("CellIdentifier", sender: self)
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        // Fetch Fruit
        let fruit = items[indexPath.row]
        
        // Configure Cell
        cell.textLabel?.text = fruit
        return cell
    }
    
    // onclick printing
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(items[indexPath.row])
        self.performSegueWithIdentifier("CellIdentifier", sender: self)
    }
}