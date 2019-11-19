//
//  ImageCollectionCell.swift
//  GreenGrubBox
//
//  Created by dev2 on 2/9/18.
//  Copyright © 2018 Ankit. All rights reserved.
//

import UIKit

class ImageCollectionCell: UICollectionViewCell,UIScrollViewDelegate {

    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var img_picture: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        img_picture.image = UIImage(named: "popUp_default_user.png")
    }
    
    func SetDeleageOfscrolview(){
        
        let minScale : Float =  Float(scrollview.frame.size.width / img_picture.frame.size.width);
        scrollview.minimumZoomScale = CGFloat(minScale);
        scrollview.maximumZoomScale = 3.0;
        scrollview.contentSize = img_picture.frame.size;
        scrollview.delegate = self;
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>){
    }
    
    // any zoom scale changes
    func scrollViewDidZoom(_ scrollView: UIScrollView)
    {
        
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return img_picture
    }
    
    // called before the scroll view begins zooming its content
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?)
    {
        print("zooming begin",scrollView.zoomScale)
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat)
    {
        print("zooming  end",scrollView.zoomScale)
    }
}
