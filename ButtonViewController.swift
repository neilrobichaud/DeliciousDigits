//
//  ButtonViewController.swift
//  BinaryTrain
//
//  Created by neil robichaud on 2016-09-01.
//  Copyright © 2016 neil robichaud. All rights reserved.
//

import UIKit

class ButtonViewController: UIViewController, UIAlertViewDelegate, BrickArrayProtocol {
    func brickAdded(player: Int) {
        if player == 1{
        p1Label.text = "\(brickArray.total)"
            if brickArray.total == gameNumber{
                brickArray.placeTopBun()
                winAlert(1)
            }
        }
        else{
        p2Label.text = "\(p2brickArray.total)"
            if p2brickArray.total == gameNumber{
                p2brickArray.placeTopBun()
                winAlert(2)
            }
        }
    }
    @IBOutlet weak var p2Label: UILabel!

    @IBOutlet weak var p1Label: UILabel!{
        didSet{
            p1Label.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        }
    }
    override func shouldAutorotate() -> Bool {
        return false;
    }
    
    @IBOutlet weak var p1GameNumLabel: UILabel!{
        didSet{
            p1GameNumLabel.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        }
    }
    @IBOutlet weak var gameNumLabel: UILabel!
    
    @IBOutlet weak var screenView: UIView!{
        didSet{
            UIGraphicsBeginImageContextWithOptions(screenView.frame.size, false, 0.0)
            let img = UIImage(named: "brick.jpg")
            
            screenView.backgroundColor = UIColor(patternImage: img!)

        }
    }
    var brickTypes: [String]?
    var decimalToggle: Bool?
    struct brickPatterns {
        static var grass = "grass.png"
        static var stripes = "stripes.jpg"
        
    }

    @IBOutlet weak var brickArray: BrickArray!{
        didSet{
            brickArray.delegate = self
            brickArray.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
            brickArray.brickTypes = brickTypes
            brickArray.playerNum = 1
            brickArray.DecimalShow = decimalToggle!
            brickArray.addGestureRecognizer(UITapGestureRecognizer(target: brickArray, action: #selector(BrickArray.tapPiece(_:))))
            
        }
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    
    @IBOutlet weak var p2brickArray: BrickArray!{
        didSet{
            p2brickArray.delegate = self
            p2brickArray.playerNum = 2
            p2brickArray.brickTypes = brickTypes
            p2brickArray.DecimalShow = decimalToggle!
            p2brickArray.addGestureRecognizer(UITapGestureRecognizer(target: p2brickArray, action: #selector(BrickArray.tapPiece(_:))))
        }
    }

    
    func sideReset(player: Int){
        if player == 2{
            p2brickArray.removeAllBricks()
            p2brickArray.createBricks(intToBinaryArray(gameNumber!))
        }
        else if player == 1{
            brickArray.removeAllBricks()
            brickArray.createBricks(intToBinaryArray(gameNumber!))
        }
        
        
    }
    
    var inGame: Bool = false
    
    var gameNumber: Int?{
        didSet{
            if gameNumber != nil{
                gameNumLabel.text = "\(gameNumber!)"
                p1GameNumLabel.text = "\(gameNumber!)"
            }
        }
    }
    func winAlert(player: Int){
        let victoryAlert = UIAlertController(title: "Congratulations", message: "Player \(player) wins!", preferredStyle:UIAlertControllerStyle.Alert)
        victoryAlert.addAction(UIAlertAction(title: "Menu", style: UIAlertActionStyle.Default){
            (alert: UIAlertAction!) in
            weak var weakself = self
            weakself!.performSegueWithIdentifier("Menu", sender: weakself)
            })
        victoryAlert.addAction(UIAlertAction(title: "Play Again", style: UIAlertActionStyle.Default ) {
            (alert : UIAlertAction!) in
            weak var weakself = self
            weakself!.reset()
            }
        )
        self.presentViewController(victoryAlert, animated: false, completion: {[weak self] in self!.inGame = false})
        
    }
    
    
    func reset(){
        p2brickArray.removeTopBun()
        brickArray.removeTopBun()
        p2brickArray.removeAllBricks()
        brickArray.removeAllBricks()
        p1Label.text = "0"
        p2Label.text = "0"
        inGame = false
        gameNumber = nil
    }
    
    
    @IBAction func startButton(sender: UIButton) {
        reset()
        inGame = true
        gameNumber = Int(arc4random_uniform(63)) + 1
        let config = intToBinaryArray(gameNumber!)
        brickArray.model = config
        p2brickArray.model = config
    }
    
    
    
    func intToBinaryArray(num: Int)->[Int]{
        var array = Array<Int>()
        var int = num
        while int > 0{
            let exp = Int(floor( log2(Double(int)) ))
            array.insert(exp, atIndex: 0)
            int = int - Int(pow(2,Double(exp)))
            //print(exp)
        }
        return array
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            self.navigationController?.navigationBarHidden = false
        
            
    }
    
}
