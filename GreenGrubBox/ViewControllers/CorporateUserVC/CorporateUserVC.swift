//
//  CorporateUserVC.swift
//  MapTest
//
//  Created by Atul on 1/30/18.
//  Copyright © 2018 Atul. All rights reserved.
//

import UIKit
import Alamofire
class CorporateUserVC: UIViewController {
    var userID: String = ""
    @IBOutlet weak var viewForCorporate: UIView!
    @IBOutlet weak var txtFieldForName: UITextField!
    @IBOutlet weak var txtFieldForPromoCode: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPromocode: UILabel!
    @IBOutlet weak var btnDone: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewForCorporate.layer.cornerRadius = 5.0
        self.viewForCorporate.clipsToBounds = true
        fontSetup()
    }
    
    //MARK: Set Font
    func fontSetup(){
        lblTitle.font = FontBold18
        lblName.font = Font2Bold11
        lblPromocode.font = Font2Bold11
        btnDone.titleLabel?.font = FontBold15
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func ActionOnbtnDone(_ sender: UIButton) {
        self.view.endEditing(true)
        if  userID != "" {
            if validation(){
                //call pi
                self.corporate_signUP(userId: userID, name: (txtFieldForName.text?.condenseWhitespace())!, promocode: (txtFieldForPromoCode.text?.condenseWhitespace())!)
            }
        }else {
            self.showErrorToast(message: "User ID not exist.", backgroundColor: UIColor.red)
        }
    }
    
    func validation() -> Bool {
        if txtFieldForName.text?.condenseWhitespace() != "" {
            if txtFieldForPromoCode.text?.condenseWhitespace() != "" {
                let promocode :String = (txtFieldForPromoCode.text?.condenseWhitespace())!
                return true
            } else {
                self.showErrorToast(message: "Please enter your Promocode.", backgroundColor: UIColor.red)
            }
        } else {
            self.showErrorToast(message: "Please enter your Name.", backgroundColor: UIColor.red)
        }
        return false
    }
    
    //MARK: corporate registration api
    func corporate_signUP(userId: String,name: String,promocode: String){
        let prm:Parameters  = ["userId": userId,
                               "name": name,                               
                               "promoCode": promocode]
        let  headers: HTTPHeaders = ["Content-Type": "application/json"]
        MasterWebService.sharedInstance.PUT_WithHeaderCustom_webservice(Url: EndPoints.Complete_registration_URL, prm: prm, header: headers,  background: false,completion: { _result,_statusCode in
            //   print(_result) as! Any
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
                        UserDefaults.standard.setValue(LoginUserId, forKey: "userid")
                        let t : String = Responsedata.value(forKey: "token") as! String
                        LoginToken = t
                        UserDefaults.standard.setValue(LoginToken, forKey: "token")
                        self.NavigateToHome()
                    }
                } else {
                    self.showErrorToast(message: "Somthing went wrong JSON serialization failed.", backgroundColor: UIColor.red)
                }
                if _result is NSArray {
                    print("array")
                }
            } else{
                self.showErrorToast(message: "Somthing went wrong.", backgroundColor: UIColor.red)
            }
        })
    }
    
    func NavigateToHome(){
        appDelegate.createCustomTabBar()
        appDelegate.window?.rootViewController = appDelegate.TabbarCustomMain
    }
}
