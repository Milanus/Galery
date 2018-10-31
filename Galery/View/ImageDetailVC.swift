//
//  ImageDetailVC.swift
//  Galery
//
//  Created by Milan Schon on 31/10/2018.
//  Copyright © 2018 Milan Schon. All rights reserved.
//

import UIKit

class ImageDetailVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    fileprivate var viewModel:ImageViewModel!
    var items:[String]!
    var position:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ImageViewModel()
        self.loadImage(url: items[position])
        self.view.backgroundColor = UIColor.black
        self.addSwipeRecognizer()
        // Do any additional setup after loading the view.
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == .right {
            print("right")
           self.swipe(direction: .right)
        }
        else if gesture.direction == .left {
                print("left")
            self.swipe(direction: .left)
        }
    }
    
    @IBAction func shareAction(_ sender: Any) {
        
    }
  
    @IBAction func doneAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func loadImage(url:String) {
        self.viewModel.populate(url: url) { (model, error) in
            guard error == nil else {
                return
            }
            if let image = model.image {
                self.imageView.image = image
            }
        }
    }
    fileprivate func addSwipeRecognizer () {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    fileprivate func swipe (direction:SwipperDirection) {
        let newposition = direction == .right ? (position - 1) : (position + 1)
        if newposition < items.count && newposition >= 0 {
            self.loadImagefromSwipe(newPosition: newposition)
        }
    }
    fileprivate func loadImagefromSwipe(newPosition:Int) {
        self.loadImage(url: items[newPosition])
        self.position = newPosition
    }
    
    enum SwipperDirection {
        case right
        case left
    }
    
    @IBAction func deInit(_ sender: Any) {
         performSegue(withIdentifier: "deinitSegue", sender: nil)
    }

    override func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
        
    }
}
