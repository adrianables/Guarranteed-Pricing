//
//  App.swift
//  Guaranteed Pricing
//
//  Created by DePauw on 4/29/16.
//  Copyright © 2016 DePauw. All rights reserved.
//

import Foundation
import Firebase

/** This struct is meant to hold all of the information taken from the firebase database */
struct Service  {
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

class App {
    
    /** Singleton reference */
    static let sharedInstance = App()
    
    private init() {}
    
    /** firebaseRef contains the root reference to the firebase database */
    let firebaseRef = Firebase(url:"https://sizzling-inferno-451.firebaseio.com")
    
    /** serviceArray contains all of the services throughout the entire application */
    var serviceArray: [Service] = []
    
    /** cartArray contains all the objects currently in the cart for checkout */
    var cartArray: [Service] = []
    
    /** define the string for the hvac type */
    let hvacTypeString = "hvac"
    
    /** define the string for the plumbing type */
    let plumbingTypeString = "plumbing"
    
    /** define the string for the handyman type */
    let handymanTypeString = "handyman"
    
    /** define the string for the repairs type */
    let repairsTypeString = "repairs"
    
    /** define the string for the misc type */
    let miscTypeString = "miscellaneous"
    
    let cellIdentifier = "item"
    
    /** This function returns array of all the objects by a given type string */
    func getAllObjectsByType(type: String) -> [Service]
    {
        var tempArray: [Service] = []
        
        for var i = 0; i < self.serviceArray.count; ++i
        {
            if(self.serviceArray[i].type == type)
            {
                tempArray.append(self.serviceArray[i])
            }
        }
        return tempArray
    }
    
    /**
    * isInCart
    *
    * a boolean function which checks to see if a specific service object is in the array
    */
    func isInCart(service: Service) -> Bool {
        
        var isInArray = false
        
        for var i = 0; i < self.cartArray.count; i++
        {
            if(self.cartArray[i].name == service.name)
            {
                isInArray = true
            }
        }
        return isInArray
    }
    
    /**
    * printCart
    * 
    * A simple debugger function to help ensure the data is being stored correctly
    */
    func printCart(){
        for var i = 0; i < self.cartArray.count; i++ {
            print(self.cartArray[i].name)
        }
    }
    
    /**
    * removeFromCart
    *
    * This function cycles through the array and removes the given service object based on its index
    */
    func removeFromCart(service: Service) {
        for var i = 0; i < self.cartArray.count; i++
        {
            if(self.cartArray[i].name == service.name)
            {
                self.cartArray.removeAtIndex(i)
                break
            }
        }
    }
     
    /**
     * downloadAllObject
     *
     * a void function which calls the firebase database and downloads all of the information and stores it in serviceArray
     */
    func downloadAllObjects() {
        
        // pass the reference to the tableview so the reload call can be made here
        
        firebaseRef.childByAppendingPath("services").observeSingleEventOfType(.Value, withBlock: { snapshot in
            for child in snapshot.children {
                
                let name = child.key!! as String
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
                
                self.serviceArray.append(service)
            }
            
            NSNotificationCenter.defaultCenter().postNotificationName("refreshMyTableView", object: nil)
            
        // Error Handling
        }, withCancelBlock: { error in
            if error != nil {
                
                var ErrorMessage = ""
                
                if let errorCode = FAuthenticationError(rawValue: error.code) {
                    
                    if(errorCode == FAuthenticationError.UserDoesNotExist)
                    {
                        ErrorMessage = "Unfortunately, our system could not find this user."
                    }
                    else if(errorCode == FAuthenticationError.InvalidEmail)
                    {
                        ErrorMessage = "Unfortunately, our system could not find this user."
                    }
                    else if(errorCode == FAuthenticationError.InvalidPassword)
                    {
                        ErrorMessage = "Unfortunately, our system could log you in with that email and password. Please try again."
                    }
                    else if(errorCode == FAuthenticationError.NetworkError)
                    {
                        ErrorMessage = "Unfortunately, it appears you are not connected to the internet."
                    }
                    else
                    {
                        ErrorMessage = "Unfortunately, we're not sure what went wrong but we're looking into it."
                    }
                    
                    print(ErrorMessage)
                }
            }
        })
    }
}