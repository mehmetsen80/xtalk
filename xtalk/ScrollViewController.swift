//
//  ScrollViewController.swift
//  xtalk
//
//  Created by Mehmet Sen on 2/26/16.
//  Copyright © 2016 Mehmet Sen. All rights reserved.
//

import UIKit

/*  source: https://github.com/Charles-Hsu/ScrollViewDemo
    Thank you Charles-Hsu!
*/
class ScrollViewController: UIViewController, UIScrollViewDelegate{
    
    
    var photos:[UIImage]! //photos are passed to show
    var pageImages:[UIImage] = [UIImage]() //page images
    var pageViews:[UIView?] = [UIView]() //page views

    var mainScrollView: UIScrollView!
    
    var btnBack: UIButton!
    
    var pageScrollViews:[UIScrollView?] = [UIScrollView]() //page scroll views
    var currentPageView: UIView! //current page
    var pageControl : UIPageControl = UIPageControl() //page control and its frame: CGRectMake(50, 300, 200, 50))
    let viewForZoomTag = 1 //zoom factor
    var mainScrollViewContentSize: CGSize! //main scroll view content size

    
    override func viewDidLoad() {
       
        
        mainScrollView = UIScrollView(frame: self.view.bounds) //create the main scroll view
        mainScrollView.pagingEnabled = true //enable paging
        mainScrollView.showsHorizontalScrollIndicator = false //no horizontal scroll indicator
        mainScrollView.showsVerticalScrollIndicator = false //no vertical scroll indicator
        
        pageScrollViews = [UIScrollView?](count: photos.count, repeatedValue: nil) //a total photo size array of scrollviews called as pages
        
        
        let innerScrollFrame = mainScrollView.bounds //inner scroll frames as main scrollview bounds
        
        mainScrollView.contentSize =
            CGSizeMake(innerScrollFrame.origin.x + innerScrollFrame.size.width,
                mainScrollView.bounds.size.height) //initial main scroll content size is always same height but width changes according to the origin place plus the width of the scroll frame, initial width is actually the device screen width with no photos yet
        
        print("main scroll view content size: \(mainScrollView.contentSize)")
        
        
        
        mainScrollView.backgroundColor = UIColor.blackColor()//main scroll view background color
        mainScrollView.delegate = self //scroll view delegate connects directly itself
        
        
        btnBack = UIButton()
        btnBack.backgroundColor = UIColor.blackColor()
        btnBack.setTitle("Back", forState: .Normal)
        btnBack.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        btnBack.frame = CGRectMake(10, 10, 50, 40)
        btnBack.addTarget(self, action: "back", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(mainScrollView)
        self.view.addSubview(btnBack)
        
        configScrollView()
        addPageControlOnScrollView()

    }

    override func viewWillAppear(animated: Bool) {
        loadVisiblePages()
    }
    
   
    
    func back(sender: AnyObject){
//        let fbFacePhotos: FacePhotosViewController = self.storyboard?.instantiateViewControllerWithIdentifier("fbPhotosView") as! FacePhotosViewController
//        self.presentViewController(fbFacePhotos, animated: true, completion: nil)
        self.performSegueWithIdentifier("unwindToFacePhotos", sender: self)
    }
   
    

    
    
    //config main scroll view
    func configScrollView() {
        
        self.mainScrollView.contentSize = CGSizeMake(self.mainScrollView.frame.width * CGFloat(photos.count),
            self.mainScrollView.frame.height) //full scroll content width is the total photos times its own frame width, height is always same
        mainScrollViewContentSize = mainScrollView.contentSize //let's keep the main scrollviewContent size
    }
    
    //add page control on scroll view
    func addPageControlOnScrollView() {
        
        //let's configure the page control
        self.pageControl.numberOfPages = photos.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.redColor()
        self.pageControl.pageIndicatorTintColor = UIColor.grayColor()
        self.pageControl.currentPageIndicatorTintColor = UIColor.greenColor()
        
        //add an event handler when page is changed
        pageControl.addTarget(self, action: Selector("changePage:"), forControlEvents: UIControlEvents.ValueChanged)
        
        
        self.pageControl.frame = CGRectMake(0, self.view.frame.maxY - 44, self.view.frame.width, 44)//place page Control to the bottom of view with same view width and height of 44
       
        
        //self.pageControl.backgroundColor = UIColor.yellowColor() //background is optional
        
        self.view.addSubview(pageControl) //finally add page control to the view
        
    }
    
    // MARK : TO CHANGE WHILE CLICKING ON PAGE CONTROL
    func changePage(sender: AnyObject) -> () {
        
        let x = CGFloat(pageControl.currentPage) * mainScrollView.frame.size.width
        mainScrollView.setContentOffset(CGPointMake(x, 0), animated: true)
        loadVisiblePages()
        currentPageView = pageScrollViews[pageControl.currentPage]
    }
    
    func getViewAtPage(page: Int) -> UIView! {

        
        let image = photos[page]
        
        //        print("\(__FUNCTION__) \(page) image?.size = \(image?.size)")
        
        let imageForZooming = UIImageView(image: image)
        //imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        
        var innerScrollFrame = mainScrollView.bounds
        
        if page < photos.count {
            innerScrollFrame.origin.x = innerScrollFrame.size.width * CGFloat(page)
        }
        
        imageForZooming.tag = viewForZoomTag
        
        let pageScrollView = UIScrollView(frame: innerScrollFrame)

        
        pageScrollView.contentSize = imageForZooming.bounds.size
        pageScrollView.delegate = self
        pageScrollView.showsVerticalScrollIndicator = false
        pageScrollView.showsHorizontalScrollIndicator = false
        pageScrollView.addSubview(imageForZooming)

        return pageScrollView
        
    }
    
    
    //zoom scale
    func setZoomScale(scrollView: UIScrollView) {
        
        let imageView = scrollView.viewWithTag(self.viewForZoomTag)
        let imageViewSize = imageView!.bounds.size
        let scrollViewSize = scrollView.bounds.size
        let widthScale = scrollViewSize.width / imageViewSize.width
        let heightScale = scrollViewSize.height / imageViewSize.height
        
        scrollView.minimumZoomScale = min(widthScale, heightScale)
        scrollView.zoomScale = scrollView.minimumZoomScale
    }
    
    
    func loadVisiblePages() {
        
        let currentPage = pageControl.currentPage
        let previousPage =  currentPage > 0 ? currentPage - 1 : 0
        let nextPage = currentPage + 1 > pageControl.numberOfPages ? currentPage : currentPage + 1
        
        //        print("\(previousPage)-\(currentPage)-\(nextPage)")
        
        
        for page in 0..<previousPage {
            purgePage(page)
        }
        
        for var page = nextPage + 1; page < pageControl.numberOfPages; page = page + 1 {
            purgePage(page)
        }
        
        for var page = previousPage; page <= nextPage; page++ {
            loadPage(page)
        }
        
    }
    
    
    
    func loadPage(page: Int) {
        
                print("\(__FUNCTION__) \(page)")
        
        if page < 0 || page >= pageControl.numberOfPages {
            
                        print("\(__FUNCTION__) \(page) abort.")
            
            return
        }
        
        // 1
        if let pageScrollView = pageScrollViews[page] {
            // Do nothing. The view is already loaded.
            
            //            print("\(__FUNCTION__) \(page) existed, call setZoomScale.")
            
            setZoomScale(pageScrollView)
            
        }
        else {

            let pageScrollView = getViewAtPage(page) as! UIScrollView
            setZoomScale(pageScrollView)
            mainScrollView.addSubview(pageScrollView)
            pageScrollViews[page] = pageScrollView
        }
        
    }
    
    //purge page
    func purgePage(page: Int) {
        
        if page < 0 || page >= pageScrollViews.count {
            return
        }
        
        //purge page now
        if let pageView = pageScrollViews[page] {
            pageView.removeFromSuperview()
            pageScrollViews[page] = nil
        }
        
    }
    
    
    func centerScrollViewContents(scrollView: UIScrollView) {
        
        //        print("\(__FUNCTION__)")
        //        print("\(__FUNCTION__):scrollView.frame=\(scrollView.frame)")
        
        let imageView = scrollView.viewWithTag(self.viewForZoomTag)
        let imageViewSize = imageView!.frame.size
        //        print("\(__FUNCTION__):imageViewSize=\(imageViewSize)")
        
        let scrollViewSize = scrollView.bounds.size
        //        print("\(__FUNCTION__):scrollViewSize=\(scrollViewSize)")
        
        //        print("\(__FUNCTION__):scrollView.contentSize=\(scrollView.contentSize)")
        //        print("\(__FUNCTION__):scrollView.zoomScale=\(scrollView.zoomScale)")
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ?
            (scrollViewSize.height - imageViewSize.height) / 2 : 0
        
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ?
            (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        
        scrollView.contentInset = UIEdgeInsets(
            top: verticalPadding,
            left: horizontalPadding,
            bottom: verticalPadding,
            right: horizontalPadding)
    }
    
    
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        //        print("\(__FUNCTION__)")
        centerScrollViewContents(scrollView)
    }
    
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return scrollView.viewWithTag(viewForZoomTag)
        
        
    }
    
    //    func scrollViewDidScroll(scrollView: UIScrollView) {
    //        print("\(__FUNCTION__)")
    //    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("\(__FUNCTION__)")
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        print("\(__FUNCTION__)")
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        print("\(__FUNCTION__)")
        //        loadVisiblePages()
        
        
        //        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        //        pageControl.currentPage = Int(pageNumber)
        //
        //        print("\(__FUNCTION__):pageControl.currentPage=\(pageControl.currentPage)")
        //
        //        loadVisiblePages()
        //        currentPageView = pageViews[pageControl.currentPage]
        //
    }
    
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        print("\(__FUNCTION__)")
        
        let targetOffset = targetContentOffset.memory.x
        print(" TargetOffset: \(targetOffset)")
        
        print(" pageControl.currentPage = \(pageControl.currentPage)")
        print(" scrollView.zoomScale = \(scrollView.zoomScale)")
        print(" scrollView.contentSize = \(scrollView.contentSize)")
        
        print(" scrollView.contentSize.height=\(scrollView.contentSize.height)")
        print(" mainScrollViewContentSize.height=\(mainScrollViewContentSize.height)")
        
        let zoomRatio = scrollView.contentSize.height / mainScrollViewContentSize.height
        
        print(" ratio=\(zoomRatio)")
        
        if zoomRatio == 1 {
            // mainScrollViewController
            
            print("\n mainScrollViewController")
            //        print(scrollView.contentSize.width / targetOffset)
            
            //        print("pageControl.numberOfPages=\(pageControl.numberOfPages)")
            //        print("pageControl.currentPage=\(pageControl.currentPage)")
            
            let mainScrollViewWidthPerPage = mainScrollViewContentSize.width / CGFloat(pageControl.numberOfPages)
            
            print(" mainScrollViewWidthPerPage = \(mainScrollViewWidthPerPage)")
            
            print(" zoomed mainScrollViewWidthPerPage = \(mainScrollViewWidthPerPage * zoomRatio)")
            
            
            let currentPage = targetOffset / (mainScrollViewWidthPerPage * zoomRatio)
            
            print(" currentPage=\(currentPage)")
            
            
            pageControl.currentPage = Int(currentPage)
            
            loadVisiblePages()
            
            
            //        if velocity.x < 0 {
            //            scrollDirection = -1 //scrolling left
            //        } else {
            //            scrollDirection = 1 //scrolling right
            //        }
            
            
        }
        else {
            // pageScorllViewController
            
            print("\n pageScorllViewController")
            
            let mainScrollViewWidthPerPage = mainScrollViewContentSize.width / CGFloat(pageControl.numberOfPages)
            
            print(" mainScrollViewWidthPerPage = \(mainScrollViewWidthPerPage)")
            
            print(" zoomed mainScrollViewWidthPerPage = \(mainScrollViewWidthPerPage * zoomRatio)")
            
            
            let currentPage = targetOffset / (mainScrollViewWidthPerPage * zoomRatio)
            
            print(" currentPage=\(currentPage)")
            
            
            //            pageControl.currentPage = Int(currentPage)
            //            
            //            loadVisiblePages()
            
        }
        
        
        
        
    }

    
}
