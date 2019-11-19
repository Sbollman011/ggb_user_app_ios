//
//  LocationPopView.swift
//  GreenGrubBox
//
//  Created by Ankit on 2/2/18.
//  Copyright © 2018 Ankit. All rights reserved.
//

import UIKit

class LocationPopView: UIView {
    
    @IBOutlet weak var constrain_viewRating: NSLayoutConstraint!
    @IBOutlet weak var btn_Web: UIButton!
    @IBOutlet weak var btn_Yelp: UIButton!
    @IBOutlet weak var lbl_yelp: UILabel!
    @IBOutlet weak var lbl_web: UILabel!
    @IBOutlet weak var img_yelp: UIImageView!
    @IBOutlet weak var img_web: UIImageView!
    @IBOutlet weak var btnImgMain: UIButton!
    @IBOutlet weak var popUpview: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgVendor: UIImageView!
    @IBOutlet weak var btncross: UIButton!
    @IBOutlet weak var lblMenu: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var view_rating: UIView!
    @IBOutlet weak var Text_Details: UITextView!
    
    //mark ratting
    @IBOutlet weak var img_star_one: UIImageView!
    @IBOutlet weak var img_star_two: UIImageView!
    @IBOutlet weak var img_star_thre: UIImageView!
    @IBOutlet weak var img_star_four: UIImageView!
    @IBOutlet weak var img_star_five: UIImageView!
    @IBOutlet weak var view_main: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imgVendor.layer.cornerRadius = imgVendor.frame.height / 2
        imgVendor.layer.masksToBounds = true
        imgVendor.clipsToBounds = true
        imgVendor.layer.borderWidth = 1
        imgVendor.layer.borderColor = UIColor.white.cgColor
    }
    
    // MARK: - Dialog initialization
    override open func awakeFromNib() {
        super.awakeFromNib()
        
        // Setup payment card text field
        img_star_one.backgroundColor = UIColor.clear
        img_star_two.backgroundColor = UIColor.clear
        img_star_thre.backgroundColor = UIColor.clear
        img_star_four.backgroundColor = UIColor.clear
        img_star_five.backgroundColor = UIColor.clear
        
        img_star_one.image = UIImage(named: "star_a")
        img_star_two.image = UIImage(named: "star_a")
        img_star_thre.image = UIImage(named: "star_a")
        img_star_four.image = UIImage(named: "star_a")
        img_star_five.image = UIImage(named: "star_a")
        
        appDelegate.BoardercolorOfView(sender: img_star_one, color: UIColor.clear, borderWidth: 0, cornerRadius: 5)
        appDelegate.BoardercolorOfView(sender: img_star_two, color: UIColor.clear, borderWidth: 0, cornerRadius: 5)
        appDelegate.BoardercolorOfView(sender: img_star_thre, color: UIColor.clear, borderWidth: 0, cornerRadius: 5)
        appDelegate.BoardercolorOfView(sender: img_star_four, color: UIColor.clear, borderWidth: 0, cornerRadius: 5)
        appDelegate.BoardercolorOfView(sender: img_star_five, color: UIColor.clear, borderWidth: 0, cornerRadius: 5)
        
        view_main.layer.cornerRadius = 5
        view_main.layer.masksToBounds = true
        view_main.layer.borderWidth = 1
        view_main.layer.borderColor = UIColor.white.cgColor
        
        imgVendor.layer.cornerRadius = imgVendor.frame.height / 2
        imgVendor.layer.masksToBounds = true
        imgVendor.clipsToBounds = true 
        imgVendor.layer.borderWidth = 1
        imgVendor.layer.borderColor = UIColor.white.cgColor
        
        fontSetup()
    }
    
    func fontSetup(){
        lbl_yelp.font = Font2Bold12
        lbl_web.font = Font2Bold12
        lblName.font = Font2Bold19
        
        lblMenu.font = FontNormal12
        lblAddress.font = FontBold14
        Text_Details.font = FontNormal12
    }
    
    func instanceFromNib() -> UIView {
        return UINib(nibName: "LocationPopViewXib", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! LocationPopView
    }
    
    @IBAction func ActionOnbtnCross(_ sender: UIButton) {
        // self.removeFromSuperview()
        //self.fadeIn()
    }
    
    @IBAction func ActionOnbtnYelp(_ sender: UIButton) {
        print("Yelp")
    }
    
    @IBAction func ActionOnbtnWeb(_ sender: UIButton) {
        print("web")
    }
    
    func HideYelp(){
        img_yelp.isHidden = true
        lbl_yelp.isHidden = true
        btn_Yelp.isHidden  = true
        constrain_viewRating.constant = 0
    }
    
    func HideWeb(){
        img_web.isHidden = true
        lbl_web.isHidden = true
        btn_Web.isHidden  = true
    }
    
    func ShowYelp(){
        img_yelp.isHidden = false
        lbl_yelp.isHidden = false
        btn_Yelp.isHidden  = false
        constrain_viewRating.constant = 30
    }
    
    func ShowWeb(){
        img_web.isHidden = false
        lbl_web.isHidden = false
        btn_Web.isHidden  = false
    }
    
    func SetRating(rating: Float){
        
        img_star_one.image = UIImage(named: "0_star_full")
        img_star_two.image = UIImage(named: "0_star_full")
        img_star_thre.image = UIImage(named: "0_star_full")
        img_star_four.image = UIImage(named: "0_star_full")
        img_star_five.image = UIImage(named: "0_star_full")
        
        switch rating {
        case 0.0:
            img_star_one.image = UIImage(named: "0_star_full")
            img_star_two.image = UIImage(named: "0_star_full")
            img_star_thre.image = UIImage(named: "0_star_full")
            img_star_four.image = UIImage(named: "0_star_full")
            img_star_five.image = UIImage(named: "0_star_full")
            break
        case 0.5:
            img_star_one.image = UIImage(named: "1_star_hulf")
            img_star_two.image = UIImage(named: "0_star_full")
            img_star_thre.image = UIImage(named: "0_star_full")
            img_star_four.image = UIImage(named: "0_star_full")
            img_star_five.image = UIImage(named: "0_star_full")
            break
        case 1.0:
            img_star_one.image = UIImage(named: "1_star_full")
            img_star_two.image = UIImage(named: "0_star_full")
            img_star_thre.image = UIImage(named: "0_star_full")
            img_star_four.image = UIImage(named: "0_star_full")
            img_star_five.image = UIImage(named: "0_star_full")
            break
        case 1.5:
            img_star_one.image = UIImage(named: "1_star_full")
            img_star_two.image = UIImage(named: "2_star_hulf")
            img_star_thre.image = UIImage(named: "0_star_full")
            img_star_four.image = UIImage(named: "0_star_full")
            img_star_five.image = UIImage(named: "0_star_full")
            break
        case 2.0:
            img_star_one.image = UIImage(named: "1_star_full")
            img_star_two.image = UIImage(named: "2_star_full")
            img_star_thre.image = UIImage(named: "0_star_full")
            img_star_four.image = UIImage(named: "0_star_full")
            img_star_five.image = UIImage(named: "0_star_full")
            break
        case 2.5:
            img_star_one.image = UIImage(named: "1_star_full")
            img_star_two.image = UIImage(named: "2_star_full")
            img_star_thre.image = UIImage(named: "3_star_hulf")
            img_star_four.image = UIImage(named: "0_star_full")
            img_star_five.image = UIImage(named: "0_star_full")
            break
        case 3.0:
            img_star_one.image = UIImage(named: "1_star_full")
            img_star_two.image = UIImage(named: "2_star_full")
            img_star_thre.image = UIImage(named: "3_star_full")
            img_star_four.image = UIImage(named: "0_star_full")
            img_star_five.image = UIImage(named: "0_star_full")
            break
        case 3.5:
            img_star_one.image = UIImage(named: "1_star_full")
            img_star_two.image = UIImage(named: "2_star_full")
            img_star_thre.image = UIImage(named: "3_star_full")
            img_star_four.image = UIImage(named: "4_star_hulf")
            img_star_five.image = UIImage(named: "0_star_full")
            break
        case 4.0:
            img_star_one.image = UIImage(named: "1_star_full")
            img_star_two.image = UIImage(named: "2_star_full")
            img_star_thre.image = UIImage(named: "3_star_full")
            img_star_four.image = UIImage(named: "4_star_full")
            img_star_five.image = UIImage(named: "0_star_full")
            break
        case 4.5:
            
            img_star_one.image = UIImage(named: "1_star_full")
            img_star_two.image = UIImage(named: "2_star_full")
            img_star_thre.image = UIImage(named: "3_star_full")
            img_star_four.image = UIImage(named: "4_star_full")
            img_star_five.image = UIImage(named: "5_star_hulf")
            break
        case 5.0:
            img_star_one.image = UIImage(named: "1_star_full")
            img_star_two.image = UIImage(named: "2_star_full")
            img_star_thre.image = UIImage(named: "3_star_full")
            img_star_four.image = UIImage(named: "4_star_full")
            img_star_five.image = UIImage(named: "5_star_full")
            break
        default:
            break
        }
    }
}
