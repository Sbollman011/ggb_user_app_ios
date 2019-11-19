//
//  SignUpVC.swift
//  MapTest
//
//  Created by Dev4 on 1/30/18.
//  Copyright © 2018 Atul. All rights reserved.
//

import UIKit
import Alamofire
class SignUpVC: UIViewController {
    
    @IBOutlet weak var popViewForSignUp: UIView!
    @IBOutlet weak var txtFieldForEmail: UITextField!
    @IBOutlet weak var txtFieldForPassword: UITextField!
    @IBOutlet weak var txtFieldForRepassword: UITextField!
    @IBOutlet weak var btnForCorporate: UIButton!
    @IBOutlet weak var btnForIndividual: UIButton!
    @IBOutlet weak var img_btncorporate: UIImageView!
    @IBOutlet weak var img_btnIndividual: UIImageView!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    
    //labels
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_email: UILabel!
    @IBOutlet weak var lbl_Password: UILabel!
    @IBOutlet weak var lbl_re_password: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.popViewForSignUp.layer.cornerRadius = 4.0
        self.popViewForSignUp.clipsToBounds = true
        
        btnForCorporate.setTitle("CORPORATE", for: .normal)
        btnForCorporate.setTitle("CORPORATE", for: .selected)
        btnForIndividual.setTitle("INDIVIDUAL", for: .normal)
        btnForIndividual.setTitle("INDIVIDUAL", for: .selected)
        img_btncorporate.image = UIImage(named: "select_signup")
        img_btnIndividual.image = UIImage(named: "select_signup")
        
        img_btnIndividual.image = UIImage(named: "unselect_signup")
        img_btncorporate.image = UIImage(named: "select_signup")
        
        fontsetup()
    }
    
    //MARK: Set Font
    func fontsetup(){
        lbl_title.font = FontBold18
        lbl_email.font = Font2Bold11
        lbl_Password.font = Font2Bold11
        lbl_re_password.font = Font2Bold11
        btnLogin.titleLabel?.font = FontBold15
        btnForIndividual.titleLabel?.font  = FontBold10
        btnForCorporate.titleLabel?.font  =  FontBold10
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var accountType : String = "1"
    @IBAction func btnTappedForCorporate(_ sender: Any) {
        accountType = "2"
        img_btnIndividual.image = UIImage(named: "select_signup")
        img_btncorporate.image = UIImage(named: "unselect_signup")
    }
    
    @IBAction func btnForIndividual(_ sender: Any) {
        accountType = "1"
        img_btnIndividual.image = UIImage(named: "unselect_signup")
        img_btncorporate.image = UIImage(named: "select_signup")
    }
    
    @IBAction func ActionOnbtnLogin(_ sender: UIButton) {
        var NavigationPop : Bool = false
        for nav in (self.navigationController?.viewControllers)! {
            if nav is LoginVC {
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
        if NavigationPop   == false{
            let Login_vc  = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.navigationController?.pushViewController(Login_vc, animated: true)
        }
    }
    
    @IBAction func ActionOnbtnClose(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
   
    @IBAction func ActionOnbtnContinue(_ sender: UIButton) {
        self.view.endEditing(true)
        if EmailValidate(){
            if PasswordValidate(){
                self.Signup_service(email: (txtFieldForEmail.text?.condenseWhitespace())!, password: (txtFieldForPassword.text?.condenseWhitespace())!,accountType: accountType)
                print("call api ")
            }
        }
    }
    
    func EmailValidate() -> Bool{
        if txtFieldForEmail.text?.condenseWhitespace() != "" {
            if appDelegate.isValidEmail(testStr: (txtFieldForEmail.text?.condenseWhitespace())!)
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
            if txtFieldForRepassword.text?.condenseWhitespace() != "" {
                if txtFieldForRepassword.text?.condenseWhitespace() == txtFieldForPassword.text?.condenseWhitespace() {
                    let pasword : String = (txtFieldForPassword.text?.condenseWhitespace())!
                    if pasword.count >= 5 {
                        return true
                    }else {
                        self.showErrorToast(message: "Password should be minimum 5 characters.", backgroundColor: UIColor.red)
                    }
                }else {
                    self.showErrorToast(message: "Password & Re-enter Password dosn't match.", backgroundColor: UIColor.red)
                }
            }else {
                self.showErrorToast(message: "Please Re-enter Password.", backgroundColor: UIColor.red)
            }
        }else {
            self.showErrorToast(message: "Please enter Password.", backgroundColor: UIColor.red)
        }
        return false
    }
    
    //MARK: Webservice for SignUP
    func Signup_service(email: String,password: String, accountType: String){
        let DeviceBattryLevel : Float = UIDevice.current.batteryLevel
        let prm:Parameters  = [
            "email": email,
            "password": password,
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
        
        MasterWebService.sharedInstance.POST_webservice(Url: EndPoints.Signup_URL, prm: prm, background: false,completion: { _result,_statusCode in
            if _statusCode == 200 {
                if _result is NSDictionary {
                    print("dict")
                    print(_result)
                    let Responsedata: NSDictionary = _result as! NSDictionary
                    let status : Int =  Responsedata.value(forKey: "status") as! Int
                    if status == 0 {
                        let message : String = Responsedata.value(forKey: "message") as! String
                        self.showErrorToast(message: "\(message)", backgroundColor: UIColor.red)
                    }else if status == 1 {
                        let data : NSDictionary = Responsedata.value(forKey: "data") as! NSDictionary
                        let id : String = data.value(forKey: "_id") as! String
                        LoginUserId = id
                        let email: String = data.value(forKey: "email") as! String
                        self.SignUPCompletion(id : email)
                    }
                } else {
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
    
    //MARK: go to next Screen
    func SignUPCompletion(id: String){
        let objVerifyPinVC  = storyboard?.instantiateViewController(withIdentifier: "VerifyPinVC") as! VerifyPinVC
        objVerifyPinVC.email = id
        self.navigationController?.pushViewController(objVerifyPinVC, animated: true)
    }
}
