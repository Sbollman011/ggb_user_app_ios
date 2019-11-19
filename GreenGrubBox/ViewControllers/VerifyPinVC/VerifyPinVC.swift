//
//  VerifyPinVC.swift
//  GreenGrubBox
//
//  Created by dev10 on 10/23/18.
//  Copyright © 2018 Ankit. All rights reserved.
//

import UIKit
import Alamofire

class VerifyPinVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtPin: UITextField!
    @IBOutlet weak var imgVerified: UIImageView!
    
    var searchenable : Bool = false
    var Searchtimer: Timer?
    var email:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtPin.delegate = self
        txtPin.addTarget(self, action: #selector(VerifyPinVC.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        txtPin.layer.cornerRadius = 5.0
        txtPin.clipsToBounds = true
        txtPin.layer.borderColor = UIColor.gray.cgColor
        txtPin.layer.borderWidth = 1
        PinVerify().addDiaLogToView(callback: {
            (dict, bool) in
            print(dict ?? "nul", bool ?? "nul")
        })
    }
    
    @IBAction func actionBack(_ sender: Any) {
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: LoginVC.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }else{
                guard let window = UIApplication.shared.keyWindow else {
                    return
                }
                let loginViewController  = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                let nav:UINavigationController = UINavigationController(rootViewController: loginViewController);
                nav.isNavigationBarHidden = true
                
                UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromRight, animations: {
                    window.rootViewController = nav
                }, completion: { completed in
                    // maybe do something here
                })
            }
        }
    }
    
    @IBAction func actionResend(_ sender: Any) {
        resend_varification_mail()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        if newLength > 6 || string == " "
        {
            return false
        }
        return true
    }
    
    //MARK: CUSTOM METHODS
    @objc func textFieldDidChange(_ textField:UITextField){
        let searchTextString : NSString! = textField.text as NSString!
        if (searchTextString.length  == 6 )
        {
            searchenable = true
            print(textField.text as Any)
            Searchtimer?.invalidate()
            self.Searchtimer = Timer.scheduledTimer(timeInterval: 0.90, target: self, selector: #selector(VerifyPinVC.CallSearch), userInfo: nil, repeats: false)
        }
    }
    
    @objc func CallSearch(){
        if MasterWebService.sharedInstance.Check_networkConnection() {
            Searchtimer?.invalidate()
            if (txtPin.text != ""){
                txtPin.resignFirstResponder()
                PinCheck(SearchText: (txtPin.text)!)
            }else{
                searchenable = false
            }
        }
    }
    
    func PinCheck(SearchText:String){
        let prm :Parameters  = [
            "otp": Int(SearchText)!,
            "email": email,
        ]
        MasterWebService.sharedInstance.POST_webservice(Url: EndPoints.User_VerifyOTP_URL, prm: prm, background: false,completion: { _result,_statusCode in
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
                        self.verifyCompletion(id: id)
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
    
    func verifyCompletion(id: String){
        let Individual_vc  = storyboard?.instantiateViewController(withIdentifier: "IndividualUserVC") as! IndividualUserVC
        Individual_vc.userID  = id
        self.navigationController?.pushViewController(Individual_vc, animated: true)
    }
    
    //Resend mail For verification
    func resend_varification_mail(){
        let prm :Parameters  = [
            "email": email,
        ]
        MasterWebService.sharedInstance.POST_webservice(Url: EndPoints.User_ResendOTP_URL, prm: prm, background: false,completion: { _result,_statusCode in
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
                        PinVerify().addDiaLogToView(callback: {
                            (dict, bool) in
                            print(dict ?? "nul", bool ?? "nul")
                        })
                    }
                }else
                {
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
}
