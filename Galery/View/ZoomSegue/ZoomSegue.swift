//
//  ZoomSegue.swift
//  Galery
//
//  Created by Milan Schon on 31/10/2018.
//  Copyright © 2018 Milan Schon. All rights reserved.
//

import UIKit

class ZoomSegue: UIStoryboardSegue {
    override func perform() {
        scale()
    }
    func scale () {
        let toVC = self.destination
        let fromVC = self.source
        
        let containerView = fromVC.view.superview
        let originCenter = fromVC.view.center
        
        toVC.view.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        toVC.view.center = originCenter
        
        containerView?.addSubview(toVC.view)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            toVC.view.transform = CGAffineTransform.identity
        }) { (suces) in
            fromVC.present(toVC, animated: false, completion: nil)
        }
    }
}

class UnwindScaleSegue:UIStoryboardSegue {
    override func perform() {
        scale()
    }
    func scale () {
        let toVC = self.destination
        let fromVC = self.source
        
        fromVC.view.superview?.insertSubview(toVC.view, at: 0)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            fromVC.view.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        }) { (suces) in
            fromVC.dismiss(animated: false, completion: nil)
        }
    }
}
