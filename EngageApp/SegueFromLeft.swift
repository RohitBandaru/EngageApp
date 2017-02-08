//
//  SegueFromLeft.swift
//  EngageApp
//
//  Created by Grace Lam on 1/19/17.
//  Copyright © 2017 Huna Makia. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class SegueFromLeft: UIStoryboardSegue {
    
    override func perform() {
        
        let firstClassView = self.source.view
        let secondClassView = self.destination.view
        
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        
        secondClassView?.frame = CGRect(x: -screenWidth, y: 0, width: screenWidth, height: screenHeight)
        
        if let window = UIApplication.shared.keyWindow {
            
            window.insertSubview(secondClassView!, aboveSubview: firstClassView!)
            
            UIView.animate(withDuration: 0.4, animations: { () -> Void in
                
                firstClassView?.frame = (firstClassView?.frame.offsetBy(dx: screenWidth, dy: 0))!
                secondClassView?.frame = ((secondClassView?.frame)?.offsetBy(dx: screenWidth, dy: 0))!
                
            }) {(Finished) -> Void in
                
                //self.source.navigationController?.pushViewController(self.destination, animated: false)
                self.source.present(self.destination, animated: false, completion: nil)
                
            }
            
        }
    }
    
}
