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
    var showingDec: Bool?
    var textWithDecimal:String?
    var text: String?
    
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
        label?.text = text
        bringSubviewToFront(label!)
        
    }
    func growify(){
        bounds = originalMainBounds!
        label?.frame = originalMainBounds!
        if showingDec!{
            label?.text = textWithDecimal
        }
        bringSubviewToFront(label!)

    }

    
    func loadLabel(){
        
        label = UILabel(frame: bounds) 
        
        if showingDec!{
            label!.text = textWithDecimal!

        }
        else{
            label!.text = text!
        }
                if dark == true{
                    label?.textColor = UIColor.whiteColor()
                }
                else{
                    label!.textColor = UIColor.blackColor()
                }
                label!.font = UIFont.boldSystemFontOfSize(18)
                label!.textAlignment = .Center
                label!.lineBreakMode = .ByWordWrapping
                label!.numberOfLines = 0
                addSubview(label!)
        


    }

    
    
}
