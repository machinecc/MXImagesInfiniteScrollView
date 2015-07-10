//
//  MXImagesInfiniteScrollView.swift
//  MXImagesInfiniteScrollView
//
//  Created by Xin on 15/7/9.
//  Copyright (c) 2015年 MX. All rights reserved.
//

import Foundation
import UIKit

public class MXImagesInfiniteScrollView: UIScrollView, UIScrollViewDelegate {
    
    /// MARK: Initialization methods.
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    /**
    Initialize a view with speficied frame.
    
    :param: frame   Speficied frame rectangle of the view, measured in points.
    */
    public func initializeWithFrame(frame: CGRect) {
        /// Get the size of specified frame
        width = frame.width
        height = frame.height
        
        /// Set some basic properties
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.pagingEnabled = true
        self.bounces = false
        self.delegate = self
        
        
        /// Create a page control, and add it as a subview of this view's superview
        let pageControlWidth: CGFloat = 38.0
        let pageControlHeight: CGFloat = 36.0
        pageControl = UIPageControl(frame: CGRectMake(frame.minX + (width - pageControlWidth) / 2.0, frame.maxY - pageControlHeight, pageControlWidth, pageControlHeight))
        pageControl?.pageIndicatorTintColor = UIColor.whiteColor()
        pageControl?.currentPageIndicatorTintColor = UIColor.purpleColor()
        self.superview?.addSubview(pageControl!)
    }
    
    
    
    
    /// MARK: Public getter / setter properties to provide neccessary information for UIPageControl.

    /// Number of pages to present in this view
    public private(set) var numPages: Int = 0 {
        didSet {
            pageControl?.numberOfPages = numPages
        }
    }
    
    /// Current page
    public private(set) var currentPage: Int = 0 {
        didSet {
            pageControl?.currentPage = currentPage
        }
    }
    
    
    /// Pagecontrol's pageIndicatorTintColor
    public var pageIndicatorTintColor: UIColor? {
        didSet {
            pageControl?.pageIndicatorTintColor = pageIndicatorTintColor
        }
    }
    
    /// Pagecontrol's currentPageIndicatorTintColor
    public var currentPageIndicatorTintColor: UIColor? {
        didSet {
            pageControl?.currentPageIndicatorTintColor = currentPageIndicatorTintColor
        }
    }

    
    
    
    
    /// MARK: Private properties.
    
    /// Width of the frame
    private var width: CGFloat = 0
    
    /// Height of the frame
    private var height: CGFloat = 0
    
    /// ImageViews as subviews in this view
    private var imageViews: [UIImageView] = []
    
    /// PageControl
    private var pageControl: UIPageControl?
    
    
    
    // MARK: Public interfaces to load various types of types into the view.

    /**
    Load images into this view using their names.
    
    :param: imageNames  Names of images.
    :returns:    false, if it is not successful, e.g., image not found.
    */
    public func loadImagesWithImageNames(imageNames: [String]) -> Bool{
        
        var images: [UIImage] = []
        
        for name in imageNames {
            if let image = UIImage(named: name) {
                images.append(image)
            }
            else {
                return false
            }
        }
        
        loadImages(images)
        
        return true
    }
    
    
    /**
    Load images into this view.
    The basic logic is as follows:
    
    - First, get the number of images `numPages`.
    - Second, insert the last image at index 0, and append the first image at the tail.
    - Third, create `numPages` + 2 sub imageviews.
    - Fourth, set the content offset to be width.
    
    :param: images  An array of UIImages.
    */
    public func loadImages(images: [UIImage]) {
        numPages = images.count
        
        if numPages == 0 {
            return
        }
        
        // Since images is immutable, we make a copy here.
        // Note that in Swift, arrays are value types.
        var imagesCopy = images

        imagesCopy.insert(images[numPages - 1], atIndex: 0)
        
        imagesCopy.append(images[0])
        
        self.contentSize = CGSizeMake(width * CGFloat(imagesCopy.count), height)

        // In each loop, increase horizontalOffset by width.
        var horizontalOffset: CGFloat = 0.0
        
        for image in imagesCopy {
            var imageView = UIImageView(frame: CGRectMake(horizontalOffset, 0, width, height))
            imageView.image = image
            imageView.contentMode = UIViewContentMode.ScaleToFill
            self.addSubview(imageView)
            imageViews.append(imageView)
            horizontalOffset += width
        }
        
        self.contentOffset = CGPointMake(width, 0)
    }
    
    
    /**
    Load images into this view from urlstrings.
    Similarly, the basic logic is as follows:
    
    - First, get the number of urls `numPages`.
    - Second, insert the last url at index 0, and append the first url at the tail.
    - Third, create `numPages` + 2 sub imageviews.
    - Fourth, set the content offset to be width.
    
    :param: images  An array of UIImages.
    */
    public func loadImagesFromURLStrings(urlStrings: [String]) {
        numPages = urlStrings.count
        
        if numPages == 0 {
            return
        }
        
        var urlStringsCopy = urlStrings
        
        urlStringsCopy.insert(urlStrings[numPages - 1], atIndex: 0)
        
        urlStringsCopy.append(urlStrings[0])
        
        self.contentSize = CGSizeMake(width * CGFloat(urlStringsCopy.count), height)
        
        var horizontalOffset: CGFloat = 0.0
        
        for urlString in urlStringsCopy {
            var imageView = UIImageView(frame: CGRectMake(horizontalOffset, 0, width, height))
            imageView.loadImageFromURLString(urlString, placeholderImage: nil, completion: nil)
            imageView.contentMode = UIViewContentMode.ScaleToFill
            self.addSubview(imageView)
            imageViews.append(imageView)
            horizontalOffset += width
        }

        self.contentOffset = CGPointMake(width, 0)
    }
    
    
    
    // MARK: Functions conforming to UIScrollviewDelegation protocol.
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        var currentIdx = Int(self.contentOffset.x / width)
        
        
        if currentIdx == 0 {
            currentIdx = numPages
            self.contentOffset = CGPointMake(width * CGFloat(numPages), 0)
        }
        else if currentIdx == numPages + 1 {
            currentIdx = 1
            self.contentOffset = CGPointMake(width * CGFloat(1), 0)
        }
        
        
        self.currentPage = currentIdx - 1
    }
}