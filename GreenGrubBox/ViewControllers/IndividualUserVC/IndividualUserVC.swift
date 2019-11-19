//
//  IndividualUserVC.swift
//  MapTest
//
//  Created by Dev4 on 1/31/18.
//  Copyright © 2018 Atul. All rights reserved.
//

import UIKit
import DropDown
import Stripe
import Alamofire
import PKHUD
import CCValidator

class IndividualUserVC: UIViewController, UITextFieldDelegate, STPPaymentCardTextFieldDelegate{
    var dropDownData:[String] = [];
    let customDropDown = DropDown()
    
    @IBOutlet weak var txtFieldForName: UITextField!
    @IBOutlet weak var cardDetailsView: UIView!
    @IBOutlet weak var viewForPackageType: UIView!
    @IBOutlet weak var lblforSelectedItem: UILabel!
    @IBOutlet weak var btnForSelectedItem: UIButton!
    @IBOutlet weak var individualPopView: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPackageType: UILabel!
    @IBOutlet weak var lblCard: UILabel!
    @IBOutlet weak var lblCardStatus: UILabel!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var btnIndividual: UIButton!
    @IBOutlet weak var btnCorporate: UIButton!
    @IBOutlet weak var viewForCorporate: UIView!
    @IBOutlet weak var txtFieldForNameC: UITextField!
    @IBOutlet weak var txtFieldForPromoCode: UITextField!
    @IBOutlet weak var lblTitleC: UILabel!
    @IBOutlet weak var lblNameC: UILabel!
    @IBOutlet weak var lblPromocode: UILabel!
    @IBOutlet weak var btnDoneC: UIButton!
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var lblPriceItem: UILabel!
    @IBOutlet weak var lblIndividual: UILabel!
    @IBOutlet weak var lblSubIndividual: UILabel!
    @IBOutlet weak var lblCorporate: UILabel!
    @IBOutlet weak var lblSibCorporate: UILabel!
    @IBOutlet weak var txtCardNo: UITextField!
    @IBOutlet weak var txtCardExMonth: UITextField!
    @IBOutlet weak var txtCardExYear: UITextField!
    @IBOutlet weak var txtCardCVC: UITextField!
    
    var accountType : String = "1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblCardStatus.isHidden = true
        
        self.txtFieldForName.layer.borderWidth = 2.0
        self.txtFieldForName.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        self.txtFieldForName.layer.cornerRadius = 2.0
        self.txtFieldForName.clipsToBounds = true
        self.txtFieldForName.delegate = self
        
        self.txtCardNo.delegate = self
        self.txtCardExMonth.delegate = self
        self.txtCardExYear.delegate = self
        self.txtCardCVC.delegate = self
        
        self.cardDetailsView.layer.borderWidth = 2.0
        self.cardDetailsView.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        cardDetailsView.layer.cornerRadius = 4.0
        self.cardDetailsView.layer.masksToBounds = true
        
        self.viewForPackageType.layer.borderWidth = 2.0
        self.viewForPackageType.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        viewForPackageType.layer.cornerRadius = 4.0
        
        self.hideKeyboardWhenTappedAround()
        
        Packages_service()
        fontSetup()
        
        lblIndividual.font = UIFont(name: "Lato-Bold", size: 14.0)
        lblSubIndividual.font = UIFont(name: "Lato-Bold", size: 12.0)
        lblCorporate.font = UIFont(name: "Lato-Regular", size: 14.0)
        lblSibCorporate.font = UIFont(name: "Lato-Regular", size: 12.0)
        
        btnIndividual.isSelected = true
        self.viewForCorporate.isHidden = true
        self.individualPopView.isHidden = false
        self.view.bringSubview(toFront: self.individualPopView)
        
        let leftSwipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(actionLeftSwipe))
        leftSwipe.direction = .right
        self.view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(actionRightSwipe))
        rightSwipe.direction = .left
        self.view.addGestureRecognizer(rightSwipe)
    }
    
    @objc func actionLeftSwipe(){
        actionIndividual(AnyClass.self)
    }
    
    @objc func actionRightSwipe(){
        actionCorporate(AnyClass.self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    func fontSetup(){
        lblTitle.font = FontBold18
        lblName.font = Font2Bold11
        lblPackageType.font = Font2Bold11
        lblCard.font = Font2Bold11
        lblCardStatus.font = Font2Bold11
        btnDone.titleLabel?.font = FontBold15
        
        lblTitleC.font = FontBold18
        lblNameC.font = Font2Bold11
        lblPromocode.font = Font2Bold11
        btnDoneC.titleLabel?.font = FontBold15
    }
    
    var CardToken : String = ""
    func validation() -> Bool {
        if txtFieldForName.text?.condenseWhitespace() != "" {
            if packageSelected {
                let packageID : String = PackageArray[packageIndex]._id!
                if packageID != "" {
                    let isFullCardDataOK = CCValidator.validate(creditCardNumber: txtCardNo.text! as String)
                    if isFullCardDataOK{
                        return true
                    }else{
                        if txtCardNo.text?.condenseWhitespace() != "" {
                            self.showErrorToast(message: "Please add a valid card details.", backgroundColor: UIColor.red)
                        }else{
                            self.showErrorToast(message: "Please add a card details.", backgroundColor: UIColor.red)
                        }
                    }
                } else {
                    self.showErrorToast(message: "Please select package.", backgroundColor: UIColor.red)
                }
            }else {
                self.showErrorToast(message: "Please select package.", backgroundColor: UIColor.red)
            }
            
        }else {
            self.showErrorToast(message: "Please enter your name.", backgroundColor: UIColor.red)
        }
        return false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionForDropDown(_ sender: UIButton) {
        customDropDown.show()
        print("Hii")
    }
    
    //MARK: Dropdown setup
    func setupDefaultDropDown() {
        customDropDown.cellNib = UINib(nibName: "MyCell", bundle: nil)
        for T in PackageArray {
            dropDownData.append(T.name!)
        }
        
        customDropDown.dataSource = dropDownData
        customDropDown.anchorView = viewForPackageType
        customDropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            guard let cell = cell as? MyCell else { return }
            
            // Setup your custom UI components
            cell.suffixLabel.text = "$" + self.PackageArray[index].value!
            cell.suffixLabel.textAlignment = .right
            cell.optionLabel.text = self.dropDownData[index].capitalized
            cell.optionLabel.textAlignment = .left
        }
        
        customDropDown.direction = .bottom
        customDropDown.dismissMode = .automatic
        
        customDropDown.bottomOffset = CGPoint(x: 0, y: (customDropDown.anchorView?.plainView.bounds.height)!)
        customDropDown.selectionAction = { [unowned self] (index, item) in
            self.packageSelected = true
            self.packageIndex = index
            self.lblforSelectedItem.text = self.PackageArray[index].name?.capitalized
            self.lblPriceItem.text = "$" + self.PackageArray[index].value!
        }
        
        customDropDown.cancelAction = { [unowned self] in
        }
    }
    
    var packageSelected : Bool = false
    var packageIndex : Int = 0
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //MARK: ActionOn outtesls
    var userID: String = ""
    @IBAction func ActionOnbtnDone(_ sender: UIButton) {
        self.view.endEditing(true)
        if validation(){
            if validateYearAndMonthAndCVC(){
                let dictionary : [String : String] = ["number":txtCardNo.text!,"expMonth":txtCardExMonth.text!,"expYear":txtCardExYear.text!,"cvc":txtCardCVC.text!]
                let getjsonString = getJsonString(jsonDict: dictionary)
                self.getJsonData(jsonSrting: getjsonString)
            }
        }
    }
    
    @IBAction func actionIndividual(_ sender: Any) {
        accountType = "1"
        if !btnIndividual.isSelected{
            lblIndividual.font = UIFont(name: "Lato-Bold", size: 14.0)
            lblSubIndividual.font = UIFont(name: "Lato-Bold", size: 12.0)
            lblCorporate.font = UIFont(name: "Lato-regular", size: 14.0)
            lblSibCorporate.font = UIFont(name: "Lato-regular", size: 12.0)
            btnCorporate.isSelected = false
            btnIndividual.isSelected = true
            self.individualPopView.isHidden = false
            self.viewForCorporate.isHidden = true
            self.view.bringSubview(toFront: self.individualPopView)
        }
    }
    
    @IBAction func actionCorporate(_ sender: Any) {
        accountType = "2"
        if !btnCorporate.isSelected{
            lblIndividual.font = UIFont(name: "Lato-Regular", size: 14.0)
            lblSubIndividual.font = UIFont(name: "Lato-Regular", size: 12.0)
            lblCorporate.font = UIFont(name: "Lato-Bold", size: 14.0)
            lblSibCorporate.font = UIFont(name: "Lato-Bold", size: 12.0)
            
            btnIndividual.isSelected = false
            btnCorporate.isSelected = true
            self.viewForCorporate.isHidden = false
            self.individualPopView.isHidden = true
            self.view.bringSubview(toFront: self.viewForCorporate)
        }
    }
    
    //MARK: pakcages
    var PackageArray : [Package_Base] = []
    func Packages_service(){
        let  headers: HTTPHeaders = ["Content-Type": "application/json","authorization": "asdfasfasfas"]
        MasterWebService.sharedInstance.GET_WithHeaderCustom_webservice(Url:  EndPoints.package_URL, prm: nil ,header: headers,background:false,completion: {_result,_statusCode in
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
                        
                        let data : NSArray = Responsedata.value(forKey: "data") as! NSArray
                        print(data)
                        self.PackageArray =  Package_Base.modelsFromDictionaryArray(array: data)
                        self.setupDefaultDropDown()
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
    
    //MARK: individual user registration api
    func Individual_signUP(userId: String,name: String,PackageIndex: Int, Card: String, cardDetail: String){
        let package: String = PackageArray[packageIndex]._id!
        let type: Int = 1
        let prm:Parameters  = ["userId": userId,
                               "name": name,
                               "packageId": package,
                               "cardToken": Card,
                               "accountType": type,
                               "cardDetail": cardDetail]
        let  headers: HTTPHeaders = ["Content-Type": "application/json"]
        MasterWebService.sharedInstance.PUT_WithHeaderCustom_webservice(Url: EndPoints.Complete_registration_URL, prm: prm, header: headers,  background: false,completion: { _result,_statusCode in
            print(_result)
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
            }else{
                self.showErrorToast(message: "Somthing went wrong.", backgroundColor: UIColor.red)
            }
        })
    }
    
    func NavigateToHome(){
        appDelegate.createCustomTabBar()
        appDelegate.window?.rootViewController = appDelegate.TabbarCustomMain
    }
    
    @IBAction func ActionOnbtnDoneC(_ sender: UIButton) {
        self.view.endEditing(true)
        print(userID)
        if  userID != "" {
            if validationC(){
                self.corporate_signUP(userId: userID, name: (txtFieldForNameC.text?.condenseWhitespace())!, promocode: (txtFieldForPromoCode.text?.condenseWhitespace())!)
            }
        }else {
            self.showErrorToast(message: "User ID not exist.", backgroundColor: UIColor.red)
        }
    }
    
    func validationC() -> Bool {
        if txtFieldForNameC.text?.condenseWhitespace() != "" {
            if txtFieldForPromoCode.text?.condenseWhitespace() != "" {
                let promocode :String = (txtFieldForPromoCode.text?.condenseWhitespace())!
                return true
            } else {
                self.showErrorToast(message: "Please enter your promocode.", backgroundColor: UIColor.red)
            }
        } else {
            self.showErrorToast(message: "Please enter your name.", backgroundColor: UIColor.red)
        }
        return false
    }
    
    func corporate_signUP(userId: String,name: String,promocode: String){
        let type: Int = 2
        let prm:Parameters  = ["userId": userId,
                               "name": name,
                               "promoCode": promocode,
                               "accountType": type
        ]
        print(prm)
        let  headers: HTTPHeaders = ["Content-Type": "application/json"]
        MasterWebService.sharedInstance.PUT_WithHeaderCustom_webservice(Url: EndPoints.Complete_registration_URL, prm: prm, header: headers,  background: false,completion: { _result,_statusCode in
            if _statusCode == 200 {
                if _result is NSDictionary {
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
                }
            }else{
                self.showErrorToast(message: "Somthing went wrong.", backgroundColor: UIColor.red)
            }
        })
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
                                self.showErrorToast(message: "Please enter valid card CVC.", backgroundColor: UIColor.red)
                            }
                        }else{
                            self.showErrorToast(message: "Please enter card CVC.", backgroundColor: UIColor.red)
                        }
                    }else{
                        self.showErrorToast(message: "Please enter valid card expiry year.", backgroundColor: UIColor.red)
                    }
                }else{
                    self.showErrorToast(message: "Please enter card expiry year.", backgroundColor: UIColor.red)
                }
            }else{
                self.showErrorToast(message: "Please enter valid card expiry month.", backgroundColor: UIColor.red)
            }
        }else{
            self.showErrorToast(message: "Please enter card expiry month.", backgroundColor: UIColor.red)
        }
        return false
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
                
                self.Individual_signUP(userId: self.userID, name: (self.txtFieldForName.text?.condenseWhitespace())! , PackageIndex:self.packageIndex, Card: "", cardDetail: encryptedPassword!)
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == self.txtCardNo{
            let newLength = (textField.text?.utf16.count)! + string.utf16.count - range.length
            if newLength <= 16 {
                return true
            } else {
                return false
            }
        }else if textField == self.txtCardExMonth{
            let newLength = (textField.text?.utf16.count)! + string.utf16.count - range.length
            if newLength <= 2 {
                return true
            } else {
                return false
            }
        }else if textField == self.txtCardExYear || textField == self.txtCardCVC{
            let newLength = (textField.text?.utf16.count)! + string.utf16.count - range.length
            if newLength <= 4 {
                return true
            } else {
                return false
            }
        }else{
            return true
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
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
