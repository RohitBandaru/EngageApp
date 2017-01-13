//
//  SegueFromLeft.swift
//  EngageApp
//
//  Created by Grace Lam on 1/12/17.
//  Copyright © 2017 Huna Makia. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class SegueFromLeft: UIStoryboardSegue {
    
    override func perform() {
        
        // assign the source and destination views to local variables
        var secondVCView = self.source.view as UIView!
        var firstVCView = self.destination.view as UIView!
        
        let screenWidth = UIScreen.main.bounds.size.width
        
        let window = UIApplication.shared.keyWindow
        window?.insertSubview(firstVCView!, aboveSubview: secondVCView!)
        
        // animate the transition
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            firstVCView?.frame = (firstVCView?.frame.offsetBy(dx: screenWidth, dy: 0.0))!
            secondVCView?.frame = (secondVCView?.frame.offsetBy(dx: screenWidth, dy: 0.0))!
            
        }) { (Finished) -> Void in
            
            self.source.dismiss(animated: false, completion: nil)
        }
    }
    
}
