//
//  LogoutView.swift
//  TravelsOnClick
//
//  Created by Dev3 on 11/13/18.
//  Copyright © 2018 dev10. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import DropDown
import Stripe
import PKHUD
import Toast

class MoveToPopup: UIView {
    
    var parameters: Parameters?
    
    var PickerDialog: MoveToPopup!
    
    var delegate: STPPaymentCardTextFieldDelegate?
    
    var dropDownData:[String] = [];
    let customDropDown = DropDown()
    
    public typealias moveToPopupView = (String?,Bool?) -> Void
    private var callback: moveToPopupView?
    
    var CardToken : String = ""
    var PackageArray : [Package_Base] = []
    var localManage = String()
    
    var isVirificationForOTP : Bool = false
    
    //MARK : - @IBOutlet
    
    @IBOutlet weak var viewBase: UIView!
    
    @IBOutlet weak var constraintViewBase: NSLayoutConstraint!
    @IBOutlet weak var viewForHeader: UIView!
    @IBOutlet weak var lblTopForHeader: UILabel!
    @IBOutlet weak var viewForIndividual: UIView!
    @IBOutlet weak var viewIndividualHeaderBIG: UILabel!
    @IBOutlet weak var lblTopForHedarUnder: UILabel!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var viewForPackgeType: UIView!
    @IBOutlet weak var lblSelectedItem: UILabel!
    @IBOutlet weak var lblSelectedItemPrice: UILabel!
    @IBOutlet weak var lblCard: UILabel!
    @IBOutlet weak var lblCardDetails: UILabel!
    @IBOutlet weak var viewCardDetails: UIView!
    
    @IBOutlet weak var viewForCorporate: UIView!
    @IBOutlet weak var lblForCorporateUser: UILabel!
    @IBOutlet weak var txtCorporateName: UITextField!
    @IBOutlet weak var lblPromoCode: UILabel!
    @IBOutlet weak var txtPromoCode: UITextField!
    
    @IBOutlet weak var viewForMigrateEmail: UIView!
    @IBOutlet weak var lblEnterEmail: UILabel!    
    @IBOutlet weak var txtEmailEnter: UITextField!
    
    
    override open func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func instanceFromNib() -> UIView {
        return UINib(nibName: "MoveToPopup", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MoveToPopup
    }
    
    func Setup(){
        self.layoutIfNeeded()
        self.setNeedsDisplay()
    }
    
    // Load Initial View
    open func addDiaLogToView(checkWereToMove: String, callback: @escaping moveToPopupView){
        let window = UIApplication.shared.keyWindow!
        PickerDialog = instanceFromNib() as! MoveToPopup
        PickerDialog.frame = (window.frame)
        PickerDialog.callback = callback
        PickerDialog.Setup()
        window.addSubview(PickerDialog)
        window.bringSubview(toFront: PickerDialog)
        window.endEditing(true)
        if checkWereToMove == "Individual"{
            self.PickerDialog.localManage = "Individual"
            Packages_service()
            self.displyViewIndividual()
        }else if checkWereToMove == "Corporate"{
            self.PickerDialog.localManage = "Corporate"
            self.displyviewForCorporate()
        }else if checkWereToMove == "Migrate"{
            self.displayViewForMigrateEmail()
        }
        StripeCardSetup()
    }
    
    // View Individual
    func displyViewIndividual(){
        PickerDialog.lblTopForHeader.text = "INDIVIDUAL"
        PickerDialog.lblTopForHedarUnder.text = "(for yourself)"
        PickerDialog.viewForCorporate.isHidden = true
        PickerDialog.viewForMigrateEmail.isHidden = true
        PickerDialog.viewForIndividual.isHidden = false
        
        PickerDialog.viewForPackgeType.layer.borderWidth = 2.0
        PickerDialog.viewForPackgeType.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        PickerDialog.viewForPackgeType.layer.cornerRadius = 4.0
        
        PickerDialog.viewCardDetails.layer.borderWidth = 2.0
        PickerDialog.viewCardDetails.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        PickerDialog.viewCardDetails.layer.cornerRadius = 4.0
        PickerDialog.viewCardDetails.layer.masksToBounds = true
        
        PickerDialog.lblCardDetails.isHidden = true
    }
    
    // View Corporate
    func displyviewForCorporate(){
        PickerDialog.lblTopForHeader.text = "CORPORATE"
        PickerDialog.lblTopForHedarUnder.text = "(if you have a code)"
        PickerDialog.viewForIndividual.isHidden = true
        PickerDialog.viewForMigrateEmail.isHidden = true
        PickerDialog.viewForCorporate.isHidden = false
    }
    
    // View Migrate Email
    func displayViewForMigrateEmail(){
        PickerDialog.constraintViewBase.constant = PickerDialog.viewForHeader.frame.size.height + PickerDialog.viewForMigrateEmail.frame.size.height + 40
        PickerDialog.lblTopForHeader.text = "Email Varification"
        PickerDialog.lblTopForHedarUnder.isHidden = true
        PickerDialog.viewForCorporate.isHidden = true
        PickerDialog.viewForIndividual.isHidden = true
        PickerDialog.viewForMigrateEmail.isHidden = false
    }
    
    // View Verifiy OTP
    func displayViewForVerifiyOTP(){
        self.lblTopForHeader.text = "OTP Varification"
        self.lblEnterEmail.text = "Insert the 6 digit pin code sent to your email."
        self.lblEnterEmail.numberOfLines = 2
        self.txtEmailEnter.placeholder = "Pin Code"
    }
    
    @IBAction func actionForSelectItme(_ sender: UIButton) {
        customDropDown.show()
    }
    
    //MARK: custom card adding
    func GetTokenFromStripe(){
        HUD.show(.progress)
        STPAPIClient.shared().createToken( withCard: paymentCardTextField.cardParams) { (token: STPToken?, error: Error?) in
            guard let token = token, error == nil else {
                // Present error to user...
                print(error ?? "Nothing")
                self.showToastMessage(message: (error?.localizedDescription)!)
                HUD.hide()
                return
            }
            print(token.description)
            print(token.tokenId)
            self.CardToken =  token.description
            HUD.hide()
            if self.validationForIndividual() {
                let packageID: String = self.PackageArray[self.packageIndex]._id!
                self.moveFromMoveTo(moveInTo: "1", cardToken: self.CardToken, name: self.txtName.text!, packgeID: packageID, promoCode: "")
            }
        }
    }
    
    // Validation Individual
    func validationForIndividual() -> Bool {
        if txtName.text?.condenseWhitespace() != "" {
            if self.packageSelection == true {
                let packageID : String = self.PackageArray[packageIndex]._id!
                if packageID != "" {
                    if self.paymentCardTextField.isValid {
                        return true
                    }else {
                        showToastMessage(message: "Please add a valid card details.")
                    }
                    return true
                }else {
                    showToastMessage(message: "Please select package.")
                }
            }else {
                showToastMessage(message: "Please select package.")
            }
        }else {
            showToastMessage(message: "Please enter your name.")
        }
        return false
    }
    
    // Validation Corporate
    func validateForCorporate() -> Bool{
        if txtCorporateName.text?.condenseWhitespace() != "" {
            if txtPromoCode.text?.condenseWhitespace() != "" {
                return true
            }else{
                showToastMessage(message: "Please add promo code.")
            }
        }else {
            showToastMessage(message: "Please enter your name.")
        }
        return false
    }
    
    //MARK: pakcages
    func Packages_service(){
        let headers: HTTPHeaders = ["Content-Type": "application/json", "authorization": LoginToken]
        MasterWebService.sharedInstance.GET_WithHeaderCustom_webservice(Url:  EndPoints.package_URL, prm: nil ,header: headers, background:false,completion: {_result,_statusCode in
            //   print(_result) as! Any
            
            if _statusCode == 200 {
                if _result is NSDictionary {
                    print("dict")
                    print(_result)
                    let Responsedata: NSDictionary = _result as! NSDictionary
                    let status : Int =  Responsedata.value(forKey: "status") as! Int
                    if status == 0 {
                        let message : String = Responsedata.value(forKey: "message") as! String
                        self.showToastMessage(message: "\(message)")
                    }else if status == 1 {
                        
                        let data : NSArray = Responsedata.value(forKey: "data") as! NSArray
                        print(data)
                        self.PickerDialog.PackageArray =  Package_Base.modelsFromDictionaryArray(array: data)
                        self.setupDefaultDropDown1()
                    }
                } else {
                    self.showToastMessage(message: "Somthing went wrong JSON serialization failed.")
                }
                if _result is NSArray {
                    print("array")
                }
            }else{
                self.showToastMessage(message: "Somthing went wrong.")
            }
        })
    }
    
    //MARK: Dropdown setup
    func setupDefaultDropDown1() {
        PickerDialog.customDropDown.cellNib = UINib(nibName: "MyCell", bundle: nil)
        for T in self.PickerDialog.PackageArray {
            PickerDialog.dropDownData.append(T.name!)
        }
        
        PickerDialog.customDropDown.dataSource = PickerDialog.dropDownData
        PickerDialog.customDropDown.anchorView = PickerDialog.viewForPackgeType
        PickerDialog.customDropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? MyCell else { return }
            
            // Setup your custom UI components
            cell.suffixLabel.text = "$" + self.PickerDialog.PackageArray[index].value!
            cell.suffixLabel.textAlignment = .right
            cell.optionLabel.text = self.PickerDialog.dropDownData[index].capitalized
            cell.optionLabel.textAlignment = .left
        }
        
        PickerDialog.customDropDown.direction = .bottom
        PickerDialog.customDropDown.dismissMode = .automatic
        
        PickerDialog.customDropDown.bottomOffset = CGPoint(x: 0, y: (PickerDialog.customDropDown.anchorView?.plainView.bounds.height)!)
        PickerDialog.customDropDown.selectionAction = { [unowned self] (index, item) in
            self.PickerDialog.packageSelection = true
            self.PickerDialog.packageIndex = index
            self.PickerDialog.lblSelectedItem.text = self.PickerDialog.PackageArray[index].name?.capitalized
            self.PickerDialog.lblSelectedItemPrice.text = "$" + self.PickerDialog.PackageArray[index].value!
            print("here is the resulte")
        }
        customDropDown.cancelAction = { [unowned self] in
            print("here is the Cancel resulte")
        }
    }
    
    var packageSelection : Bool = false
    var packageIndex : Int = 0
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }
    
    var userID: String = ""
    let paymentCardTextField = STPPaymentCardTextField()
    @IBAction func actionForDoneIndividual(_ sender: Any) {
        if validationForIndividual(){
            if paymentCardTextField.cardParams.cvc != "" {
                if paymentCardTextField.isValid {
                    GetTokenFromStripe()
                }else {
                    showToastMessage(message: "Card is not valid.")
                }
            }else {
                showToastMessage(message: "Please enter card details.")
            }
        }
    }
    
    @IBAction func actionForDoneCorporate(_ sender: Any) {
        if self.validateForCorporate(){
            self.moveFromMoveTo(moveInTo: "2", cardToken: "", name: self.txtCorporateName.text!, packgeID: "", promoCode: txtPromoCode.text!)
        }
    }
    
    @IBAction func actionForCross(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        print(textField.isValid)
        if textField.isValid {
            self.lblCardDetails.isHidden = false
            self.lblCardDetails.text = "This card is valid"
            self.lblCardDetails.textColor = appDelegate.uicolorFromHex(rgbValue: 0x41BC40)
            self.lblCardDetails.textAlignment = .right
        } else {
            self.lblCardDetails.isHidden = false
            self.lblCardDetails.text = "This card is not valid"
            self.lblCardDetails.textColor = UIColor.red
            self.lblCardDetails.textAlignment = .right
        }
        if textField.hasText == false {
            self.lblCardDetails.isHidden = true
        }
    }
    
    func StripeCardSetup(){
        for vi in PickerDialog.viewCardDetails.subviews{
            vi.removeFromSuperview()
        }
        PickerDialog.paymentCardTextField.frame = CGRect(x: 0, y: 0, width: PickerDialog.viewCardDetails.frame.width, height: PickerDialog.viewCardDetails.frame.height)
        PickerDialog.paymentCardTextField.font = FontBold15
        PickerDialog.paymentCardTextField.delegate = PickerDialog.delegate
        PickerDialog.viewCardDetails.addSubview(PickerDialog.paymentCardTextField)
    }
    
    func moveFromMoveTo(moveInTo:String, cardToken:String, name:String, packgeID:String, promoCode:String){
        let prm :Parameters  = ["accountType" : moveInTo,
                                "cardToken" : cardToken,
                                "name" : name,
                                "packageId" : packgeID,
                                "promoCode" : promoCode]
        MasterWebService.sharedInstance.POST_Authorization_webservice(Url: EndPoints.User_ChangeMembership_URL, prm: prm, authorization: LoginToken, background: false, completion: { _result,_statusCode in
            if _statusCode == 200 {
                if _result is NSDictionary {
                    print("dict")
                    print(_result)
                    let Responsedata: NSDictionary = _result as! NSDictionary
                    let status : Int =  Responsedata.value(forKey: "status") as! Int
                    if status == 0 {
                        let message : String = Responsedata.value(forKey: "message") as! String
                        self.showToastMessage(message: "\(message)")
                    }else if status == 1 {
                        let token : String = Responsedata.value(forKey: "token") as! String
                        LoginToken = token
                        UserDefaults.standard.setValue(LoginToken, forKey: "token")
                        if self.localManage == "Individual"{
                            self.callback?("Corporate",true)
                            self.removeFromSuperview()
                        }else if self.localManage == "Corporate"{
                            self.callback?("Individual",true)
                            self.removeFromSuperview()
                        }
                    }
                } else {
                    self.showToastMessage(message: "Somthing went wrong JSON serialization failed.")
                }
                if _result is NSArray {
                    print("array")
                }
            }else{
                self.showToastMessage(message: "Somthing went wrong.")
            }
        })
    }
    
    @IBAction func actionOnSubmitEmail(_ sender: Any) {
        if self.isVirificationForOTP {
            self.sendOTPDone(strOTP: txtEmailEnter.text!)
        }else{
            if self.EmailValidate(){
                self.checkIsVaildEmail(strEmail: txtEmailEnter.text!)
                self.txtEmailEnter.text = ""
                self.txtEmailEnter.resignFirstResponder()
            }
        }
    }
    
    func checkIsVaildEmail(strEmail: String){
        let prm :Parameters  = ["email" : strEmail]
        MasterWebService.sharedInstance.POST_Authorization_webservice(Url: EndPoints.User_EmailVerfiy_URL, prm: prm, authorization: LoginToken, background: false, completion: { _result,_statusCode in
            if _statusCode == 200 {
                if _result is NSDictionary {
                    print("dict")
                    print(_result)
                    let Responsedata: NSDictionary = _result as! NSDictionary
                    let status : Int =  Responsedata.value(forKey: "status") as! Int
                    if status == 1 {
                        // chnage view for OTP
                        self.isVirificationForOTP = true
                        self.displayViewForVerifiyOTP()
                    }else{
                        let message : String = Responsedata.value(forKey: "message") as! String
                        self.showToastMessage(message: "\(message)")
                    }
                } else {
                    self.showToastMessage(message: "Somthing went wrong JSON serialization failed.")
                }
            }
        })
    }
    
    func EmailValidate() -> Bool{
        if txtEmailEnter.text?.condenseWhitespace() != "" {
            if appDelegate.isValidEmail(testStr: (txtEmailEnter.text?.condenseWhitespace())!){
                return true
            } else {
                self.showToastMessage(message: "Please enter valid email address.")
            }
        } else {
            self.showToastMessage(message: "Please enter email address.")
        }
        return false
    }
    
    func sendOTPDone(strOTP: String){
        let prm :Parameters  = ["otp" : strOTP]
        MasterWebService.sharedInstance.POST_Authorization_webservice(Url: EndPoints.User_EmailVerfiyOTP_URL, prm: prm, authorization: LoginToken, background: false, completion: { _result,_statusCode in
            if _statusCode == 200 {
                if _result is NSDictionary {
                    print("dict")
                    print(_result)
                    let Responsedata: NSDictionary = _result as! NSDictionary
                    let status : Int =  Responsedata.value(forKey: "status") as! Int
                    if status == 1 {
                        let token : String = Responsedata.value(forKey: "token") as! String
                        LoginToken = token
                        UserDefaults.standard.setValue(LoginToken, forKey: "token")
                        self.callback?("Migrate",true)
                        self.removeFromSuperview()
                    }else{
                        let message : String = Responsedata.value(forKey: "message") as! String
                        self.showToastMessage(message: "\(message)")
                    }
                } else {
                    self.showToastMessage(message: "Somthing went wrong JSON serialization failed.")
                }
            }
        })
    }
    
    func showToastMessage(message : String) {
        let window = UIApplication.shared.windows.last!
        let style: CSToastStyle? = nil
        style?.messageNumberOfLines = 0
        style?.titleAlignment = .center
        window.makeToast(message, duration: 2.0, position: CSToastPositionTop , style: style)
    }
}

fileprivate extension UIView {
    var firstViewController: UIViewController? {
        let firstViewController = sequence(first: self, next: { $0.next }).first(where: { $0 is UIViewController })
        return firstViewController as? UIViewController
    }
}
