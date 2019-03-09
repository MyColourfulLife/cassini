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
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private func fetchImage(){
        if let url = imageURL{
            // 操作可能很耗时，用户可能不等到结果就返回了，等block回来时，self可能已经不存在了。
            // 用户可能更改了image的赋值，如果图片地址发生了改变，用户已经不关心原有的地址了
            // 提醒用户有操作正在进行
            spinner.startAnimating()
            // 不论何时给图片赋值，只要给图片赋值了就停止
            DispatchQueue.global(qos: .userInitiated).async {[weak self] in
                if let imageData = try? Data(contentsOf: url),self?.imageURL == url{
                    DispatchQueue.main.async {
                        self?.image = UIImage(data: imageData)
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet{
            scrollView.addSubview(imageView)
            scrollView.contentSize = imageView.frame.size
            scrollView.minimumZoomScale = 0.02
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
            spinner?.stopAnimating()// 在prepare时，outlet都没有，spinner也可能没有被赋值
        }
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
