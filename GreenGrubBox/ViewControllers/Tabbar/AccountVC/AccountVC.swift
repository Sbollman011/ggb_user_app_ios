//
//  AccountVC.swift
//  GreenGrubBox
//
//  Created by Ankit on 1/31/18.
//  Copyright © 2018 Ankit. All rights reserved.
//

import UIKit
import  Alamofire
import MessageUI

class AccountVC: UIViewController,MFMailComposeViewControllerDelegate{
    
    //MARK:IB-Outlets
    @IBOutlet weak var constrain_scrollview_bottom: NSLayoutConstraint!
    @IBOutlet var viewForBoxCount: UIView!
    @IBOutlet var viewForAccountDetail: UIView!
    @IBOutlet var viewForSupport: UIView!
    @IBOutlet var viewForOther: UIView!
    
    //lables outlets
    @IBOutlet weak var lbl_BoxBigcount: UILabel!
    @IBOutlet weak var lbl_boxTitle: UILabel!
    @IBOutlet weak var lbl_boxSubtitle: UILabel!
    @IBOutlet weak var lbl_scanBox: UILabel!
    @IBOutlet weak var lbl_Username: UILabel!
    @IBOutlet weak var lblTotalBoxUsed: UILabel!
    @IBOutlet weak var lblCallUs: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblTerms: UILabel!
    @IBOutlet weak var lblWebsite: UILabel!
    @IBOutlet weak var lblSubscriptionExpireDate: UILabel!
    @IBOutlet weak var lblResyncApp: UILabel!
    @IBOutlet weak var lblLogOut: UILabel!
    
    //buttons outlets
    @IBOutlet weak var btnWebsite: UIButton!
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var btnEmail: UIButton!
    @IBOutlet weak var btnTermCondition: UIButton!
    @IBOutlet weak var btnRequestBoxCountCorrection: UIButton!
    @IBOutlet weak var btnCallus: UIButton!
    
    //lables outlets
    @IBOutlet weak var lblTapWebsite: UILabel!
    @IBOutlet weak var lblCorporateOrIndividual: UILabel!
    
    @IBOutlet weak var consttrainHeight: NSLayoutConstraint!
    @IBOutlet weak var constainMigratVHeight: NSLayoutConstraint!
    
    var isCorporate = Bool()
    var isIndividual = Bool()
    
    //MARK:App Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        let device : Model = UIDevice().type
        
        if device == .iPhoneX {
            constrain_scrollview_bottom.constant =  70
        }else {
            constrain_scrollview_bottom.constant =  40
        }
        
        appDelegate.BoardercolorOfView(sender: viewForBoxCount, color: UIColor.clear, borderWidth: 0, cornerRadius: 5)
        appDelegate.BoardercolorOfView(sender: viewForSupport, color: appDelegate.uicolorFromHex(rgbValue: 0xE7E7E7), borderWidth: 0, cornerRadius: 5)
        appDelegate.BoardercolorOfView(sender: viewForOther, color: appDelegate.uicolorFromHex(rgbValue: 0xE7E7E7), borderWidth: 0, cornerRadius: 5)
        appDelegate.BoardercolorOfView(sender: viewForAccountDetail, color:appDelegate.uicolorFromHex(rgbValue: 0xD2D3D5), borderWidth: 1, cornerRadius: 5)
        
        UpdateBoxDetails()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        lblTapWebsite.isUserInteractionEnabled = true
        lblTapWebsite.addGestureRecognizer(tap)
    }
    
    @objc
    func tapFunction(sender:UITapGestureRecognizer) {
        print("tap working")
        UIApplication.shared.openURL(NSURL(string: "https://greengrubbox.com/")! as URL)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        appDelegate.tabBarView.isHidden = false
        self.GetUserDetails()
        if isLatestPhase {
            self.consttrainHeight.constant = 0.0
            self.constainMigratVHeight.constant = 0.0
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: IB-Action
    @IBAction func actionOnBoxCount(_ sender: Any) {
        let boxHistory_vc  = storyboard?.instantiateViewController(withIdentifier: "BoxHistoryVC") as! BoxHistoryVC
        self.navigationController?.pushViewController(boxHistory_vc, animated: true)
    }
    
    @IBAction func ActionOnbtnResync(_ sender: UIButton) {
        GetUserDetails()
    }
    
    @IBAction func ActionOnbtnCallus(_ sender: UIButton) {
        if #available(iOS 10.0, *) {
            if Callus != "" {
                UIApplication.shared.open(NSURL(string: "tel://" + Callus)! as URL)
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func actionOnLogOut(_ sender: Any) {
        alertOnLogout()
    }
    
    func alertOnLogout(){
        //Popup for user confirmation
        let logOutAlert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: UIAlertControllerStyle.alert)
        
        logOutAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            self.UserLogOut()
            self.LogOUtUserAfterService()
        }))
        
        logOutAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        present(logOutAlert, animated: true, completion: nil)
    }
    
    @IBAction func ActionOnbtnWebsite(_ sender: UIButton) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(NSURL(string:webUrl)! as URL)
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func actionOnMoveTo(_ sender: Any) {
        var strSetNextView = String()
        if self.checkForMoveToLable() == "Individual" {
            strSetNextView = "Corporate"
        }else if self.checkForMoveToLable() == "Corporate" {
            strSetNextView = "Individual"
        }
        MoveToPopup().addDiaLogToView(checkWereToMove: strSetNextView, callback: {
            (string,bool) in
            if bool == true{
                if strSetNextView == "Individual"{
                    self.setMoveToCorporate()
                }else if strSetNextView == "Corporate"{
                    self.setMoveToIndividual()
                }
            } else {
                
            }
        })
    }
    
    func instanceFromNib() -> UIView {
        return UINib(nibName: "MoveToPopup", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MoveToPopup
    }
    
    @IBAction func actionOnMoveNewEmail(_ sender: Any) {
        MoveToPopup().addDiaLogToView(checkWereToMove: "Migrate", callback: {
            (string,bool) in
            if bool == true{
                
            } else {
                
            }
        })
    }
    
    func viewForCorporate(){
        
    }
    func viewForIndividual(){
        
    }
    func viewForMigrateToNewEmail(){
        
    }
    
    @IBAction func ActionOnbtnTerms(_ sender: UIButton) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(NSURL(string:termsAndCondition)! as URL)
        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func ActionOnbtnEmail(_ sender: UIButton) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([ggb_email])
            mail.setSubject("Green GrubBox")
            mail.setMessageBody("Green GrubBox User", isHTML: false)
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    // MARK: - MFMailComposeViewControllerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    var totalBoxes : Int = 0
    var currentBoxes : Int = 0
    var UserName : String = ""
    var ggb_email : String = ""
    var webUrl: String = ""
    var nextRenewOn : String = ""
    var termsAndCondition : String = ""
    var Callus : String = ""
    
    //MARK: USer details
    func GetUserDetails(){
        
        let  headers: HTTPHeaders = ["Content-Type": "application/json","authorization": LoginToken]
        print(headers)
        MasterWebService.sharedInstance.GET_WithHeaderCustom_webservice(Url:  EndPoints.User_Detail_URL + "?id=\(LoginUserId)", prm: nil ,header: headers,background:false,completion: {_result,_statusCode in
            if _statusCode == 200 {
                if _result is NSDictionary {
                    print("dict")
                    print(_result)
                    let Responsedata: NSDictionary = _result as! NSDictionary
                    let status : Int =  Responsedata.value(forKey: "status") as! Int
                    if status == 0 {
                        let message : String = Responsedata.value(forKey: "message") as! String
                        self.showAlert(withTitle: "Message", message:  "\(message)")
                    }else if status == 1 {
                        print(Responsedata)
                        let data : NSDictionary = Responsedata.value(forKey: "data") as! NSDictionary
                        self.currentBoxes = data.value(forKey: "currentBoxes") as! Int
                        //self.currentBoxes = 0
                        self.totalBoxes = data.value(forKey: "totalBoxes") as! Int
                        self.UserName = data.value(forKey: "name") as! String
                        self.ggb_email = data.value(forKey: "ggb_email") as! String
                        self.webUrl = data.value(forKey: "webUrl") as! String
                        self.nextRenewOn = data.value(forKey: "nextRenewOn") as! String
                        self.termsAndCondition = data.value(forKey: "termsAndCondition") as! String
                        self.Callus  = data.value(forKey: "number") as! String
                        if data.value(forKey: "accountType") as! Int == 1{
                            self.setMoveToCorporate()
                        }else if data.value(forKey: "accountType") as! Int == 2{
                            self.setMoveToIndividual()
                        }
                        self.UpdateBoxDetails()
                    }
                } else {
                    self.showAlert(withTitle: "Message", message: "Somthing went wrong JSON serialization failed.")
                }
                if _result is NSArray {
                    print("array")
                }
            }else{
                self.showAlert(withTitle: "Message", message:  "Somthing went wrong.")
            }
        })
    }
    
    func checkForMoveToLable()-> String{
        var strSelected = String()
        if self.isIndividual == true && self.isCorporate == false{
            strSelected = "Individual"
        }else if self.isIndividual == false && self.isCorporate == true{
            strSelected = "Corporate"
        }
        return strSelected
    }
    
    func setMoveToIndividual(){
        self.isCorporate = true
        self.isIndividual = false
        self.lblCorporateOrIndividual.text = "Move to Individual"
    }
    
    func setMoveToCorporate(){
        self.isIndividual = true
        self.isCorporate = false
        self.lblCorporateOrIndividual.text = "Move to Corporate"
    }
    
    func UpdateBoxDetails(){
        lbl_BoxBigcount.text =  "\(currentBoxes)"
        var subMsgString:String = "You have \(currentBoxes) GrubBoxs scanned out."
        
        if currentBoxes == 0{
            lbl_boxSubtitle.isHidden = true
            subMsgString =  "You have \(currentBoxes) boxes checked out,\n get to grubbing!"
        }else{
            lbl_boxSubtitle.isHidden = false
            lbl_boxSubtitle.text = "Please visit a drop location today!"
        }
        if currentBoxes == 1 {
            subMsgString =  "You have \(currentBoxes) GrubBox scanned out."
        }
        
        lbl_boxTitle.text = subMsgString
        lbl_Username.text = UserName
        lblTotalBoxUsed.text = "\(totalBoxes)"
        lblSubscriptionExpireDate.text = nextRenewOn
    }
    
    func UserLogOut(){
        let  headers: HTTPHeaders = ["Content-Type": "application/json","authorization": LoginToken]
        print(headers)
        MasterWebService.sharedInstance.GET_WithHeaderCustom_webservice(Url:  EndPoints.User_LogOut_URL , prm: nil ,header: headers,background:false,completion: {_result,_statusCode in
            if _statusCode == 200 {
                if _result is NSDictionary {
                    print("dict")
                    print(_result)
                    let Responsedata: NSDictionary = _result as! NSDictionary
                    let status : Int =  Responsedata.value(forKey: "status") as! Int
                    if status == 0 {
                        let message : String = Responsedata.value(forKey: "message") as! String
                        self.showAlert(withTitle: "Message", message:  "\(message)")
                    }else if status == 1 {
                        print(Responsedata)
                    }
                } else {
                    self.showAlert(withTitle: "Message", message: "Somthing went wrong JSON serialization failed.")
                }
                if _result is NSArray {
                    print("array")
                }
            }else{
                self.showAlert(withTitle: "Message", message: "Somthing went wrong.")
            }
        })
    }
    
    @IBAction func ComposeMailWithBody(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["support@greengrubbox.com"])
            mail.setSubject("Request Container Return issue.")
            mail.setMessageBody("Please let us know what happened with your GrubContainer. \r\n \r\n \r\n \r\n \r\n \r\n  \r\n --  \r\n Thank you  \r\n Team GGB", isHTML: false)
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    func LogOUtUserAfterService(){
        //MARK: remove all nsuserdeffaluts
        LoginUserId = ""
        LoginToken = ""
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        
        let nav_splaxh_vc  = storyboard?.instantiateViewController(withIdentifier: "Navigtioncontroller") as! UINavigationController
        appDelegate.window?.rootViewController = nav_splaxh_vc
    }
}

