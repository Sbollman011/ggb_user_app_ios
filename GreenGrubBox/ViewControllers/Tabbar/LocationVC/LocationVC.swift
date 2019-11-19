//
//  LocationVC.swift
//  GreenGrubBox
//
//  Created by Ankit on 1/31/18.
//  Copyright © 2018 Ankit. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire
import SDWebImage

class LocationVC: UIViewController,UITextFieldDelegate, MKMapViewDelegate,CLLocationManagerDelegate,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var View_table: UIView!
    @IBOutlet weak var tbl_vendors: UITableView!
    
    //MARK: outlets
    var VendorsList :[VendorsModel] = []
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnHomeLocator: UIButton!
    @IBOutlet weak var Map: MKMapView!
    @IBOutlet weak var view_searchbox: UIView!
    @IBOutlet weak var txt_search: UITextField!
    @IBOutlet weak var constraint_leadingSearchBox: NSLayoutConstraint!
    
    @IBOutlet weak var constantFromLocationBtn: NSLayoutConstraint!
    @IBOutlet weak var constraint_tblbottom: NSLayoutConstraint!
    
    //MARK: CATEGORY SELECTION OUTLETS
    @IBOutlet weak var View_Category: UIView!
    @IBOutlet weak var lbl_Vender: UILabel!
    @IBOutlet weak var lbl_Dropbox: UILabel!
    @IBOutlet weak var lbl_Both: UILabel!
    @IBOutlet weak var btn_Vender: UIButton!
    @IBOutlet weak var btn_DropBox: UIButton!
    @IBOutlet weak var btn_Both: UIButton!
    @IBOutlet weak var img_MenuBtn: UIImageView!
    
    var cosntratinrecord : CGFloat = 68
    var searchenable : Bool = false
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        constraint_leadingSearchBox.isActive = false
        img_MenuBtn.image = UIImage(named:"Home_menu")
        constantFromLocationBtn.isActive = true
        searchenable = false
        View_table.isHidden = true
        tbl_vendors.isHidden = true
        Map.isHidden = false
        self.view.bringSubview(toFront: Map)
        txt_search.text = ""
        
        constraint_tblbottom.constant = 70
        txt_search.delegate = self
        self.txt_search.addTarget(self, action: #selector(LocationVC.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        
        // Do any additional setup after loading the view.
        view_searchbox.layer.cornerRadius = 5
        view_searchbox.layer.masksToBounds = true
        view_searchbox.layer.borderColor = UIColor.white.cgColor
        view_searchbox.layer.borderWidth = 1
        
        tbl_vendors.delegate = self
        tbl_vendors.dataSource = self
        tbl_vendors.register(UINib(nibName: "VendorCell", bundle: nil), forCellReuseIdentifier: "VendorCell")
        
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.requestLocation()
            self.locationManager.startUpdatingLocation()
        }
        
        self.Map.delegate = self
        fontSetup()
        
        // Pull to refresh
        refreshControl.tintColor = appDelegate.uicolorFromHex(rgbValue: 0x7CD141)
        self.tbl_vendors.addSubview(self.refreshControl)
        self.refreshControl.addTarget(self, action: #selector(LocationVC.handleRefresh(refreshControl:)), for:  UIControlEvents.valueChanged)
    }
    
    func fontSetup(){
        btn_Vender.titleLabel?.font = Font2Bold11
        btn_DropBox.titleLabel?.font = Font2Bold11
        btn_Both.titleLabel?.font = Font2Bold11
    }
    
    @objc func callback() {
        self.User_HomeVendorsList(callInBG:false )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true )
        currentPage = 1
        PageSize = 20
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        if Onslider == true  {
            Onslider = false
        }else {
            self.vendorsArray.removeAll()
            self.Search_vendorsArray.removeAll()
            
            Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(callback), userInfo: nil, repeats: false)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
    }
    
    //MARK: - getKayboardHeight
    @objc func keyboardWillShow(notification: Notification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle: CGRect = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        print("keyboad notificaiton",keyboardFrame,keyboardHeight)
        constraint_tblbottom.constant = keyboardHeight
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        constraint_tblbottom.constant = 70
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        txt_search.text = ""
        searchenable = false
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true )
        view_searchbox.layer.cornerRadius = 5
        view_searchbox.layer.masksToBounds = true
        view_searchbox.layer.borderColor = UIColor.white.cgColor
        view_searchbox.layer.borderWidth = 1
        
        constraint_leadingSearchBox.isActive = false
        img_MenuBtn.image = UIImage(named:"Home_menu")
        constantFromLocationBtn.isActive = true
        searchenable = false
        View_table.isHidden = true
        tbl_vendors.isHidden = true
        Map.isHidden = false
        self.view.bringSubview(toFront: Map)
        txt_search.text = ""
        
        searchenable = false
    }
    
    var PictureSlider : Bool = false
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        if PictureSlider == false  {
            if popUpVisible{
                RemovePopUp()
            }
        }else {
            PictureSlider = false
        }
        constraint_leadingSearchBox.isActive = false
        img_MenuBtn.image = UIImage(named:"Home_menu")
        constantFromLocationBtn.isActive = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Actions on outlets
    @IBAction func ActionOnbtnHomeLocator(_ sender: UIButton) {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                self.askForPermission()
                return
            case .authorizedAlways, .authorizedWhenInUse:
                let center = CLLocationCoordinate2D(latitude: User_Latitute, longitude: User_Langitute)
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
                self.Map.setRegion(region, animated: true)
            }
        } else {
            askForPermission()
        }
    }
    
    func askForPermission(){
        let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
    @IBAction func ActionOnbtnMenu(_ sender: Any) {
        
        if popUpVisible{
            RemovePopUp()
        }
        
        if  View_table.isHidden{
            constraint_leadingSearchBox.isActive = true
            img_MenuBtn.image = UIImage(named:"list_btn_icon")
            constantFromLocationBtn.isActive = false
            searchenable = false
            View_table.isHidden = false
            tbl_vendors.isHidden = false
            View_table.backgroundColor = UIColor.white
            self.view.bringSubview(toFront: View_table)
        }else {
            constraint_leadingSearchBox.isActive = false
            img_MenuBtn.image = UIImage(named:"Home_menu")
            constantFromLocationBtn.isActive = true
            searchenable = false
            View_table.isHidden = true
            tbl_vendors.isHidden = true
            Map.isHidden = false
            self.view.bringSubview(toFront: Map)
            txt_search.text = ""
            self.view.endEditing(true)
        }
    }
    
    func showListView(){
    }
    
    @IBAction func ActionOnbtnVender(_ sender: UIButton) {
        self.CategorySelection(sender: 0)
    }
    
    @IBAction func ActionOnbtnDropBox(_ sender: UIButton) {
        self.CategorySelection(sender:1)
    }
    
    @IBAction func ActionOnbtnBoth(_ sender: UIButton) {
        self.CategorySelection(sender: 2)
    }
    
    var Categories: Int = 1
    func CategorySelection(sender : Int){
        switch sender
        {
        case 0:
            btn_Vender.isSelected = true
            btn_DropBox.isSelected = false
            btn_Both.isSelected = false
            lbl_Vender.isHidden = false
            lbl_Dropbox.isHidden = true
            lbl_Both.isHidden = true
            Categories = 1
            break;
        case 1:
            btn_Vender.isSelected = false
            btn_DropBox.isSelected = true
            btn_Both.isSelected = false
            lbl_Vender.isHidden = true
            lbl_Dropbox.isHidden = false
            lbl_Both.isHidden = true
            Categories = 2
            break;
        case 2:
            btn_Vender.isSelected = false
            btn_DropBox.isSelected = false
            btn_Both.isSelected = true
            lbl_Vender.isHidden = true
            lbl_Dropbox.isHidden = true
            lbl_Both.isHidden = false
            Categories = 3
            break;
        default:
            btn_Vender.isSelected = true
            btn_DropBox.isSelected = false
            btn_Both.isSelected = false
            lbl_Vender.isHidden = false
            lbl_Dropbox.isHidden = true
            lbl_Both.isHidden = true
            Categories = 1
            break;
        }
        currentPage = 1
        PageSize  = 20
        isMore = false
        self.view.endEditing(true)
        txt_search.text = ""
        searchenable = false
        self.vendorsArray.removeAll()
        self.tbl_vendors.reloadData()
        User_HomeVendorsList(callInBG: false)
        
        if popUpVisible{
            RemovePopUp()
        }
    }
    
    //MARK: UITextField delegate
    var Searchtimer: Timer?
    @objc func textFieldDidChange(_ textField:UITextField){
        
        let searchTextString : NSString! = textField.text as NSString!
        if ((searchTextString.length  > 0 || searchTextString != nil || searchTextString == "") == true)
        {
            searchenable = true
            print(textField.text)
            Searchtimer?.invalidate()
            self.Searchtimer = Timer.scheduledTimer(timeInterval: 0.90, target: self, selector: #selector(LocationVC.CallSearch), userInfo: nil, repeats: false)
        }
    }
    
    @objc func CallSearch(){
        Searchtimer?.invalidate()
        if (txt_search.text != ""){
            self.Search_vendorsArray.removeAll()
            self.tbl_vendors.reloadData()
            self.currentPage = 1
            self.User_Home_Search_VendorsList(SearchText: txt_search.text as! String)
        }else{
            searchenable = false
            self.tbl_vendors.reloadData()
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool // return NO to disallow editing.
    {
      return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) // became first responder
    {
        RemovePopUp()
        constraint_leadingSearchBox.isActive = true
        img_MenuBtn.image = UIImage(named:"list_btn_icon")
        constantFromLocationBtn.isActive = false
        searchenable = true
        View_table.isHidden = false
        tbl_vendors.isHidden = false
        View_table.backgroundColor = UIColor.white
        self.view.bringSubview(toFront: View_table)
        self.Search_vendorsArray.removeAll()
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
    {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
    {
        if   View_table.isHidden {
            constraint_leadingSearchBox.isActive = false
            img_MenuBtn.image = UIImage(named:"Home_menu")
            constantFromLocationBtn.isActive = true
            txt_search.text = ""
            searchenable = false
            self.tbl_vendors.reloadData()
        }else{
            if  self.txt_search.text == "" {
                searchenable = false
                self.tbl_vendors.reloadData()
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool // return NO to not change text
    {
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool // called when clear button pressed. return NO to ignore (no notifications)
    {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        return  false
    }
    
    //MARK: UITableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchenable {
            return Search_vendorsArray.count
        }else {
            return vendorsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VendorCell", for: indexPath) as! VendorCell
        if searchenable {
            if Search_vendorsArray.count != 0 {
                cell.lbl_name.text =  Search_vendorsArray[indexPath.row].Name
                var img : String =  ""
                let imgArr = Search_vendorsArray[indexPath.row].Images
                if imgArr.count > 0 {
                    img = imgArr[0] as String
                }
                if img != "" {
                    let url = URL.init(string:img)
                    cell.img_vendor.sd_setImage(with: url , placeholderImage: UIImage(named: "popUp_default_user.png"))
                }
                cell.lbl_type.text =   Search_vendorsArray[indexPath.row].category
                cell.lbl_distance.text =  Search_vendorsArray[indexPath.row].miles
                cell.img_vendor.layer.cornerRadius =   cell.img_vendor.frame.height / 2
                cell.img_vendor.layer.masksToBounds = true
                cell.img_vendor.layer.borderColor = UIColor.clear.cgColor
                cell.img_vendor.layer.borderWidth = 1
                if (indexPath.row == Search_vendorsArray.count - 1){
                    if (isMore == true){
                        if Categories != 3 {
                            self.SearchLoadMore()
                        }
                    }
                }
            }else{
            }
        } else {
            if vendorsArray.count != 0 {
                cell.lbl_name.text =  vendorsArray[indexPath.row].Name
                var img : String = ""
                let imgArr = vendorsArray[indexPath.row].Images
                if imgArr.count > 0 {
                    img = imgArr[0] as String
                }
                if img != "" {
                    let url = URL.init(string:img)
                    cell.img_vendor.sd_setImage(with: url , placeholderImage: UIImage(named: "popUp_default_user.png"))
                }
                cell.lbl_type.text =   vendorsArray[indexPath.row].category
                cell.lbl_distance.text =  vendorsArray[indexPath.row].miles
                cell.img_vendor.layer.cornerRadius =   cell.img_vendor.frame.height / 2
                cell.img_vendor.layer.masksToBounds = true
                cell.img_vendor.layer.borderColor = UIColor.clear.cgColor
                cell.img_vendor.layer.borderWidth = 1
                if (indexPath.row == vendorsArray.count - 1){
                    if (isMore == true){
                        if Categories != 3 {
                            self.LoadMore()
                        }
                    }
                }
            }else {
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    var PickerD: LocationPopView = LocationPopView()
    var PickerD_data: Vendors_Base = Vendors_Base.init(dictionary: NSDictionary())!
    var popUpVisible: Bool = false
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        print(searchenable)
        if searchenable  == true {
            self.ShowSelectedPopUP(data:Search_vendorsArray[indexPath.row], Formap: false)
        }else {
            self.ShowSelectedPopUP(data:vendorsArray[indexPath.row], Formap: false)
        }
    }
    
    @objc func WebTaped(){
        if PickerD_data.webLink != "" {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(NSURL(string:PickerD_data.webLink)! as URL)
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    @objc func YelpTaped(){
        print("LOcationvc YelpTaped",PickerD_data.yelpLink)
        if PickerD_data.yelpLink != "" {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(NSURL(string:PickerD_data.yelpLink)! as URL)
            } else {
                
            }
        }
    }
    
    var fromMap : Bool = false
    @objc func RemovePopUp(){
        PicArrayOFpopUP = []
        PickerD.removeFromSuperview()
        PickerD.fadeIn()
        popUpVisible = false
        if fromMap == true  {
            View_table.isHidden = true
        }
        if   View_table.isHidden == false {
        }else {
            View_table.isHidden = true
        }
    }
    
    var PicArrayOFpopUP: [String] = []
    var Onslider : Bool = false
    @objc func PopMainImageSelection(){
        if PicArrayOFpopUP.count != 0 {
            let slidervc : SliderMediaVC = storyboard?.instantiateViewController(withIdentifier: "SliderMediaVC") as! SliderMediaVC
            slidervc.PictureMedia = PicArrayOFpopUP
            PictureSlider = true
            Onslider = true
            self.present(slidervc, animated: true, completion: nil)
        }else {
        }
    }
    
    //MARK: map setup and devlopem,ent
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        User_Latitute = location!.coordinate.latitude
        User_Langitute = location!.coordinate.longitude
        if upldate_UserMap == false {
            upldate_UserMap = true
            let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
            self.Map.setRegion(region, animated: true)
        }
    }
    
    var upldate_UserMap : Bool = false
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Errors " + error.localizedDescription)
    }
    
    //MARK: Map view delegate
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        print(view.tag)
        mapView.deselectAnnotation(view.annotation, animated: true)
        let  selectedAnnotation :Location = (view.annotation as? Location)!
        let PinDict: NSDictionary = selectedAnnotation.infoDict!
        let Pindata: Vendors_Base = Vendors_Base.init(dictionary: PinDict)!
        self.ShowSelectedPopUP(data:Pindata, Formap: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        } else {
            let annotationView : MKAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
            let  selectedAnnotation:Location  = (annotation as? Location)!
            let vdata : Vendors_Base = Vendors_Base.init(dictionary: selectedAnnotation.infoDict!)!
            if  vdata.type  == 1 {
                annotationView.image = UIImage(named: "green_circle")
            }else if  vdata.type  == 2{
                annotationView.image = UIImage(named: "Home_drop")
            }else{
                annotationView.image = UIImage(named: "green_circle")
            }
            return annotationView
        }
    }
    
    //MARK: Vendors webservicecalling
    var currentPage : Int = 1
    var PageSize : Int = 20
    var isMore: Bool = false
    var vendorsArray: [Vendors_Base] = []
    var Search_vendorsArray: [Vendors_Base] = []
    //Pull to refresh
    let refreshControl = UIRefreshControl()
    
    func SearchLoadMore(){
        if isMore == true
        {
            currentPage = currentPage + 1
            PageSize = 20
            if searchenable {
                if (txt_search.text?.condenseWhitespace() != ""){
                    self.User_Home_Search_VendorsList(SearchText: txt_search.text?.condenseWhitespace() as! String)
                }
            }
        }
    }
    
    func LoadMore(){
        if isMore == true
        {
            currentPage = currentPage + 1
            PageSize = 20
            User_HomeVendorsList(callInBG: false)
        }
    }
    
    func PullToRefresh(){
        isMore = false
        currentPage =  1
        PageSize = 20
        if searchenable {
            if (txt_search.text?.condenseWhitespace() != ""){
                self.Search_vendorsArray.removeAll()
                self.tbl_vendors.reloadData()
                self.User_Home_Search_VendorsList(SearchText: txt_search.text?.condenseWhitespace() as! String)
            }
        }else{
            self.vendorsArray.removeAll()
            self.tbl_vendors.reloadData()
            User_HomeVendorsList(callInBG:true)
        }
    }
    // MARK:pull to refresh
    @objc func handleRefresh(refreshControl: UIRefreshControl) {
        PullToRefresh()
        refreshControl.endRefreshing()
    }
    
    func User_HomeVendorsList(callInBG:Bool){
        let  headers: HTTPHeaders = ["Content-Type": "application/json","authorization": LoginToken]
        print(headers)
        print("Request URL : ",EndPoints.User_Vendors_URL + "?currentPage=\(currentPage)&pageSize=\(PageSize)&lat=\(User_Latitute)&long=\(User_Langitute)&type=\(Categories)");
        MasterWebService.sharedInstance.GET_WithHeaderCustom_webservice(Url:  EndPoints.User_Vendors_URL + "?currentPage=\(currentPage)&pageSize=\(PageSize)&lat=\(User_Latitute)&long=\(User_Langitute)&type=\(Categories)" , prm: nil ,header: headers,background:callInBG,completion: {_result,_statusCode in
            
            if _statusCode == 200 {
                if _result is NSDictionary {
                    print("dict")
                    print(_result)
                    let Responsedata: NSDictionary = _result as! NSDictionary
                    print("resp========User_Vendors_URL ",Responsedata)
                    let status : Int =  Responsedata.value(forKey: "status") as! Int
                    if status == 0 {
                        let message : String = Responsedata.value(forKey: "message") as! String
                        self.showAlert(withTitle: "Message", message:  "\(message)")
                    }else if status == 1 {
                        //print("Vendors response >>>>>>",Responsedata)
                        
                        if Responsedata.value(forKey: "isMore") != nil {
                            self.isMore = Responsedata.value(forKey: "isMore")  as! Bool
                        }else {
                            self.isMore = false
                        }
                        let Data: NSArray = Responsedata.value(forKey: "data")  as! NSArray
                        if self.vendorsArray.count != 0 {
                            self.vendorsArray =  self.vendorsArray + Vendors_Base.modelsFromDictionaryArray(array: Data)
                        }else {
                            self.vendorsArray = Vendors_Base.modelsFromDictionaryArray(array: Data)
                        }
                        self.ShowOverMap()
                    }
                }else{
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
    
    //MARK: search overvendors
    func User_Home_Search_VendorsList(SearchText:String){
        let  headers: HTTPHeaders = ["Content-Type": "application/json","authorization": LoginToken]
        print(headers)
        print("ravi is here " + SearchText)
        print("Request Final URL after search : "+EndPoints.User_Vendors_URL + "?currentPage=\(currentPage)&pageSize=\(PageSize)&search=" + SearchText + "&lat=\(User_Latitute)&long=\(User_Langitute)&type=\(Categories)")
        MasterWebService.sharedInstance.GET_WithHeaderCustom_webservice(Url:  EndPoints.User_Vendors_URL + "?currentPage=\(currentPage)&pageSize=\(PageSize)&search=" + SearchText + "&lat=\(User_Latitute)&long=\(User_Langitute)&type=\(Categories)" , prm: nil ,header: headers,background:false,completion: {_result,_statusCode in
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
                        if Responsedata.value(forKey: "isMore") != nil {
                            self.isMore = Responsedata.value(forKey: "isMore")  as! Bool
                        }else {
                            self.isMore = false
                        }
                        let Data: NSArray = Responsedata.value(forKey: "data")  as! NSArray
                        if self.Search_vendorsArray.count != 0 {
                            self.Search_vendorsArray =  self.Search_vendorsArray + Vendors_Base.modelsFromDictionaryArray(array: Data)
                        }else {
                            self.Search_vendorsArray = Vendors_Base.modelsFromDictionaryArray(array: Data)
                        }
                        self.tbl_vendors.reloadData()
                    }
                }else{
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
    
    //MARK: Helper funtions
    func  ShowOverMap(){
        self.tbl_vendors.reloadData()
        let allAnnotations = self.Map.annotations
        Map.removeAnnotations(allAnnotations)
        var name: String = ""
        var lat : Double = 0.0
        var long : Double = 0.0
        for i:Vendors_Base in vendorsArray {
            name = i.businessName
            long = (i.geo?.coordinates[0])!
            lat = (i.geo?.coordinates[1])!
            let sikkim = Location(title: name, coordinate: CLLocationCoordinate2D(latitude:lat, longitude:long), tag: 0, infoDict: i.dictionaryRepresentation())
            Map.addAnnotation(sikkim)
        }
        Map.reloadInputViews()
    }
    
    //MARK: Show popup
    func ShowSelectedPopUP(data: Vendors_Base,Formap: Bool){
        if popUpVisible == false {
            self.view.endEditing(true)
            popUpVisible = true
            
            PickerD = LocationPopView().instanceFromNib() as! LocationPopView
            PickerD.frame = CGRect(x: 0, y: 0, width: View_table.frame.width, height: View_table.frame.height)
            let Pindata: Vendors_Base = data
            PickerD_data = data
            PickerD.lblName.text = Pindata.Name
            PickerD.lblMenu.text = Pindata.category
            PickerD.ShowYelp()
            PickerD.ShowWeb()
            PicArrayOFpopUP = Pindata.Images
            var img: String =  ""
            if Pindata.type == 2 {
                PickerD.HideYelp()
                PickerD.view_rating.isHidden = true
            }else{
                PickerD.ShowYelp()
            }
            if PicArrayOFpopUP.count > 0 {
                img  = PicArrayOFpopUP[0] as String
            }
            if img != "" {
                let url = URL.init(string:img)
                PickerD.imgVendor.sd_setImage(with: url , placeholderImage: UIImage(named: "popUp_default_user.png"))
                print(img)
            }
            let Rating: Float = Pindata.rating
            print(Rating)
            PickerD.SetRating(rating: Rating)
            PickerD.lblAddress.text = Pindata.address?.formattedAddress
            PickerD.Text_Details.text = Pindata.description
            
            PickerD.btnImgMain.addTarget(self, action: #selector(LocationVC.PopMainImageSelection), for: .touchUpInside)
            PickerD.btn_Web.addTarget(self, action: #selector(LocationVC.WebTaped), for: .touchUpInside)
            PickerD.btn_Yelp.addTarget(self, action: #selector(LocationVC.YelpTaped), for: .touchUpInside)
            PickerD.btncross.addTarget(self, action: #selector(LocationVC.RemovePopUp), for: .touchUpInside)
            
            View_table.addSubview(PickerD)
            View_table.bringSubview(toFront: PickerD)
            if Formap {
                View_table.backgroundColor = UIColor.clear
                View_table.isHidden = false
                tbl_vendors.isHidden = true
                fromMap = true
            }else {
                View_table.backgroundColor = UIColor.white
                View_table.isHidden = false
                tbl_vendors.isHidden = false
                fromMap = false
            }
            self.view.bringSubview(toFront: View_table)
            PickerD.fadeIn()
        }
    }
}

import Foundation
import MapKit
class Location: NSObject, MKAnnotation {
    var title: String?
    var infoDict : NSDictionary?
    var coordinate: CLLocationCoordinate2D
    var tag : Int?
    init(title: String, coordinate: CLLocationCoordinate2D,tag: Int,infoDict : NSDictionary) {
        self.title = title
        self.coordinate = coordinate
        self.tag = tag
        self.infoDict = infoDict
    }
}

