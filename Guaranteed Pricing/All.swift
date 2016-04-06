
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

class All: UINavigationController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
//     var items: [String] = []
    var items = [String]()
    var item: String = ""
    var keys = ["EPLU100", "EPLU200"]

    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = Firebase(url:"https://sizzling-inferno-451.firebaseio.com/services")
        
        // Get a reference to our posts
        // Retrieve new posts as they are added to your database
        
        
        ref.observeEventType(.ChildAdded, withBlock: { snapshot in
            let item = (snapshot.key)
            print(item)
            self.items.append(item)
//            self.tableView.reloadData()
            print(self.items.count)
            print(snapshot.value)

        })
        
    }

            
//       self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
//
//        let ref = Firebase(url:"https://sizzling-inferno-451.firebaseio.com/services")
//        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
//            // do some stuff once
//            print(snapshot.value)
//            
//            // get these values and put them in the cell's text view. key is more important
//            print(snapshot.key)
//            print(snapshot.value["description"])
//            
//            // add to the array and just this array
//            self.items.append(snapshot.key)
//        })
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
        
        let ref = Firebase(url:"https://sizzling-inferno-451.firebaseio.com/services")
        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
            // do some stuff once
            print(snapshot.value)
            
            // get these values and put them in the cell's text view. key is more important
            print(snapshot.key)
            print(snapshot.value["description"])
            
            // add to the array and just this array
            self.items.append(snapshot.key)
        })

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return self.items.count;print(self.items.count)
        return 2
    }
    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        
        //cell.textLabel?.text = self.items[indexPath.row]
        cell.textLabel?.text = keys[indexPath.row]
        return cell
    }
}
    
    
