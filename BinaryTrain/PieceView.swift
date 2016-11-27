//
//  PieceView.swift
//  BinaryTrain
//
//  Created by neil robichaud on 2016-09-04.
//  Copyright © 2016 neil robichaud. All rights reserved.
//

import UIKit

class PieceView: UIView{
    var selected = false
    var value: Int?
    var dx: CGFloat?
    var dy: CGFloat?
    var startingCenterPoint: CGPoint?
    var label: UILabel?
    var dark = false
    var text: String?{
        didSet{
            if text != nil{
                label = UILabel(frame: bounds)
                label!.text = text!
                if dark == true{
                    label?.textColor = UIColor.whiteColor()
                }
                else{
                label!.textColor = UIColor.blackColor()
                }
                label!.font = UIFont.boldSystemFontOfSize(14)
                label!.adjustsFontSizeToFitWidth = true
                label!.textAlignment = .Center
                label!.lineBreakMode = .ByWordWrapping
                label!.numberOfLines = 0
                label!.shadowColor = UIColor.whiteColor()
                label!.autoresizingMask = UIViewAutoresizing.FlexibleHeight
                addSubview(label!)
                
            }
        }
    }
    var backgroundImageView: UIImageView?{
        didSet{
            backgroundImageView?.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
            addSubview(backgroundImageView!)
            
        }
    }
    var originalMainBounds: CGRect?
    func redrawToSize(height: CGFloat, width: CGFloat){
        autoresizesSubviews = true

//        if value < 8{
//            adjustedWidth += 6
//        }
        let rect = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: width, height: height)
        bounds = rect
        label?.frame = rect
        
        
        
    }
    func growify(){
        bounds = originalMainBounds!
        label?.frame = originalMainBounds!
    }
    
    
    
}
