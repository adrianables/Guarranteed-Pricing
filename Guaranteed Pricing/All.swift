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
    var hours: String
    var type: String
    var estimated_payment: String
    var ge_min_payment: String
    var hourly_rate: String
    var income_category: String
    var part_cost: String
    var part_markup: String
    var standard_price: String
    var task_number: String
    var ttsp_price: String
    var ttsp_savings: String
    var agreement_discount: String
    var annual_part_increase: String
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
                let hours = child.value!!.objectForKey("hours") as! String
                let type = child.value!!.objectForKey("type") as! String
                let agreement_discount = child.value!!.objectForKey("agreement_discount") as! String
                let annual_part_increase = child.value!!.objectForKey("annual_part_increase") as! String
                let estimated_payment = child.value!!.objectForKey("estimated_payment") as! String
                let ge_min_payment = child.value!!.objectForKey("ge_min_payment") as! String
                let income_category = child.value!!.objectForKey("income_category") as! String
                let part_cost = child.value!!.objectForKey("part_cost") as! String
                let part_mark_up = child.value!!.objectForKey("part_mark_up") as! String
                let standard_price = child.value!!.objectForKey("standard_price") as! String
                let task_number = child.value!!.objectForKey("task_number") as! String
                let ttsp_price = child.value!!.objectForKey("ttsp_price") as! String
                let ttsp_savings = child.value!!.objectForKey("ttsp_savings") as! String
                let hourly_rate = child.value!!.objectForKey("hourly_rate") as! String

               
                let service = Service(name: name, description: description, hours: hours, type: type, estimated_payment: estimated_payment, ge_min_payment: ge_min_payment, hourly_rate: hourly_rate,income_category: income_category, part_cost: part_cost, part_markup: part_mark_up, standard_price: standard_price,  task_number: task_number, ttsp_price: ttsp_price, ttsp_savings: ttsp_savings, agreement_discount: agreement_discount,  annual_part_increase: annual_part_increase)
                
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