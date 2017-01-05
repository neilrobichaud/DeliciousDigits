//
//  BrickArray.swift
//  BinaryTrain
//
//  Created by neil robichaud on 2016-09-07.
//  Copyright © 2016 neil robichaud. All rights reserved.
//

import UIKit
protocol BrickArrayProtocol {
    func brickAdded(player: Int)
}
class BrickArray: UIView {
    var delegate: BrickArrayProtocol?
    var array = [PieceView]()
    var playerNum : Int?
    func removeAllBricks(){
        for brick in array{
            brick.removeFromSuperview()
        }
        total = 0
        lastBrick.removeAll()
        array.removeAll()
    }
    
    var model: [Int]?{
        didSet{
            createBricks(model!)
        }
        willSet{
            removeAllBricks()
        }
    }
    
    var highestExp = 6  //is actually the highest exp + 1
    

    var shelfWidth: CGFloat{
        return (bounds.size.width-spacing*4)/4
    }
    var bunHeight: CGFloat{
        return shelfHeight/2
    }
    var shelfHeight: CGFloat{
        return bounds.size.height/20
    }
    var unitHeight: CGFloat{
        return (bounds.size.height-shelfHeight*2 - bunHeight*2)/CGFloat(pow(2,Double(highestExp+1)))
    }

    var darkBricks = ["raspberry.png","pebble.png","pinecone.png","cactus.png","lettuce.png"]
    
    //todo add size to bricks, move position to bottom of array,
    let defaults = NSUserDefaults.standardUserDefaults()
    var brickTypes: [String]?
    var DecimalShow: Bool?
    let spacing = CGFloat(3)
    var width: CGFloat?
    
    func createBricks(model: [Int]){
        brickTypes = defaults.stringArrayForKey("selectedRows")     //get selected bricktypes from userdefaults
        if brickTypes == nil || brickTypes?.count == 0{
            brickTypes = ["cheese.png"]                             //default to salami
        }

        width = shelfWidth
        var x:CGFloat = 0
        var y:CGFloat = bounds.maxY - shelfHeight * 2 - spacing * 2  //top left of topleft brick
        let brickOptions = [0,1,2,3,4,5]
        var secondRow = false                                       //flag to know whether currently drawing second row
        for j in brickOptions{
            if j >= 4 && !secondRow{                                //after 4 bricks, reset x to left and move y down to second row
                secondRow = true
                x = 0 + shelfWidth
                y += shelfHeight + spacing
            }
            let rect = CGRect(x: x, y: y, width: width!, height: shelfHeight)
            let view = PieceView(frame: rect)                           //create pieceView from rect
           
            view.value = Int(pow(2,Double(j)))                          //set the value to 2^j
            
            let index = arc4random_uniform(UInt32(brickTypes!.count))
            let imgName = brickTypes![Int(index)]
            if darkBricks.contains(imgName){                            //check if brick is dark
                view.dark = true
            }
            let newImg = UIImage(named: imgName)
            view.backgroundColor = UIColor(patternImage: newImg!)

            view.layer.masksToBounds = true
            view.originalMainBounds = view.bounds
            view.startingCenterPoint = view.center
            
            view.showingDec = DecimalShow   //sets whether the piece shows the decimal value when expanded
            view.textWithDecimal = "1" + String(count: j, repeatedValue: Character("0")) + "\n\(view.value!)"
            view.text = "1" + String(count: j, repeatedValue: Character("0"))
            view.loadLabel()
            
            addSubview(view)
            array.append(view)
            x += width! + 4
        }
        topOfStack = CGPoint(x:bounds.midX, y: bounds.maxY - shelfHeight * 2 - bunHeight - spacing*3)
        let bottomBunRect = CGRect(x: 0, y: bounds.maxY - shelfHeight * 2 - bunHeight - spacing*3, width: bounds.width, height: bunHeight)
        let bottomBunView = UIView(frame: bottomBunRect)
        UIGraphicsBeginImageContextWithOptions(bottomBunView.frame.size, false, 0.0)
        let img = UIImage(named: "bottomBun.png")
        
        img?.drawInRect(bottomBunView.bounds)
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        bottomBunView.backgroundColor = UIColor(patternImage: newImg!)
        addSubview(bottomBunView)
    }
    
    var total = 0
    var lastBrick =  [PieceView]()

    var animating = 0         // a stack that keeps track of the number of views animating so that you can't return a brick until all bricks are sent
    var topOfStack: CGPoint?         // center of  bottom block
    var topleftOfStack: CGPoint?
    func tapPiece(recognizer: UITapGestureRecognizer){
        
        let gesturePoint = recognizer.locationInView(self)
        let itemGrabbed = self.hitTest(gesturePoint, withEvent: nil)
        if let pieceGrabbed = itemGrabbed as? PieceView{
            switch recognizer.state{
            case .Ended:
                if !pieceGrabbed.selected{
                    animating += 1
                    pieceGrabbed.selected = true
                    let bs = CGFloat(pieceGrabbed.value!) * unitHeight * 2


                    pieceGrabbed.dx = topOfStack!.x - (pieceGrabbed.center.x)
                    pieceGrabbed.dy = topOfStack!.y - (pieceGrabbed.center.y + bs/2)


                    
                    let identity = CATransform3DIdentity
                    let translate = CGAffineTransformMakeTranslation(pieceGrabbed.dx!, pieceGrabbed.dy!)
                    let rotationAndPerspectiveTransform = CATransform3DRotate(identity, CGFloat(M_PI), 0.0, 1.0, 0.0)
                    let translateCA = CATransform3DMakeAffineTransform(translate)
                    let full = CATransform3DConcat(rotationAndPerspectiveTransform , translateCA)
                    
                    UIView.animateWithDuration(0.8,
                                               delay: 0,
                                               options: [UIViewAnimationOptions.CurveEaseOut],
                                               animations: {
                                                pieceGrabbed.label?.hidden = true
                                                
                                                pieceGrabbed.layer.transform = full
                                                UIView.animateWithDuration(0.3,
                                                    delay: 0,
                                                    options: UIViewAnimationOptions.CurveLinear,
                                                    animations: {
                                                        pieceGrabbed.redrawToSize(bs, width: self.bounds.width)

                                                    },
                                                    completion: {finished in
                                                        if finished{
                                                            pieceGrabbed.label?.hidden = false
                                                            
                                                        }
                                                })
                        },
                                               completion: { finished in
                                                if finished{
                                                    weak var weakSelf = self
                                                    weakSelf!.total += pieceGrabbed.value!
                                                    weakSelf!.lastBrick.append(pieceGrabbed)
                                                    weakSelf!.delegate?.brickAdded(weakSelf!.playerNum!)
                                                    
                                                    pieceGrabbed.layer.transform = translateCA
                                                    weakSelf!.animating-=1
                                                }
                    })
                    topOfStack!.y -= pieceGrabbed.bounds.height
                }
                else if animating == 0{
                    returnBrick(pieceGrabbed)
                }
            default:
                break
            }
        }
        
    }

    func returnBrick(brick: PieceView){
        let dx = -brick.dx!
        let dy = -brick.dy!
        let translation = CATransform3DMakeAffineTransform( CGAffineTransformTranslate(brick.transform, dx, dy))
        total -= brick.value!
        
        
        topOfStack!.y += brick.bounds.height
        UIView.animateWithDuration(0.3,
                                   delay: 0,
                                   options: [UIViewAnimationOptions.CurveEaseOut],
                                   animations: {
                                    weak var weakSelf = self
                                    brick.layer.transform = translation
                                    brick.growify()
                                    //brick.layer.cornerRadius = weakSelf!.shelfHeight/2
            },
                                   completion: { finished in
                                    if finished{
                                        weak var weakSelf = self
                                        brick.selected = false
                                        weakSelf!.delegate?.brickAdded(weakSelf!.playerNum!)
                                    }
        })
        var index = 0
        for b in lastBrick{
            if b != brick{
                index += 1
            }
            else{
                index += 1
                break
                
            }
            
        }
        for i in index..<lastBrick.count{
            moveDownBrick(lastBrick[i],originallyReturnedBrick: brick)
        }
        lastBrick.removeAtIndex(index-1)
        
    }
    func moveDownBrick(brick: PieceView, originallyReturnedBrick: PieceView){
        let dy = CGFloat(originallyReturnedBrick.value!) * unitHeight * 2

        let dx = CGFloat(0)

        brick.dy! += dy                             //adjust bricks stored position in relation to it's home position
        brick.dx! += dx
        let translation = CGAffineTransformTranslate(brick.transform, dx, dy)
        UIView.animateWithDuration(0.3,
                                   delay: 0,
                                   options: [UIViewAnimationOptions.CurveEaseOut],
                                   animations: {
                                    brick.transform = translation
                                    
            },
                                   completion: { finished in
                                    if finished{
                                    }
        })
    }
    
    var topBunView: UIView?
    func placeTopBun(){
        let bunView = UIView(frame: (CGRect(x: bounds.minX, y:topOfStack!.y - bunHeight , width: bounds.width, height: bunHeight)))
        UIGraphicsBeginImageContextWithOptions(bunView.frame.size, false, 0.0)
        let img = UIImage(named: "topBun.png")
        
        img?.drawInRect(bunView.bounds)
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        bunView.backgroundColor = UIColor(patternImage: newImg!)
        addSubview(bunView)
        topBunView = bunView
    }
    func removeTopBun(){
        if topBunView != nil{
            topBunView!.removeFromSuperview()
        }
    }
    
    
    
    
    
    
    
    
    
    
}
