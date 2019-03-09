//
//  CassiniViewController.swift
//  cassini
//
//  Created by JiaShu Huang on 2019/3/9.
//  Copyright © 2019 JiaShu Huang. All rights reserved.
//

import UIKit

class CassiniViewController: UIViewController,UISplitViewControllerDelegate {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if let splitViewController = self.splitViewController {
            splitViewController.delegate = self
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let url = DemoURL.NASA[segue.identifier ?? ""] {
            if let imageVC = segue.destination.contents as? ImageViewController {
                imageVC.navigationItem.title = (sender as? UIButton)?.currentTitle
                imageVC.imageURL = url
            }
        }
    }
    //Return YES to prevent UIKit from applying its default behavior; return NO to request that UIKit
    // perform its default collapsing behavior.
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
    // detailViewController没有内容时，返回yes组织，有内容时返回NO使用默认行为
        if let imageVC = secondaryViewController.contents as? ImageViewController, imageVC.imageURL != nil {
            return false
        }else {
            return true
        }
    }
}

extension UIViewController {
    var contents:UIViewController {
        if let navi = self as? UINavigationController {
            return navi.visibleViewController ?? self
        }else {
            return self
        }
    }
}
