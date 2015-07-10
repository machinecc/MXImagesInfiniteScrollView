//
//  MXImagesInfiniteScrollViewDemoController.swift
//  MXImagesInfiniteScrollView
//
//  Created by Xin on 15/7/9.
//  Copyright (c) 2015年 MX. All rights reserved.
//

import Foundation
import UIKit

class MXImagesInfiniteScrollViewDemoController : UIViewController {
    
    @IBOutlet weak var banner: MXImagesInfiniteScrollView!
    
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        banner.initializeWithFrame(CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        
        
        
        /// Test 1
        /// var imageNames : [String] = ["img0", "img1", "img2", "img3", "img4"]
        /// banner.loadImagesWithImageNames(imageNames)
        
        
        /// Test 2
        var imageUrls: [String] = ["http://pic2.zhimg.com/e6b96600653ee664e632987ece1ba1b9_b.jpg", "http://pic4.zhimg.com/fd359aaac9fbc8f0bbed3e269d1c3a17_b.jpg", "http://pic3.zhimg.com/8032189b4f95beb233f20a9585a07b72_b.jpg"]
        banner.loadImagesFromURLStrings(imageUrls)
    }
    
    
    
    
}