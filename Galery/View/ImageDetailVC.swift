//
//  ImageDetailVC.swift
//  Galery
//
//  Created by Milan Schon on 31/10/2018.
//  Copyright © 2018 Milan Schon. All rights reserved.
//

import UIKit

class ImageDetailVC: UIViewController, UIScrollViewDelegate{
    
    @IBOutlet weak var imageView: UIImageView!
    fileprivate var viewModel:ImageViewModel!
    var items:[String]!
    var position:Int!
    @IBOutlet weak var scrollview: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // viewmodel created
        viewModel = ImageViewModel(onImageLoaded: {[weak self] (model, error) in
            guard error == nil else {
                return
            }
            if let image = model.image {
                self?.imageView.image = image
            }
        })
        // adding swipe gesture and zoom
        self.loadImage(url: items[position])
        self.view.backgroundColor = UIColor.black
        self.addSwipeRecognizer()
        self.scrollZoomInSettup()
    }
    // handling swipe gesture
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == .right {
           self.swipe(direction: .right)
        }
        else if gesture.direction == .left {
            self.swipe(direction: .left)
        }
    }
    
    @IBAction func shareAction(_ sender: Any) {
        // sharing image
        shareImage()
    }
  
    @IBAction func doneAction(_ sender: Any) {

        self.dismiss(animated: true, completion: nil)
    }
    // loading image
    fileprivate func loadImage(url:String) {
        self.viewModel.populate(url: url)
    }
    //init swipe gestures
    fileprivate func addSwipeRecognizer () {
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
    }
    //all swipe magic done here
    // handling swipe events
    fileprivate func swipe (direction:SwipperDirection) {
        let newposition = direction == .right ? (position - 1) : (position + 1)
        if newposition < items.count && newposition >= 0 {
            self.loadImagefromSwipe(newPosition: newposition)
        }
    }
    // loading images from gesture
    fileprivate func loadImagefromSwipe(newPosition:Int) {
        self.loadImage(url: items[newPosition])
        self.position = newPosition
    }
    // some enum
    enum SwipperDirection {
        case right
        case left
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
    // max zoom
    func scrollZoomInSettup (){
        self.scrollview.delegate = self
        self.scrollview.maximumZoomScale = 4.0
        self.scrollview.minimumZoomScale = 1.0
        self.imageView.isUserInteractionEnabled = true
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        
    }
    // sharing image 
    func shareImage () {
        if let image = viewModel.getImage() {
            let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            activityVC.popoverPresentationController?.sourceRect = .zero
            self.present(activityVC, animated: true, completion: nil)
            
        }
    }
    

}
