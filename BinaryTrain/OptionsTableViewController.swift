//
//  OptionsTableViewController.swift
//  BinaryTrain
//
//  Created by neil robichaud on 2016-09-15.
//  Copyright © 2016 neil robichaud. All rights reserved.
//

import UIKit
class OptionsTableViewController: UITableViewController {
    
    var Dswitch: Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title  = "Options"
        Dswitch = defaults.boolForKey("switch")
        if Dswitch!{
            decimalSwitch.setOn(true, animated: false)
        }
        else{
            decimalSwitch.setOn(false, animated: false)
        }
    }
    var defaults = NSUserDefaults.standardUserDefaults()
    

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if cell.reuseIdentifier == "Cell"{
            if defaults.boolForKey(cell.textLabel!.text!){
                cell.accessoryType = .Checkmark
            }
            else{
                cell.accessoryType = .None
            }
        }
        
        
    }

    
    @IBOutlet weak var decimalSwitch: UISwitch!
    @IBAction func toggleDecimal(sender: UISwitch) {
        if sender.on{
            defaults.setBool(true, forKey: "switch")
        }
        else{
            defaults.setBool(false, forKey: "switch")
        }
    }
    
    var brickFiles = ["banana.png","cactus.png","cheese.png","lettuce.png","pebble.png","pinecone.png","raspberry.png"]
    var selectedRows =  [String]()
    
    
    /*
     cell gets clicked -> set accessory type to check -> save indexPath
     */
    
    //removes an index path from a list of index paths

    
    func removeString(list: [String], target: String) -> [String]{
        var newList = list
        for item in newList{
            if item == target{
                newList.removeAtIndex(newList.indexOf(item)!)
                
            }
        }
        
        return newList
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Topping Choices"
        }
        return ""
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath){
            if cell.reuseIdentifier == "Cell"{
                if cell.accessoryType == .None{
                    cell.accessoryType = .Checkmark
                    defaults.setBool(true, forKey: "\(cell.textLabel!.text!)")
                    selectedRows = defaults.stringArrayForKey("selectedRows") ?? []
                    selectedRows.append(brickFiles[indexPath.row])
                    defaults.setObject(selectedRows, forKey: "selectedRows")
                    
                }
                else{
                    cell.accessoryType = .None
                    defaults.setBool(false, forKey: "\(cell.textLabel!.text!)")
                    selectedRows = defaults.stringArrayForKey("selectedRows")!
                    selectedRows = removeString(selectedRows, target: brickFiles[indexPath.row])
                    defaults.setObject(selectedRows, forKey: "selectedRows")
                    
                }
            }
        }
    }
    
    
}
