//
//  LoginVC.swift
//  MapTest
//
//  Created by Atul on 1/29/18.
//  Copyright © 2018 Atul. All rights reserved.
//

import UIKit
import Alamofire
import Crashlytics
class LoginVC: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var loginPopView: UIView!
    @IBOutlet weak var txtForEmail: UITextField!
    @IBOutlet weak var txtFieldForPassword: UITextField!
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var btnForgetpassword: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lbl_email: UILabel!
    @IBOutlet weak var lbl_password: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.loginPopView.layer.cornerRadius = 5.0
        self.loginPopView.clipsToBounds = true
        fontSetup()
    }
    
    func fontSetup(){
        lblTitle.font = FontBold18
        lbl_email.font = Font2Bold11
        lbl_password.font = Font2Bold11
        btnLogin.titleLabel?.font = FontBold15
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func tappedTo(_ sender: Any) {
        var NavigationPop : Bool = false
        for nav in (self.navigationController?.viewControllers)! {
            if nav is SignUpVC {
                NavigationPop = true
                let transition = CATransition()
                transition.duration = 0.5
                transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                transition.type = kCATransitionPush
                transition.subtype = kCATransitionFromRight
                self.navigationController?.view.layer.add(transition, forKey: nil)
                self.navigationController?.popToViewController(nav, animated: false)
                break
            }
        }
        
        if NavigationPop == false {
            let SignUp_vc  = storyboard?.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
            self.navigationController?.pushViewController(SignUp_vc, animated: true)
        }
    }
    
    @IBAction func ActionOnbtnLogin(_ sender: UIButton) {
        self.view.endEditing(true)
        if EmailValidate(){
            if PasswordValidate(){
                login_service(email: (txtForEmail.text?.condenseWhitespace())!, Password: (txtFieldForPassword.text?.condenseWhitespace())!)
            }
        }
    }
    
    @IBAction func ActionOnbtnForgetPassword(_ sender: UIButton) {
        ForgetPasswordView().AddForgetPopUp(callback: {
            (Email, bool) in
            print(Email ?? "nul", bool ?? "nul")
            if bool!{
                self.ForgotPassword_service(email: Email!)
            }else {
                if Email != "" {
                    self.showErrorToast(message: Email!, backgroundColor: UIColor.red)
                }
            }
        })
    }
    
    func EmailValidate() -> Bool{
        if txtForEmail.text?.condenseWhitespace() != "" {
            if appDelegate.isValidEmail(testStr: (txtForEmail.text?.condenseWhitespace())!)
            {
                return true
            }else {
                self.showErrorToast(message: "Please enter valid email address.", backgroundColor: UIColor.red)
            }
        }else {
            self.showErrorToast(message: "Please enter email address.", backgroundColor: UIColor.red)
        }
        return false
    }
    
    func PasswordValidate() -> Bool{
        if txtFieldForPassword.text?.condenseWhitespace() != "" {
            let pasword : String = (txtFieldForPassword.text?.condenseWhitespace())!
            if pasword.count >= 5 {
                return true
            }else {
                self.showErrorToast(message: "Password should be minimum 5 characters.", backgroundColor: UIColor.red)
            }
        }else {
            self.showErrorToast(message: "Please enter password.", backgroundColor: UIColor.red)
        }
        return false
    }
    
    @IBAction func ActionOnbtnClose(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: webservice callling setup etc
    func login_service(email: String , Password: String){
        
        let DeviceBattryLevel : Float = UIDevice.current.batteryLevel
        let prm:Parameters  = [
            "email": email,
            "password": Password,
            "deviceInfo": [
                "os": "iOS",
                "osVer": DeviceOSVersion,
                "devModel":Device_MOdel_name.rawValue,
                "resWidth" : DeviceSize.width,
                "resHeight" : DeviceSize.height,
                "appVer": "0.1",
                "device_token":DeviceToken,
                "battery": DeviceBattryLevel
            ]
        ]

        MasterWebService.sharedInstance.POST_webservice(Url: EndPoints.Login_URL, prm: prm, background: false,completion: { _result,_statusCode in
            
            if _statusCode == 200 {
                if _result is NSDictionary {
                    print("dict")
                    print(_result)
                    let Responsedata: NSDictionary = _result as! NSDictionary
                    let status : Int =  Responsedata.value(forKey: "status") as! Int
                    if status == 0 {
                        let message : String = Responsedata.value(forKey: "message") as! String
                        self.showErrorToast(message: "\(message)", backgroundColor: UIColor.red)
                    }else  if status == 1 {
                        let data : NSDictionary = Responsedata.value(forKey: "data") as! NSDictionary
                        let isRenewRequire : Int =  data.value(forKey: "isRenewRequire") as! Int
                        let id : String = data.value(forKey: "_id") as! String
                        LoginUserId = id
                        UserDefaults.standard.setValue(LoginUserId, forKey: "userid")
                        let t : String = Responsedata.value(forKey: "token") as! String
                        LoginToken = t
                        UserDefaults.standard.setValue(LoginToken, forKey: "token")
                        appDelegate.createCustomTabBar()
                        appDelegate.window?.rootViewController = appDelegate.TabbarCustomMain
                        if isRenewRequire == 1 {
                            let message : String = Responsedata.value(forKey: "message") as! String
                            self.promtMsg(msg: message, color:UIColor.black)
                        }
                    }else  if status == 2 {
                        //Individual screen
                        let data : NSDictionary = Responsedata.value(forKey: "data") as! NSDictionary
                        let id : String = data.value(forKey: "_id") as! String
                        self.SignUPCompletion(accountType: "1", id: id)
                    }else  if status == 3 || status == 4 {
                        //Verify OTP
                        if status == 3{
                            let message : String = Responsedata.value(forKey: "message") as! String
                            self.showErrorToast(message: message, backgroundColor: UIColor.green)
                        }
                        let data : NSDictionary = Responsedata.value(forKey: "data") as! NSDictionary
                        let email : String = data.value(forKey: "email") as! String
                        self.verifyCompletion(email: email)
                    }
                }else{
                    self.showErrorToast(message: "Somthing went wrong JSON serialization failed.", backgroundColor: UIColor.red)
                }
                if _result is NSArray {
                    print("array")
                }
            }else{
                self.showErrorToast(message: "Somthing went wrong.", backgroundColor: UIColor.red)
            }
        })
    }
    
    func promtMsg(msg:String,color:UIColor){
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.showErrorToast(message: msg , duration: 2000, backgroundColor: color)
        }
    }
    
    func ForgotPassword_service(email: String ){
        let prm:Parameters  = ["email": email]
        print(prm)
        MasterWebService.sharedInstance.POST_webservice(Url: EndPoints.ForgotPassword_URL, prm: prm, background: false,completion: { _result,_statusCode in
            if _statusCode == 200 {
                if _result is NSDictionary {
                    print("dict")
                    print(_result)
                    let Responsedata: NSDictionary = _result as! NSDictionary
                    let status : Int =  Responsedata.value(forKey: "status") as! Int
                    if status == 0 {
                        let message : String = Responsedata.value(forKey: "message") as! String
                        self.showErrorToast(message: "\(message)", backgroundColor: UIColor.red)
                    }else  if status == 1 {
                        let message : String = Responsedata.value(forKey: "message") as! String
                        self.showErrorToast(message: "\(message)", backgroundColor: UIColor.green)
                    }
                }else{
                    self.showErrorToast(message: "Somthing went wrong JSON serialization failed.", backgroundColor: UIColor.red)
                }
                if _result is NSArray {
                }
            }else{
                self.showErrorToast(message: "Somthing went wrong.", backgroundColor: UIColor.red)
            }
        })
    }
    
    //MARK: go to next Screen
    func SignUPCompletion(accountType :String ,id: String){
        if accountType == "1" {
            //individual
            let Individual_vc  = storyboard?.instantiateViewController(withIdentifier: "IndividualUserVC") as! IndividualUserVC
            Individual_vc.userID  = id
            self.navigationController?.pushViewController(Individual_vc, animated: true)
        }else if accountType == "2" {
            //corporate
            let Corporate_vc  = storyboard?.instantiateViewController(withIdentifier: "CorporateUserVC") as! CorporateUserVC
            Corporate_vc.userID  = id
            self.navigationController?.pushViewController(Corporate_vc, animated: true)
        }
    }
    
    func verifyCompletion(email: String){
        let objVerifyPinVC  = storyboard?.instantiateViewController(withIdentifier: "VerifyPinVC") as! VerifyPinVC
        objVerifyPinVC.email = email
        self.navigationController?.pushViewController(objVerifyPinVC, animated: true)
    }
}
