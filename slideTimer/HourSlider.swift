//
//  HourSlider.swift
//  slideTimer
//
//  Created by LARRY COMBS on 2/17/18.
//  Copyright © 2018 LARRY COMBS. All rights reserved.
//

import UIKit

@IBDesignable
class HourSlider: UISlider {

    @IBInspectable var hourThumbImage: UIImage? {
        didSet {
            setThumbImage(hourThumbImage, for: .normal)
            
        }
        
    }
    
}
