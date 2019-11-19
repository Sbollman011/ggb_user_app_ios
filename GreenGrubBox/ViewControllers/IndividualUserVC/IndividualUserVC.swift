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
    
    var accountType : String = "1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblCardStatus.isHidden = true
        
        self.txtFieldForName.layer.borderWidth = 2.0
        self.txtFieldForName.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        self.txtFieldForName.layer.cornerRadius = 2.0
        self.txtFieldForName.clipsToBounds = true
        self.txtFieldForName.delegate = self as UITextFieldDelegate
        
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
        StripeCardSetup()
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
    
    func StripeCardSetup(){
        for vi in cardDetailsView.subviews{
            vi.removeFromSuperview()
        }
        paymentCardTextField.frame = CGRect(x: 0, y: 0, width: cardDetailsView.frame.width, height: cardDetailsView.frame.height)
        paymentCardTextField.font = FontBold15
        paymentCardTextField.delegate = self
        cardDetailsView.addSubview(paymentCardTextField)
    }
    
    // MARK: STPPaymentCardTextFieldDelegate
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        print(textField.isValid)
        if textField.isValid {
            lblCardStatus.isHidden = false
            lblCardStatus.text = "This card is valid"
            lblCardStatus.textColor = appDelegate.uicolorFromHex(rgbValue: 0x41BC40)
            lblCardStatus.textAlignment = .right
            
        }else {
            lblCardStatus.isHidden = false
            lblCardStatus.text = "This card is not valid"
            lblCardStatus.textColor = UIColor.red
            lblCardStatus.textAlignment = .right
            
        }
        if textField.hasText == false {
            lblCardStatus.isHidden = true
        }
    }
    
    //MARK: custom card adding
    func GeTTkenFromStripe(){
        HUD.show(.progress)
        STPAPIClient.shared().createToken( withCard: paymentCardTextField.cardParams) { (token: STPToken?, error: Error?) in
            guard let token = token, error == nil else {
                // Present error to user...
                print(error ?? "Nothing")
                // print(token)
                self.showErrorToast(message:(error?.localizedDescription)! , backgroundColor: UIColor.red)
                HUD.hide()
                return
            }
            print(token.description)
            print(token.tokenId)
            self.CardToken =  token.description
            HUD.hide()
            if self.validation() {
                self.Individual_signUP(userId: self.userID, name: (self.txtFieldForName.text?.condenseWhitespace())! , PackageIndex:self.packageIndex, Card: self.CardToken)
            }
        }
    }
    
    var CardToken : String = ""
    func validation() -> Bool {
        if txtFieldForName.text?.condenseWhitespace() != "" {
            if packageSelected {
                let packageID : String = PackageArray[packageIndex]._id!
                if packageID != "" {
                    if paymentCardTextField.isValid {
                        return true
                    }else {
                        self.showErrorToast(message: "Please add a valid card details.", backgroundColor: UIColor.red)
                    }
                    return true
                }else {
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
    }
    
    @IBAction func actionForDropDown(_ sender: UIButton) {
        customDropDown.show()
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
            print("here is the resulte")
            
        }
        
        customDropDown.cancelAction = { [unowned self] in
            print("here is the Cancel resulte")
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
    let paymentCardTextField = STPPaymentCardTextField()
    @IBAction func ActionOnbtnDone(_ sender: UIButton) {
        self.view.endEditing(true)
        if validation(){
            if paymentCardTextField.cardParams.cvc != "" {
                if paymentCardTextField.isValid {
                    GeTTkenFromStripe()
                }else {
                    self.showErrorToast(message: "Card is not valid.", backgroundColor: UIColor.red)
                }
            }else {
                self.showErrorToast(message: "Please enter card details.", backgroundColor: UIColor.red)
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
    func Individual_signUP(userId: String,name: String,PackageIndex: Int,Card: String){
        let package: String = PackageArray[packageIndex]._id!
        let type: Int = 1
        let prm:Parameters  = ["userId": userId,
                               "name": name,
                               "packageId": package,
                               "cardToken": Card,
                               "accountType": type]
        
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
        } else {
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
                               "accountType": type]
        
        let  headers: HTTPHeaders = ["Content-Type": "application/json"]
        MasterWebService.sharedInstance.PUT_WithHeaderCustom_webservice(Url: EndPoints.Complete_registration_URL, prm: prm, header: headers,  background: false,completion: { _result,_statusCode in
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
