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
    var imageName: String?{
        didSet{
            UIGraphicsBeginImageContextWithOptions(frame.size, false, 0.0)
            let img = UIImage(named: imageName!)
            img?.drawInRect(bounds)
            let newImg = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            backgroundImageView = UIImageView(image: newImg!)
        }
    }
    var textWithDecimal:String?{
        didSet{
            reloadLabel(true)
        }
    }
    var text: String?{
        didSet{
            reloadLabel(false)
        }
    }
    var backgroundImageView: UIImageView?{
        didSet{
            addSubview(backgroundImageView!)
        }
    }
    var originalMainBounds: CGRect?
    func redrawToSize(height: CGFloat, width: CGFloat){
        autoresizesSubviews = true

        let rect = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: width, height: height)
        bounds = rect
        label?.frame = rect
        reloadImage()
        bringSubviewToFront(label!)
        
    }
    func growify(){
        bounds = originalMainBounds!
        label?.frame = originalMainBounds!
        reloadImage()
        bringSubviewToFront(label!)

    }
    func reloadImage(){
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0.0)
        let img = UIImage(named: imageName!)
        img?.drawInRect(bounds)
        let newImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        backgroundImageView = UIImageView(image: newImg!)
    }
    
    func reloadLabel(withDecimal: Bool){
        if withDecimal{
            if textWithDecimal != nil{
                label = UILabel(frame: bounds)
                label!.text = textWithDecimal!
                if dark == true{
                    label?.textColor = UIColor.whiteColor()
                }
                else{
                    label!.textColor = UIColor.blackColor()
                }
                //label!.font = UIFont.boldSystemFontOfSize(14)
                label!.numberOfLines = 0;
                label!.minimumScaleFactor = 0.001;
                label!.adjustsFontSizeToFitWidth = true
                label!.textAlignment = .Center
                label!.lineBreakMode = .ByWordWrapping
                label!.numberOfLines = 0
                label!.shadowColor = UIColor.whiteColor()
                label!.autoresizingMask = UIViewAutoresizing.FlexibleHeight
                addSubview(label!)
            }
        }
        else{
            if text != nil{
                label = UILabel(frame: bounds)
                label!.text = text!
                if dark == true{
                    label?.textColor = UIColor.whiteColor()
                }
                else{
                    label!.textColor = UIColor.blackColor()
                }
                //label!.font = UIFont.boldSystemFontOfSize(14)
                label!.numberOfLines = 0;
                label!.minimumScaleFactor = 0.001;
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
    
    
    
}
