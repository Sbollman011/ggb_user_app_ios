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
import CCValidator

@available(iOS 10.0, *)
class MoveToPopup: UIView, UITextFieldDelegate {
    
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
    
    private var previousTextFieldContent: String?
    private var previousSelection: UITextRange?
    
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
    
    @IBOutlet weak var txtCardNo: UITextField!
    @IBOutlet weak var txtCardExMonth: UITextField!
    @IBOutlet weak var txtCardExYear: UITextField!
    @IBOutlet weak var txtCardCVC: UITextField!
    
    
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
    }
    
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
        
        PickerDialog.txtCardNo.delegate = self
        PickerDialog.txtCardExMonth.delegate = self
        PickerDialog.txtCardExYear.delegate = self
        PickerDialog.txtCardCVC.delegate = self
        
        PickerDialog.lblCardDetails.isHidden = true
    }
    
    func displyviewForCorporate(){
        PickerDialog.lblTopForHeader.text = "CORPORATE"
        PickerDialog.lblTopForHedarUnder.text = "(if you have a code)"
        PickerDialog.viewForIndividual.isHidden = true
        PickerDialog.viewForMigrateEmail.isHidden = true
        PickerDialog.viewForCorporate.isHidden = false
    }
    
    func displayViewForMigrateEmail(){
        PickerDialog.constraintViewBase.constant = PickerDialog.viewForHeader.frame.size.height + PickerDialog.viewForMigrateEmail.frame.size.height + 40
        PickerDialog.lblTopForHeader.text = "Email Varification"
        PickerDialog.lblTopForHedarUnder.isHidden = true
        PickerDialog.viewForCorporate.isHidden = true
        PickerDialog.viewForIndividual.isHidden = true
        PickerDialog.viewForMigrateEmail.isHidden = false
    }
    
    func displayViewForVerifiyOTP(){
        self.lblTopForHeader.text = "OTP Varification"
        self.lblEnterEmail.text = "Insert the 6 digit pin code sent to your email."
        self.lblEnterEmail.numberOfLines = 2
        self.txtEmailEnter.placeholder = "Pin Code"
    }
    
    @IBAction func actionForSelectItme(_ sender: UIButton) {
        customDropDown.show()
    }
    
    func validationForIndividual() -> Bool {
        if txtName.text?.condenseWhitespace() != "" {
            if self.packageSelection == true {
                let packageID : String = self.PackageArray[packageIndex]._id!
                if packageID != "" {
                    let isFullCardDataOK = CCValidator.validate(creditCardNumber: txtCardNo.text! as String)
                    if isFullCardDataOK{
                        return true
                    }else{
                        if txtCardNo.text?.condenseWhitespace() != "" {
                            showToastMessage(message: "Please add a valid card details.")
                        }else{
                            showToastMessage(message: "Please add a card details.")
                        }
                    }
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
    @IBAction func actionForDoneIndividual(_ sender: Any) {
        if validationForIndividual(){
            if validateYearAndMonthAndCVC(){
                let dictionary : [String : String] = ["number":txtCardNo.text!,"expMonth":txtCardExMonth.text!,"expYear":txtCardExYear.text!,"cvc":txtCardCVC.text!]
                let getjsonString = getJsonString(jsonDict: dictionary)
                self.getJsonData(jsonSrting: getjsonString)
            }
        }
    }
    
    func validateYearAndMonthAndCVC() -> Bool{
        if txtCardExMonth.text?.condenseWhitespace() != "" {
            if txtCardExMonth.text!.count == 2{
                if txtCardExYear.text?.condenseWhitespace() != "" {
                    if txtCardExYear.text!.count == 4{
                        if txtCardCVC.text?.condenseWhitespace() != ""{
                            if txtCardCVC.text!.count >= 3{
                                return true
                            }else{
                                showToastMessage(message: "Please enter valid card CVC.")
                            }
                        }else{
                            showToastMessage(message: "Please enter card CVC.")
                        }
                    }else{
                        showToastMessage(message: "Please enter valid card expiry year.")
                    }
                }else{
                    showToastMessage(message: "Please enter card expiry year.")
                }
            }else{
                showToastMessage(message: "Please enter valid card expiry month.")
            }
        }else{
            showToastMessage(message: "Please enter card expiry month.")
        }
        return false
    }
    
    @IBAction func actionForDoneCorporate(_ sender: Any) {
        if self.validateForCorporate(){
            self.moveFromMoveTo(moveInTo: "2", cardToken: "", name: self.txtCorporateName.text!, packgeID: "", promoCode: txtPromoCode.text!, cardDetail: "")
        }
    }
    
    @IBAction func actionForCross(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    func moveFromMoveTo(moveInTo:String, cardToken:String, name:String, packgeID:String, promoCode:String, cardDetail:String){
        let prm :Parameters  = ["accountType" : moveInTo,
                                "cardToken" : cardToken,
                                "name" : name,
                                "packageId" : packgeID,
                                "promoCode" : promoCode,
                                "cardDetail":cardDetail]
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
    
    func getJsonString(jsonDict :[String : String]) -> String{
        let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict)
        let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
        return jsonString! as String
    }
    
    func getJsonData(jsonSrting: String) {
        if UserDefaults.standard.object(forKey: "rsaPublicKey") != nil{
            if let tempNames: String = UserDefaults.standard.object(forKey: "rsaPublicKey") as? String {
                let serverPublicKey = tempNames
                let encryptedPassword = RSA.encrypt(string: jsonSrting, publicKey: serverPublicKey)
                
                let packageID: String = self.PackageArray[self.packageIndex]._id!
                self.moveFromMoveTo(moveInTo: "1", cardToken: "", name: self.txtName.text!, packgeID: packageID, promoCode: "", cardDetail: encryptedPassword!)
            }
        }
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == PickerDialog.txtCardNo{
            let newLength = (textField.text?.utf16.count)! + string.utf16.count - range.length
            if newLength <= 16 {
                return true
            } else {
                return false
            }
        }else if textField == PickerDialog.txtCardExMonth{
            let newLength = (textField.text?.utf16.count)! + string.utf16.count - range.length
            if newLength <= 2 {
                return true
            } else {
                return false
            }
        }else if textField == PickerDialog.txtCardExYear || textField == PickerDialog.txtCardCVC{
            let newLength = (textField.text?.utf16.count)! + string.utf16.count - range.length
            if newLength <= 4 {
                return true
            } else {
                return false
            }
        }else{
            return false
        }
    }
}

fileprivate extension UIView {
    var firstViewController: UIViewController? {
        let firstViewController = sequence(first: self, next: { $0.next }).first(where: { $0 is UIViewController })
        return firstViewController as? UIViewController
    }
}

struct RSA {
    static func encrypt(string: String, publicKey: String?) -> String? {
        guard let publicKey = publicKey else { return nil }
        let keyString = publicKey.replacingOccurrences(of: "-----BEGIN RSA PUBLIC KEY-----\n", with: "").replacingOccurrences(of: "\n-----END RSA PUBLIC KEY-----", with: "")
        guard let data = Data(base64Encoded: keyString) else { return nil }
        var attributes: CFDictionary {
            return [kSecAttrKeyType         : kSecAttrKeyTypeRSA,
                    kSecAttrKeyClass        : kSecAttrKeyClassPublic,
                    kSecAttrKeySizeInBits   : 2048,
                    kSecReturnPersistentRef : kCFBooleanTrue] as CFDictionary
        }
        
        var error: Unmanaged<CFError>? = nil
        guard let secKey = SecKeyCreateWithData(data as CFData, attributes, &error) else {
            
            return nil
        }
        return encrypt(string: string, publicKey: secKey)
    }
    static func encrypt(string: String, publicKey: SecKey) -> String? {
        let buffer = [UInt8](string.utf8)
        
        var keySize   = SecKeyGetBlockSize(publicKey)
        var keyBuffer = [UInt8](repeating: 0, count: keySize)
        
        // Encrypto  should less than key length
        guard SecKeyEncrypt(publicKey, SecPadding.PKCS1, buffer, buffer.count, &keyBuffer, &keySize) == errSecSuccess else { return nil }
        return Data(bytes: keyBuffer, count: keySize).base64EncodedString()
    }
}
