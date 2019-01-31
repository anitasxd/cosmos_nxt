//
//  Bounce.swift
//  NXT
//
//  Created by Student on 7/23/17.
//  Copyright © 2017 Moses Oh. All rights reserved.
//

import UIKit

class Bounce: UIButton {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.transform = CGAffineTransform(scaleX: 1.1, y:1.1)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 3, options: .allowUserInteraction, animations: {
            self.transform = CGAffineTransform.identity
            }, completion: nil)
        super.touchesBegan(touches, with: event)
    
    }
    
    
}
