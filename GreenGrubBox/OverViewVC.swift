//
//  ViewController.swift
//  GreenGrubBox
//
//  Created by Ankit on 1/29/18.
//  Copyright © 2018 Ankit. All rights reserved.
//        let col1 = UIColor(red: 139, green: 212, blue: 76, alpha: 0.25)


import UIKit
import Alamofire
class OverViewVC: UIViewController,UIScrollViewDelegate {
    
    //MARK: Globale Variables
    let carOff: UIImage = UIImage(named: "off")!
    let carOn: UIImage = UIImage(named: "on")!
    var pageTimer: Timer!
    var changFlag:Int = 1
    
    //MARK:IB-OUTLETS
    @IBOutlet weak var img_bg: UIImageView!
    @IBOutlet weak var logoScroller: UIScrollView!
    @IBOutlet weak var pageScroller: UIScrollView!
    
    @IBOutlet weak var pageIndicatore: UIPageControl!
    
    @IBOutlet weak var imgForIndicatorOne: UIImageView!
    @IBOutlet weak var imgForIndicatorTwo: UIImageView!
    @IBOutlet weak var imgForIndicatorTree: UIImageView!
    @IBOutlet weak var imgForIndicatorFour: UIImageView!
    
    @IBOutlet weak var lbl_instruction: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var btnSignup: UIButton!
    
    let lbl: UILabel = UILabel()
    var lblString : NSString = NSString()
    var Screens: [String] = ["bg-1", "bg-2", "bg-3","bg-4"]
    var Screens_logo: [String] = ["white_circle-1", "white_circle-2", "white_circle-3","white_circle-4"]
    var frame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    var frame_logo: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    var Toptext : [String] = ["Enjoy takeout meals with \n Green GrubBox","Eat green from your \n favorite places ","When done","Sign up today & Start Grubbing Green."]
    
    var middletext : [String] = ["The most sustainable and environmentally friendly way to enjoy takeout food.","Find food joints that offer GGB in the area.  Ask to have your meal served in a GrubBox then scan the boxes QR code.  Show the cashier your confirmation.","Use the app to find one of our convenient GrubGone Stations to deposit your GrubBox into and we'll take care of the rest.","Log into your existing account or become a Green GrubBox member today and  to \"stop the abuse of single use.\""]
    
    var pageControlBeingUsed: Bool = Bool()
    
    //MARK: Lifcycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        btnSignup.layer.cornerRadius = 4
        btnSignup.layer.masksToBounds = true
        btnSignup.layer.borderWidth = 0
        btnSignup.layer.borderColor = UIColor.clear.cgColor
        appDelegate.ShowShadow(sender: btnSignup, color: UIColor.black, shadowRadius: 4.0, shadowOpacity:0.1, shadowOffset: CGSize(width: 10.0, height: 10.0))
        fontsetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //login_sevice()
    }
    
    //MARK: Font Setup
    func fontsetup(){
        lbl_instruction.font = Font2Bold13
        btnLogin.setTitle("LOG IN", for: .normal)
        btnLogin.titleLabel?.font = FontBold16
        
        btnSignup.setTitle("SIGN UP", for: .normal)
        btnSignup.titleLabel?.font = FontBold16
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        LogoScrollerSetup()
        MiddleScroller()
    }
    
    //MARK: SCROLL TO MIDDILE
    func MiddleScroller(){
        //      self.pageScroller.frame = self.view.bounds
        pageScroller.contentSize.height = pageScroller.frame.height
        pageScroller.isScrollEnabled = true
        pageScroller.isDirectionalLockEnabled = true
        
        pageScroller.delegate = self
        for index in 0 ..< Screens.count {
            frame.origin.x = pageScroller.frame.width * CGFloat(index)
            frame.origin.y = 0
            
            frame.size = CGSize(width: self.view.frame.width, height: pageScroller.frame.height)
            self.pageScroller.isPagingEnabled = true
            let vforlabel : UIView = UIView.init(frame: frame)
            vforlabel.backgroundColor = UIColor.clear
            let lable_One : UILabel = UILabel(frame: CGRect(x:5, y: 0, width: frame.width - 10, height: frame.height/3))
            let lable_Two : UILabel = UILabel(frame: CGRect(x: 5, y:frame.height/2, width: frame.width - 10, height: frame.height / 2))
            lable_One.backgroundColor =  UIColor.clear
            lable_Two.backgroundColor =  UIColor.clear
            lable_One.textColor =  UIColor.white
            lable_Two.textColor =  UIColor.white
            lable_One.text = Toptext[index]
            lable_One.font = Font2Bold23
            lable_One.textAlignment = .center
            lable_One.numberOfLines = 2
            lable_Two.text =  middletext[index]
            lable_Two.font = FontBold16
            lable_Two.numberOfLines = 5
            lable_Two.textAlignment = .center
            
            vforlabel.addSubview(lable_One)
            vforlabel.addSubview(lable_Two)
            self.pageScroller.addSubview(vforlabel)
            pageScroller.backgroundColor = UIColor.clear
        }
        self.pageScroller.contentSize = CGSize(width: self.view.frame.width * CGFloat(Screens.count), height: self.pageScroller.frame.height)
        pageIndicatore.addTarget(self, action: #selector(OverViewVC.changePage(_:)), for: UIControlEvents.valueChanged)
        pageIndicatore.numberOfPages = Screens.count
        
        pageIndicatore.pageIndicatorTintColor = UIColor.clear
        pageIndicatore.currentPageIndicatorTintColor = UIColor.clear
        pageIndicatore.clipsToBounds = false
    }
    
    func LogoScrollerSetup(){
        logoScroller.contentSize.width = logoScroller.frame.height
        logoScroller.isScrollEnabled = false
        logoScroller.isDirectionalLockEnabled = true
        logoScroller.delegate = self
        
        for index in 0 ..< Screens_logo.count {
            frame_logo.origin.x = 0
            frame_logo.origin.y = logoScroller.frame.height * CGFloat(index)
            
            frame_logo.size = CGSize(width: logoScroller.frame.height, height: logoScroller.frame.height)
            self.logoScroller.isPagingEnabled = true
            let img = Screens_logo[index] as String
            let imageview: UIImageView = UIImageView()
            imageview.image = UIImage(named: "\(img)")
            imageview.frame = frame_logo
            imageview.backgroundColor = UIColor.white
            self.logoScroller.addSubview(imageview)
        }
        self.logoScroller.contentSize = CGSize(width: logoScroller.frame.width, height: logoScroller.frame.height * CGFloat(Screens_logo.count))
        
        logoScroller.backgroundColor = UIColor.white
        logoScroller.clipsToBounds = true
        logoScroller.layer.cornerRadius = logoScroller.frame.height  / 2
        logoScroller.layer.masksToBounds = true
    }
    
    @objc func autoSwitchPage(){
        let x = CGFloat(pageIndicatore.currentPage+changFlag) * self.view.frame.width
        let c : CGRect = CGRect(x: x, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        pageScroller.scrollRectToVisible(c, animated: true)
        updateDots(pagId:pageIndicatore.currentPage+changFlag)
        changFlag = changFlag + 1
        if (changFlag == Screens.count + 1 ) {
            self.ActionOnnxt()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func ActionOnbtnLogin(_ sender: UIButton) {
        //fatalError()
        let Login_vc  = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(Login_vc, animated: true)
    }
    
    @IBAction func ActionOnbtnSignup(_ sender: UIButton) {
        let SignUp_vc  = storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(SignUp_vc, animated: true)
   }
    
    override func viewWillLayoutSubviews()
    {
        super.viewWillLayoutSubviews();
        self.logoScroller.contentSize.width = self.logoScroller.frame.height;
    }
    
    //MARK: CUSTOM METHODs
    func updateDots(pagId:Int) {
        if pagId == 0 {
            imgForIndicatorOne.image = carOn
            imgForIndicatorTwo.image = carOff
            imgForIndicatorTree.image = carOff
            imgForIndicatorFour.image = carOff
        }else if pagId == 1 {
            imgForIndicatorOne.image = carOff
            imgForIndicatorTwo.image = carOn
            imgForIndicatorTree.image = carOff
            imgForIndicatorFour.image = carOff
        }else if pagId == 2{
            imgForIndicatorOne.image = carOff
            imgForIndicatorTwo.image = carOff
            imgForIndicatorTree.image = carOn
            imgForIndicatorFour.image = carOff
        }else if pagId == 3{
            imgForIndicatorOne.image = carOff
            imgForIndicatorTwo.image = carOff
            imgForIndicatorTree.image = carOff
            imgForIndicatorFour.image = carOn
        }
        let imgName : String = Screens[pagId]
        img_bg.image = UIImage(named: imgName)
        let y_logo = CGFloat(pagId) * logoScroller.frame.width
        let c_logo : CGRect = CGRect(x: 0, y: y_logo, width: logoScroller.frame.width, height: logoScroller.frame.height)
        logoScroller.scrollRectToVisible(c_logo, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == pageScroller{
            let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
            changFlag = changFlag + 1
            if (Int(pageNumber) == Screens.count - 1) {
                self.ActionOnnxt()
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == pageScroller{
            let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
            updateDots(pagId:Int(pageNumber))
        }
    }
    
    // MARK : TO CHANGE WHILE CLICKING ON PAGE CONTROL
    @objc func changePage(_ sender: AnyObject) {
        let x = CGFloat(pageIndicatore.currentPage) * pageScroller.frame.size.width
        pageScroller.setContentOffset( CGPoint(x: x, y: 0), animated: true)
    }
}

