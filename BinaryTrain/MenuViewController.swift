//
//  MenuViewController.swift
//  BinaryTrain
//
//  Created by neil robichaud on 2016-09-15.
//  Copyright © 2016 neil robichaud. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, MyProtocol {
    override func shouldAutorotate() -> Bool {
        return false
    }
    func setResultOfBusinessLogic(valueSent: [String]) {
        typesOfBrick = valueSent
    }
    func setDecimal(b:Bool){
        decimalToggle = b
    }

    var checkedIndexPaths = [NSIndexPath]()
    var typesOfBrick = ["asdf"]
    var decimalToggle = true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Main Menu"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "newGame"{
            if let buttonvc = segue.destinationViewController as? ButtonViewController{
                buttonvc.brickTypes = typesOfBrick
                buttonvc.decimalToggle = decimalToggle
            }
            
        }
        else if segue.identifier == "menu2Options"{
            if let optionsvc = segue.destinationViewController as? OptionsTableViewController{
                optionsvc.delegate = self
                optionsvc.decimal = decimalToggle
                
                
            }
        }
        
    }


}
