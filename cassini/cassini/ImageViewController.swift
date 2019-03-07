//
//  ImageViewController.swift
//  cassini
//
//  Created by JiaShu Huang on 2019/3/7.
//  Copyright © 2019 JiaShu Huang. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    var imageURL:URL? {
        didSet{
            image = nil
            if view.window != nil { // when controller will be show, its view will be add to window
                fetchImage()
            }
        }
    }
    private func fetchImage(){
        if let url = imageURL,
            let imageData = try? Data(contentsOf: url){
            image = UIImage(data: imageData)
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet{
            scrollView.addSubview(imageView)
            scrollView.contentSize = imageView.frame.size
            scrollView.minimumZoomScale = 0.2
            scrollView.maximumZoomScale = 2.0
            scrollView.delegate = self
        }
    }
    fileprivate var imageView = UIImageView()
    private var image:UIImage? {
        get{
            return imageView.image
        }
        set{
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size // when image set, the scorllView may be nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageURL = DemoURL.demoImageURL // if it in tabController we do not want load view until it will appear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil {// when image is nil fetch the image
            fetchImage()
        }
    }
}

extension ImageViewController:UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
