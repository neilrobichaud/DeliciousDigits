//
//  OptionsTableViewController.swift
//  BinaryTrain
//
//  Created by neil robichaud on 2016-09-15.
//  Copyright © 2016 neil robichaud. All rights reserved.
//

import UIKit
protocol MyProtocol {
    func setResultOfBusinessLogic(valueSent: [String])
    func setDecimal(b:Bool)
}
class OptionsTableViewController: UITableViewController {
    var delegate : MyProtocol?
    override func shouldAutorotate() -> Bool {
        return false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title  = "Options"
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
    var decimal = true
    
    @IBAction func toggleDecimal(sender: UISwitch) {
        if sender.on{
            decimal = true
            delegate?.setDecimal(true)
        }
        else{
            decimal = false
            delegate?.setDecimal(false)
        }
    }
    
    var brickFiles = ["banana.png","cactus.png","cheese.png","lettuce.png","pebble.png","pinecone.png","raspberry.png","tomato.png"]
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
