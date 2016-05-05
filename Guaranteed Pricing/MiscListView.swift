//
//  MiscListView.swift
//  Guaranteed Pricing
//
//  Created by DePauw on 4/24/16.
//  Copyright © 2016 DePauw. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class MiscListView: UITableViewController {
    

    @IBOutlet weak var addButton: UIButton!
    
    var item: Service?
    let cellIdentifier = "item"
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        if(App.sharedInstance.isInCart(item!))
        {
            addButton.setTitle("−", forState: UIControlState.Normal)
        }
        else
        {
            addButton.setTitle("➕", forState: UIControlState.Normal)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = self.item {
            return 16;
        }
        return 0;
    }
    
    
    @IBAction func addButtonClick(sender: UIButton) {
        if(App.sharedInstance.isInCart(item!) == false)
        {
            App.sharedInstance.cartArray.append(item!)
            addButton.setTitle("−", forState: UIControlState.Normal)
        }
        else
        {
            App.sharedInstance.removeFromCart(item!)
            addButton.setTitle("➕", forState: UIControlState.Normal)
        }
        
        // debugging tool
        //App.sharedInstance.printCart()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        
        if let item = self.item {
            var name = ""
            var description = ""
            
            switch indexPath.row {
            case 0: name = "Name:"
            description = item.name
            case 1: description = "Description:"
            description = item.description
            case 2: name = "type"
            description = item.type
            case 3: name = "estimated_payment"
            description = item.estimated_payment
            case 4: name = "ge_min_payement"
            description = item.ge_min_payment
            case 5: name = "hourly_rate"
            description = item.hourly_rate
            case 6: name = "hours"
            description = item.hours
            case 7:name = "income_category"
            description = item.income_category
            case 8:name = "part_cost"
            description = item.part_cost
            case 9: name = "part_markup"
            description = item.part_markup
            case 10: name = "standard_price"
            description = item.standard_price
            case 11: name = "task_number"
            description = item.task_number
            case 12: name = "ttsp_savings"
            description = item.ttsp_savings
            case 13: name = "ttsp_price"
            description = item.ttsp_price
            case 14: name = "agreement_discount"
            description = item.agreement_discount
            case 15: name = "annual_part_increase"
            description = item.annual_part_increase
                
                
            default: name = "error"
            description = "error"
            }
            
            
            cell.textLabel?.text = name
            cell.detailTextLabel?.text = description
        }
        
        return cell
    }
}