

import Foundation
import UIKit
import Alamofire
import PKHUD

open class MasterWebService: UIViewController{
    
    override open func viewDidLoad() {
        super.viewDidLoad()
    }
    
    open class var sharedInstance : MasterWebService {
        struct MasterWebServiceInstanc {
            static let instance = MasterWebService()
        }
        return MasterWebServiceInstanc.instance
    }
    
    //MARK: Validations
    // validation for password
    func isValidPassword(password: String) -> Bool
    {
        let passwordRegex  = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[!@#$%^&*()])(?=.*?[0-9]).{3,32}"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
    }
    
    // validation for email
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    // validation for user name length
    func checkUserNameLength (testStr:String) -> Bool{
        let usrNam = testStr.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if (usrNam.characters.count) < 16 &&  (usrNam.characters.count) > 5  {
            return true
        }else{
            self.showErrorToast(message: "User name bust be less then 15 and greter then 6 latters!" , duration: 2000,backgroundColor: UIColor.red)
            return false
        }
        
    }
    
    //MARK: recability cheks
    let reachability = Reach()
    func Check_networkConnection() ->Bool {
        if isReachable(){
            return true
        }else {
            Notreachable()
            return false
        }
    }
    
    func isReachable() -> Bool {
        if  reachability.connectionStatus().description != "Offline"{
            return true
        }
        return false
    }
    
    func Notreachable(){
        self.promtMsg(msg: "No Network Connection Available, Please Try Again Later." , color: UIColor.red)
    }
    
    func promtMsg(msg:String,color:UIColor){
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.showErrorToast(message: msg , duration: 2000, backgroundColor: color)
        }
    }
    
    var windows: UIWindow?
    
    //MARK: 401 Handling
    func navigatToRoot(){
        //        UserDefaults.standard.setValue("", forKey: "auth-token")
        //        UserDefaults.standard.setValue("", forKey: "fbAccessToken")
        //        UserDefaults.standard.setValue("", forKey: "userName")
        //        URLCache.shared.removeAllCachedResponses()
        //        let postsList = LandingWireFrame.createLandinModule(isLaunhed: false,setLoginView:true)
        //        windows = UIWindow(frame: UIScreen.main.bounds)
        //        windows?.rootViewController = postsList
        //        windows?.makeKeyAndVisible()
        //        FBSDKLoginManager().logOut()      //FB_LOGOUT
        //        GIDSignIn.sharedInstance().signOut()  //GMAIL_LOGOUT
        //        self.showErrorToast(message: "Your session has been expired, please re-login." , duration: 1000)
    }
    
    
    
    //MARK: GET  Without header
    func GET_webservice(Url: String ,background:Bool,completion:  @escaping ( _ result: AnyObject, _ statusCode: Int?) -> Void){
        if !background{
            HUD.show(.progress)
        }
        
        Alamofire.request("https://reqres.in/api/users?page=2").responseJSON { (responseData) -> Void in
            if !background{
                HUD.hide()
            }
            print(responseData.result)
            print("status code GET_webservice>>>>>",responseData.response?.statusCode ?? "no response code")
            var statusCode:Int? = (responseData.response?.statusCode)
            if responseData.response?.statusCode == nil{
                statusCode  = 402
                
            }else if (responseData.response?.statusCode) == 401{
                self.navigatToRoot()
                self.showErrorToast(message: "Session expired,Please login again!" , duration: 2000, backgroundColor: UIColor.red)
            }else{
                statusCode = (responseData.response?.statusCode)!
            }
            var result: AnyObject?
            if let re = responseData.result.value {
                result = re as AnyObject
            }else {
                result = 0 as Int as AnyObject
                
            }
            completion(result!,statusCode)
        }
    }
    
    //MARK: GET WITH  AUTH
    func GET_WithHeader_webservice(Url: String , prm: Parameters,auth: Bool,background:Bool,completion:  @escaping ( _ result: AnyObject, _ statusCode: Int?) -> Void){
        if Check_networkConnection(){
            if !background{
                HUD.show(.progress)
            }
            var  headers: HTTPHeaders = [:]
            if auth {
                if UserDefaults.standard.value(forKey: "auth-token") != nil {
                    let auth : String = UserDefaults.standard.value(forKey: "auth-token") as! String
                    headers = ["Content-Type": "application/json","auth-token":auth]
                }else{
                    headers = ["Content-Type": "application/json"]
                }
                
                print("Auth used to call server >>>>>>>>>>",auth)
                
            }else {
                headers = ["Content-Type": "application/json"]
            }
            Alamofire.request(EndPoints.serverPath+Url, method: .get, parameters: prm,encoding: URLEncoding.default, headers: headers).responseJSON{  (responseData) -> Void in
                HUD.hide()
                print(responseData.result)
                print("status code GET_WithHeader_webservice>>>>>",responseData.response?.statusCode ?? "no response code")
                var statusCode:Int? = (responseData.response?.statusCode)
                var result: AnyObject?
                
                // self.authfail?.CallBackToLogin()
                
                if responseData.response?.statusCode == nil{
                    statusCode  = 402
                    
                }else if (responseData.response?.statusCode) == 401{
                    //self.navigatToRoot()
                    self.showErrorToast(message: "Session expired,Please login again!" , duration: 2000,backgroundColor: UIColor.red)
                }else{
                    statusCode = (responseData.response?.statusCode)!
                }
                // statusCode  = 401
                if let re = responseData.result.value {
                    
                    result = re as AnyObject
                }else {
                    
                    result = 0  as AnyObject
                }
                completion(result!,statusCode)
            }
        }
    }
    
    //MARK: GET WITH  AUTH + custom header
    func GET_WithHeaderCustom_webservice(Url: String , prm: Parameters?,header: HTTPHeaders,background:Bool,completion:  @escaping ( _ result: AnyObject, _ statusCode: Int?) -> Void){
        if Check_networkConnection(){
            if !background{
                HUD.show(.progress)
            }
            print(EndPoints.serverPath+Url)
            Alamofire.request(EndPoints.serverPath+Url, method: .get, parameters: prm,encoding: URLEncoding.queryString, headers: header).responseJSON{  (responseData) -> Void in
                print(responseData.result)
                if !background{
                    HUD.hide()
                }
                print("status code GET_WithHeaderCustom_webservice>>>>>",responseData.response?.statusCode ?? "no response code")
                var statusCode:Int? = (responseData.response?.statusCode)
                var result: AnyObject?
                if responseData.response?.statusCode == nil{
                    statusCode  = 402
                    
                }else if (responseData.response?.statusCode) == 401{
                    // self.navigatToRoot()
                    self.showErrorToast(message: "Session expired,Please login again!" , duration: 2000,backgroundColor: UIColor.red)
                }else{
                    statusCode = (responseData.response?.statusCode)!
                }
                
                if let re = responseData.result.value {
                    result = re as AnyObject
                }else {
                    result = 0  as AnyObject
                }
                completion(result!,statusCode)
            }
        }
    }
    
    //MARK:POST_webservice without Auth config
    func POST_webservice(Url: String, prm: Parameters ,background:Bool, completion: @escaping ( _ result: AnyObject, _ statusCode: Int?) -> Void){
        if Check_networkConnection(){
            if !background{
                HUD.show(.progress)
            }
            
            let headers: HTTPHeaders = ["Content-Type": "application/json"]
            Alamofire.request(EndPoints.serverPath+Url, method: .post, parameters: prm, encoding: JSONEncoding.default,  headers: headers).responseJSON { (responseData) -> Void in
                if !background{
                    HUD.hide()
                }
                print(responseData.result)
                print("status code POST_webservice>>>>>",responseData.response?.statusCode ?? "no response code")
                if let result = responseData.result.value {
                    print(result)
                    var statusCode:Int? = (responseData.response?.statusCode)
                    var result: AnyObject?
                    
                    if responseData.response?.statusCode == nil{
                        statusCode  = 402
                    }else if statusCode == 401{
                        self.navigatToRoot()
                        self.showErrorToast(message: "Session expired,Please login again!" , duration: 2000,backgroundColor: UIColor.red)
                    }else if statusCode != 200 || statusCode != 400 {
                        self.showErrorToast(message: "Somthing went wrong please try agi latter." , duration: 2000,backgroundColor: UIColor.red)
                    }
                    
                    if let re = responseData.result.value {
                        result = re as AnyObject
                    }
                    if  statusCode == 200  && ( Url == "/authentication/login" || Url == "/authentication/login-social"){
                        let responsHeader :NSDictionary = responseData.response?.allHeaderFields as! NSDictionary
                        print(responsHeader)
                        print(responsHeader.value(forKey: "auth-token"))
                        UserDefaults.standard.setValue(responsHeader.value(forKey: "auth-token"), forKey: "auth-token")
                    }
                    completion(result!,statusCode)
                }else{
                    self.showErrorToast(message: "Somthing went wrong please try agi latter." , duration: 2000,backgroundColor: UIColor.red)
                }
            }
        }
    }
    
    //MARK:POST_webservice With Header config & Auth config
    func POST_WithHeader_webservice(Url: String, prm: Parameters ,auth: Bool,background:Bool,completion:  @escaping ( _ result: AnyObject , _ statusCode: Int) -> Void){
        if Check_networkConnection(){
            if !background{
                HUD.show(.progress)
            }
            var  headers: HTTPHeaders = [:]
            if auth {
                let auth : String = UserDefaults.standard.value(forKey: "auth-token") as! String
                headers = ["Content-Type": "application/json","auth-token":auth]
            }else {
                headers = ["Content-Type": "application/json"]
            }
            Alamofire.request(EndPoints.serverPath+Url, method: .post, parameters: prm, encoding: JSONEncoding.default,  headers: headers).responseJSON { (responseData) -> Void in
                if !background{
                    HUD.hide()
                }
                print(responseData.result)
                print("status code POST_WithHeader_webservice>>>>>",responseData.response?.statusCode ?? "no response code")
                var statusCode:Int? = (responseData.response?.statusCode)
                if responseData.response?.statusCode == nil{
                    statusCode  = 402
                    
                }else if (responseData.response?.statusCode) == 401{
                    self.navigatToRoot()
                    self.showErrorToast(message: "Session expired,Please login again!" , duration: 2000,backgroundColor: UIColor.red)
                }else{
                    statusCode = (responseData.response?.statusCode)!
                }
                if let re = responseData.result.value {
                    if re is NSDictionary {
                        print("Dictionary")
                        let  result: NSDictionary  = re as! NSDictionary
                        completion(result ,statusCode!)
                    }else  if re is NSArray {
                        print("Array")
                        let  result: NSArray = re as! NSArray
                        completion(result ,statusCode!)
                    }
                } else {
                    completion(responseData.result.value as AnyObject,statusCode!)
                }
            }
        }
    }
    
    //MARK: POST_ webservice with custom Header
    func POST_WithCustomHeader_webservice(Url: String, prm: Parameters? ,Header: HTTPHeaders,background:Bool,completion:  @escaping ( _ result: AnyObject , _ statusCode: Int) -> Void){
        if Check_networkConnection(){
            if !background{
                HUD.show(.progress)
            }
            
            Alamofire.request(EndPoints.serverPath+Url, method: .post, parameters: prm, encoding: JSONEncoding.default,  headers: Header).responseJSON { (responseData) -> Void in
                if !background{
                    HUD.hide()
                }
                print(responseData.result)
                print("status code POST_WithHeader_webservice>>>>>",responseData.response?.statusCode ?? "no response code")
                var statusCode:Int? = (responseData.response?.statusCode)
                if responseData.response?.statusCode == nil{
                    statusCode  = 402
                    
                }else if (responseData.response?.statusCode) == 401{
                    self.navigatToRoot()
                    self.showErrorToast(message: "Session expired,Please login again!" , duration: 2000,backgroundColor: UIColor.red)
                }else{
                    statusCode = (responseData.response?.statusCode)!
                }
                if let re = responseData.result.value {
                    if re is NSDictionary {
                        print("Dictionary")
                        let  result: NSDictionary  = re as! NSDictionary
                        completion(result ,statusCode!)
                    }else  if re is NSArray {
                        print("Array")
                        let  result: NSArray = re as! NSArray
                        completion(result ,statusCode!)
                    }
                    //let result : AnyObject?
                    // completion(result!, 0)
                } else {
                    completion(responseData.result.value as AnyObject,statusCode!)
                }
            }
        }
    }
    
    //MARK: GET_WithCustomHeader_webservice  with custom Header
    func GET_WithCustomHeader_webservice(Url: String, prm: Parameters? ,Header: HTTPHeaders,background:Bool,completion:  @escaping ( _ result: AnyObject , _ statusCode: Int) -> Void){
        if Check_networkConnection(){
            if !background{
                HUD.show(.progress)
            }
            
            Alamofire.request(EndPoints.serverPath+Url, method: .get, parameters: prm, encoding: JSONEncoding.default,  headers: Header).responseJSON { (responseData) -> Void in
                if !background{
                    HUD.hide()
                }
                print(responseData.result)
                //responseData.st
                print("status code GET_WithCustomHeader_webservice>>>>>",responseData.response?.statusCode ?? "no response code")
                var statusCode:Int? = (responseData.response?.statusCode)
                if responseData.response?.statusCode == nil{
                    statusCode  = 402
                    
                }else if (responseData.response?.statusCode) == 401{
                    self.navigatToRoot()
                    self.showErrorToast(message: "Session expired,Please login again!" , duration: 2000,backgroundColor: UIColor.red)
                }else{
                    statusCode = (responseData.response?.statusCode)!
                }
                if let re = responseData.result.value {
                    if re is NSDictionary {
                        print("Dictionary")
                        let  result: NSDictionary  = re as! NSDictionary
                        completion(result ,statusCode!)
                    }else  if re is NSArray {
                        print("Array")
                        let  result: NSArray = re as! NSArray
                        completion(result ,statusCode!)
                    }
                    //let result : AnyObject?
                    // completion(result!, 0)
                } else {
                    completion(responseData.result.value as AnyObject,statusCode!)
                }
            }
        }
    }
    
    //MARK:PUT_webservice With Header config + custom header & Auth config
    func PUT_WithHeaderCustom_webservice(Url: String, prm: Parameters ,header: HTTPHeaders,background:Bool,completion:  @escaping ( _ result: AnyObject? , _ statusCode: Int?) -> Void){
        if Check_networkConnection(){
            if !background{
                HUD.show(.progress)
            }
            Alamofire.request(EndPoints.serverPath+Url, method: .put, parameters: prm, encoding: JSONEncoding.default,  headers: header).responseJSON { (responseData) -> Void in
                
                HUD.hide()
                
                print(responseData.result)
                print("status code PUT_WithHeaderCustom_webservice>>>>>",responseData.response?.statusCode ?? "no response code")
                var statusCode:Int? = (responseData.response?.statusCode)
                if responseData.response?.statusCode == nil{
                    statusCode  = 402
                }else if (responseData.response?.statusCode) == 401{
                    self.navigatToRoot()
                    self.showErrorToast(message: "Session expired,Please login again!" , duration: 2000,backgroundColor: UIColor.red)
                }else{
                    statusCode = (responseData.response?.statusCode)!
                }
                var result: AnyObject?
                if let re = responseData.result.value {
                    
                    result = re as AnyObject
                }
                completion(result,statusCode)
            }
        }
    }
    
    //MARK: GET WITH Data Result
    func GET_WithHeader_DataRespons(Url: String , prm: Parameters,auth: Bool,completion:  @escaping ( _ result: AnyObject, _ statusCode: Int?) -> Void){
        if Check_networkConnection(){
            var  headers: HTTPHeaders = [:]
            if auth {
                if UserDefaults.standard.value(forKey: "auth-token") != nil {
                    let auth : String = UserDefaults.standard.value(forKey: "auth-token") as! String
                    headers = ["Content-Type": "application/json","auth-token":auth]
                }else{
                    headers = ["Content-Type": "application/json"]
                }
                
                print("Auth used to call server >>>>>>>>>>",auth)
                
            }else {
                headers = ["Content-Type": "application/json"]
            }
            
            Alamofire.request(EndPoints.serverPath+Url, method: .get, parameters: prm,encoding: URLEncoding.default, headers: headers).responseJSON{  (responseData) -> Void in
                print(responseData.result)
                print("status code GET_WithHeader_DataRespons>>>>>",responseData.response?.statusCode ?? "no response code")
                var statusCode:Int? = (responseData.response?.statusCode)
                var result: AnyObject?
                
                // self.authfail?.CallBackToLogin()
                
                if responseData.response?.statusCode == nil{
                    statusCode  = 402
                    
                }else if (responseData.response?.statusCode) == 401{
                    self.navigatToRoot()
                    self.showErrorToast(message: "Session expired,Please login again!" , duration: 2000,backgroundColor: UIColor.red)
                }else{
                    statusCode = (responseData.response?.statusCode)!
                }
                // statusCode  = 401
                if let re = responseData.data {
                    result = re as AnyObject
                }else {
                    
                    result = 0  as AnyObject
                }
                completion(result!,statusCode)
            }
        }
    }
    
    //MARK:POST_webservice With Auth  + Plain body
    func POST_PlainBodyWithHeader_webservice(Url: String, prm: Parameters ,auth: Bool,body:String,background:Bool,completion:  @escaping ( _ result: AnyObject, _ statusCode: Int?) -> Void){
        if Check_networkConnection(){
            if !background{
                HUD.show(.progress)
            }
            
            var  headers: HTTPHeaders = [:]
            if auth {
                let auth : String = UserDefaults.standard.value(forKey: "auth-token") as! String
                headers = ["Content-Type": "application/json","auth-token":auth]
            }else {
                
                headers = ["Content-Type": "application/json"]
            }
            
            Alamofire.request(EndPoints.serverPath+Url, method: .post, parameters: prm, encoding: body, headers: headers).responseJSON { (responseData) -> Void in
                print(responseData.result)
                if !background{
                    HUD.hide()
                }
                print("status code POST_PlainBodyWithHeader_webservice>>>>>",responseData.response?.statusCode ?? "no response code")
                var statusCode:Int? = (responseData.response?.statusCode)
                if responseData.response?.statusCode == nil{
                    statusCode  = 402
                    
                }else if (responseData.response?.statusCode) == 401{
                    self.navigatToRoot()
                    self.showErrorToast(message: "Session expired,Please login again!" , duration: 2000,backgroundColor: UIColor.red)
                }else{
                    statusCode = (responseData.response?.statusCode)!
                }
                var result : AnyObject = 0  as AnyObject
                if let re = responseData.result.value {
                    result = re as AnyObject
                }
                completion(result,statusCode)
            }
        }
    }
    
    //MARK:DELET With Header config
    func DELET_WithHeader_webservice(Url: String, prm: Parameters ,auth: Bool,background:Bool,completion:  @escaping ( _ result: AnyObject,_ statusCode: Int?) -> Void){
        if Check_networkConnection(){
            if !background{
                HUD.show(.progress)
            }
            
            var  headers: HTTPHeaders = [:]
            if auth {
                let auth : String = UserDefaults.standard.value(forKey: "auth-token") as! String
                headers = ["Content-Type": "application/json","auth-token":auth]
            }else {
                
                headers = ["Content-Type": "application/json"]
            }
            
            Alamofire.request(EndPoints.serverPath+Url, method: .delete, parameters: prm, encoding: JSONEncoding.default,  headers: headers).responseJSON { (responseData) -> Void in
                if !background{
                    HUD.hide()
                }
                print(responseData.result)
                print("status code DELET_WithHeader_webservice>>>>>",responseData.response?.statusCode ?? "no response code")
                
                var statusCode:Int? = (responseData.response?.statusCode)
                if responseData.response?.statusCode == nil{
                    statusCode  = 402
                    
                }else if (responseData.response?.statusCode) == 401{
                    self.navigatToRoot()
                    self.showErrorToast(message: "Session expired,Please login again!" , duration: 2000,backgroundColor: UIColor.red)
                }else{
                    statusCode = (responseData.response?.statusCode)!
                }
                
                
                if let result = responseData.result.value {
                    let JSON = result as AnyObject
                    print(JSON)
                    completion(JSON,statusCode)
                }
            }
        }else{
            self.showErrorToast(message: "Please check your network connection!", duration: 2000,backgroundColor:UIColor.red)
        }
    }
    
    //MARK: MUMLTIPART UPLOAD
    func uploadeMultiPartDataWithJSON(Url: String, prm: Parameters ,auth: Bool,background:Bool,uploadIMG:UIImage?,accessToken: String,tokenSecret: String,photoUrl:String,accountType:String, completion:  @escaping ( _ result: AnyObject, _ statusCode: Int?) -> Void){
        
        if Check_networkConnection(){
            HUD.show(.progress)
            let str = self.jsonToString(json: prm as AnyObject)
            print(str)
            var  headers: HTTPHeaders = [:]
            if accessToken != ""{
                headers = ["Content-Type": "application/json","access-token":accessToken,"token-secret":tokenSecret]
            }else{
                headers = ["Content-Type": "application/json"]
            }
            
            Alamofire.upload(
                multipartFormData: { MultipartFormData in
                    
                    MultipartFormData.append(str.data(using: String.Encoding.utf8)!, withName: "goinUser", mimeType: "application/json")
                    if accessToken == ""{
                        if uploadIMG != nil {
                            MultipartFormData.append(UIImageJPEGRepresentation(uploadIMG!, 1)!, withName: "profilePhoto", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
                        }
                    }else{
                        
                        MultipartFormData.append(photoUrl.data(using: String.Encoding.utf8)!, withName: "photoURL", mimeType: "text/plain")
                        
                        MultipartFormData.append(accountType.data(using: String.Encoding.utf8)!, withName: "accountType", mimeType: "text/plain")
                    }
                    
            }, to: EndPoints.serverPath+Url , headers: headers  ) { (result) in
                switch result {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        if !background{
                            HUD.hide()
                        }
                        print("status code uploadeMultiPartDataWithJSON>>>>>",response.response?.statusCode ?? "no response code")
                        
                        var statusCode:Int? = (response.response?.statusCode)
                        if response.response?.statusCode == nil{
                            statusCode  = 402
                        }else if statusCode == 201 || statusCode == 200{
                            if accessToken != ""{
                                let responsHeader :NSDictionary = response.response?.allHeaderFields as! NSDictionary
                                print(responsHeader)
                                print(responsHeader.value(forKey: "auth-token"))
                                UserDefaults.standard.setValue(responsHeader.value(forKey: "auth-token"), forKey: "auth-token")
                            }
                        }
                        print(response.result.value)
                        let result : AnyObject = 0  as AnyObject
                        completion(result,statusCode)
                    }
                case .failure(let encodingError): break
                print(encodingError)
                }
            }
        }else{
            self.showErrorToast(message: "Please check your network connection!", duration: 2000,backgroundColor: UIColor.red)
        }
    }
    
    func jsonToString(json: AnyObject) -> String{
        do {
            let data1 =  try JSONSerialization.data(withJSONObject: json, options: []) // first of all convert json to the data
            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
            return convertedString!
            
        } catch let myJSONError {
            print(myJSONError)
            return ""
        }
    }
    
    //MARK:POST_webservice without Auth config
    func POST_Authorization_webservice(Url: String, prm: Parameters , authorization: String, background:Bool, completion: @escaping ( _ result: AnyObject, _ statusCode: Int?) -> Void){
        if Check_networkConnection(){
            if !background{
                HUD.show(.progress)
            }
            let  headers: HTTPHeaders = ["Content-Type": "application/json","authorization": authorization]
            Alamofire.request(EndPoints.serverPath+Url, method: .post, parameters: prm, encoding: JSONEncoding.default,  headers: headers).responseJSON { (responseData) -> Void in
                if !background{
                    HUD.hide()
                }
                print(responseData.result)
                print("status code POST_webservice>>>>>",responseData.response?.statusCode ?? "no response code")
                if let result = responseData.result.value {
                    print(result)
                    var statusCode:Int? = (responseData.response?.statusCode)
                    var result: AnyObject?
                    if responseData.response?.statusCode == nil{
                        statusCode  = 402
                    }else if  statusCode == 200 {
                        statusCode = (responseData.response?.statusCode)!
                    }else{
                        self.showErrorToast(message: "Somthing went wrong please try agi latter." , duration: 2000,backgroundColor: UIColor.red)
                    }
                    if let re = responseData.result.value {
                        result = re as AnyObject
                    }
                    completion(result!,statusCode)
                }else{
                    self.showErrorToast(message: "Somthing went wrong please try agi latter." , duration: 2000,backgroundColor: UIColor.red)
                }
            }
        }
    }
}

extension String: ParameterEncoding {
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = data(using: .utf8, allowLossyConversion: false)
        return request
    }
}
