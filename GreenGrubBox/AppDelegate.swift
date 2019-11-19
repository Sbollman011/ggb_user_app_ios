//
//  AppDelegate.swift
//  GreenGrubBox
//
//  Created by Ankit on 1/29/18.
//  Copyright © 2018 Ankit. All rights reserved.
//


import UIKit
import IQKeyboardManager
import DropDown
import UserNotifications
import Stripe
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import EventKit
import Alamofire


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,UITabBarControllerDelegate {
    
    var window: UIWindow?
    let storyboardName = "Main"
    let tabBarView: UIView = UIView()
    var TabbarCustomMain: UITabBarController?
    var viewController = UINavigationController()
    var btnLocation: UIButton = UIButton()
    let btnScranner : UIButton = UIButton()
    let btnAccount: UIButton = UIButton()
    var LastTabSelected : Int = 0
    let indexVal: NSInteger = NSInteger()
    let img_Location :UIImageView = UIImageView()
    let img_Scranner :UIImageView = UIImageView()
    let img_Account :UIImageView = UIImageView()
    let imgMain_Location :UIImageView = UIImageView()
    let imgMain_Scranner :UIImageView = UIImageView()
    let imgMain_Account :UIImageView = UIImageView()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //FirebaseApp.configure()
        print(launchOptions)
        checkVersion()
        STPPaymentConfiguration.shared().publishableKey = EndPoints.strip_key
        DropDown.startListeningToKeyboard()
        IQKeyboardManager.shared().isEnabled = true
        FontSetup()
        
        //Notification
        registerForPushNotifications(application: application)
        if UserDefaults.standard.value(forKey: "deviceToken") != nil{
            let token : String = UserDefaults.standard.value(forKey: "deviceToken") as! String
            if token != "" {
                DeviceToken = token
            }
        }
        
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        let obj : AnyObject! = UserDefaults.standard.object(forKey: "userid") as AnyObject!
        if (obj != nil ){
            
            let userID : String = UserDefaults.standard.value(forKey: "userid") as! String
            let TokenUser : String = UserDefaults.standard.value(forKey: "token") as! String
            
            if userID != "" {
                LoginUserId = userID
                LoginToken = TokenUser
                if FromRemoteNotification(launchOptions: launchOptions){
                    createCustomTabBar()
                    appDelegate.window?.rootViewController = appDelegate.TabbarCustomMain
                    appDelegate.TabbarCustomMain?.selectedIndex = 2
                    img_Location.image = UIImage(named: "Tab_locations_off")
                    img_Scranner.image = UIImage(named: "Tab_center")
                    img_Account.image = UIImage(named: "Tab_account_on")
                }else {
                    createCustomTabBar()
                    appDelegate.window?.rootViewController = appDelegate.TabbarCustomMain
                }
            }
        } else {
            let Navigtion = storyboard.instantiateViewController(withIdentifier: "Navigtioncontroller") as! UINavigationController
            appDelegate.window?.rootViewController = Navigtion
        }
        Messaging.messaging().fcmToken
        Fabric.sharedSDK().debug = true
        return true
    }
    
    func FromRemoteNotification(launchOptions:[UIApplicationLaunchOptionsKey: Any]?)  -> Bool{
        if launchOptions != nil {
            let remotnotif = launchOptions![UIApplicationLaunchOptionsKey.remoteNotification] as? NSDictionary
            if remotnotif != nil {
                let itemName : NSDictionary = remotnotif!["aps"] as! NSDictionary
                print(itemName)
                return true
            }
        }
        
        return false
    }
    
    //MARK: to know all fonts used in
    func printFonts() {
        let fontFamilyNames = UIFont.familyNames
        for familyName in fontFamilyNames {
            print("------------------------------")
            print("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNames(forFamilyName: familyName )
            print("Font Names = [\(names)]")
        }
    }
    
    func FontSetup(){
        print("\(UIDevice().type)")
        //        "iPhone7,2" : ,
        //        "iPhone8,1" : .iPhone6S,
        //        "iPhone8,2" : .iPhone6Splus,
        let device : Model = UIDevice().type
        
        
        if device == .iPhone5S ||  device == .iPhone5 || device == .iPhoneSE || device == .iPhone5C {
            
            print(" in >>>\(UIDevice().type)")
            
            FontNormal10  = UIFont(name:  AppFontName.Lato.LatoRegular, size: 9.0)!
            FontNormal11  = UIFont(name:  AppFontName.Lato.LatoRegular, size: 10.0)!
            FontNormal12  = UIFont(name:  AppFontName.Lato.LatoRegular, size: 11.0)!
            FontNormal14  = UIFont(name:  AppFontName.Lato.LatoRegular, size: 13.0)!
            FontNormal15  = UIFont(name:  AppFontName.Lato.LatoRegular, size: 14.0)!
            FontNormal16  = UIFont(name:  AppFontName.Lato.LatoRegular, size: 15.0)!
            FontNormal17  = UIFont(name:  AppFontName.Lato.LatoRegular, size: 16.0)!
            FontNormal18  = UIFont(name:  AppFontName.Lato.LatoRegular, size: 17.0)!
            FontNormal19  = UIFont(name:  AppFontName.Lato.LatoRegular, size: 18.0)!
            FontNormal20  = UIFont(name:  AppFontName.Lato.LatoRegular, size: 19.0)!
            FontNormal21  = UIFont(name:  AppFontName.Lato.LatoRegular, size: 17.0)!
            FontNormal24  = UIFont(name:  AppFontName.Lato.LatoRegular, size: 23.0)!
            
            FontBold10  = UIFont(name:  AppFontName.Lato.LatoBold, size: 7.0)!
            FontBold11  = UIFont(name:  AppFontName.Lato.LatoBold, size: 8.0)!
            FontBold12  = UIFont(name:  AppFontName.Lato.LatoBold, size: 9.0)!
            FontBold13  = UIFont(name:  AppFontName.Lato.LatoBold, size: 10.0)!
            FontBold14  = UIFont(name:  AppFontName.Lato.LatoBold, size: 11.0)!
            FontBold15  = UIFont(name:  AppFontName.Lato.LatoBold, size: 12.0)!
            FontBold16  = UIFont(name:  AppFontName.Lato.LatoBold, size: 11.0)!
            FontBold17  = UIFont(name:  AppFontName.Lato.LatoBold, size: 12.0)!
            FontBold18  = UIFont(name:  AppFontName.Lato.LatoBold, size:15.0)!
            FontBold19  = UIFont(name:  AppFontName.Lato.LatoBold, size: 16.0)!
            FontBold20  = UIFont(name:  AppFontName.Lato.LatoBold, size: 17.0)!
            
            FontBold24  = UIFont(name:  AppFontName.Lato.LatoBold, size: 20.0)!
            FontBold36  = UIFont(name:  AppFontName.Lato.LatoBold, size: 31.0)!
            
            //font two
            Font2Bold10  = UIFont(name:  AppFontName.Lato.LatoBold, size: 8.0)!
            Font2Bold11  = UIFont(name:  AppFontName.Lato.LatoBold, size: 10.0)!
            Font2Bold12  = UIFont(name:  AppFontName.Lato.LatoBold, size: 11.0)!
            Font2Bold13  = UIFont(name:  AppFontName.Lato.LatoBold, size: 12.0)!
            Font2Bold14  = UIFont(name:  AppFontName.Lato.LatoBold, size: 13.0)!
            Font2Bold15  = UIFont(name:  AppFontName.Lato.LatoBold, size: 14.0)!
            Font2Bold16  = UIFont(name:  AppFontName.Lato.LatoBold, size: 15.0)!
            Font2Bold17  = UIFont(name:  AppFontName.Lato.LatoBold, size: 16.0)!
            Font2Bold18  = UIFont(name:  AppFontName.Lato.LatoBold, size:16.0)!
            Font2Bold19  = UIFont(name:  AppFontName.Lato.LatoBold, size: 17.0)!
            Font2Bold20  = UIFont(name:  AppFontName.Lato.LatoBold, size: 18.0)!
            Font2Bold25 = UIFont(name:  AppFontName.Lato.LatoBold, size: 20.0)!
            Font2Bold24  = UIFont(name:  AppFontName.Lato.LatoBold, size:16.0)!
            Font2Bold36  = UIFont(name:  AppFontName.Lato.LatoBold, size: 33.0)!
            
        }
        if device == .iPhone6S || device == .iPhone6 ||  device == .iPhone7 || device == .iPhone8 {
            
            print(" no need to setup  in >>>\(UIDevice().type)")
            //iphone 6
            // AppFontName.Lato.LatoRegular
            FontNormal10  = UIFont(name:  AppFontName.Lato.LatoRegular, size: 10.0)!
            FontNormal11  = UIFont(name:  AppFontName.Lato.LatoRegular, size: 11.0)!
            FontNormal12  = UIFont(name:  AppFontName.Lato.LatoRegular, size: 12.0)!
            FontNormal13  = UIFont(name:  AppFontName.Lato.LatoRegular, size: 13.0)!
            FontNormal14  = UIFont(name:  AppFontName.Lato.LatoRegular, size: 14.0)!
            FontNormal15  = UIFont(name:  AppFontName.Lato.LatoRegular, size: 15.0)!
            FontNormal16  = UIFont(name:  AppFontName.Lato.LatoRegular, size: 16.0)!
            FontNormal17  = UIFont(name:  AppFontName.Lato.LatoRegular, size: 17.0)!
            FontNormal18  = UIFont(name:  AppFontName.Lato.LatoRegular, size: 18.0)!
            FontNormal19  = UIFont(name:  AppFontName.Lato.LatoRegular, size: 19.0)!
            FontNormal20  = UIFont(name:  AppFontName.Lato.LatoRegular, size: 20.0)!
            FontNormal21  = UIFont(name:  AppFontName.Lato.LatoRegular, size: 21.0)!
            FontNormal22  = UIFont(name:  AppFontName.Lato.LatoRegular, size: 22.0)!
            FontNormal23  = UIFont(name:  AppFontName.Lato.LatoRegular, size: 22.0)!
            FontNormal24  = UIFont(name:  AppFontName.Lato.LatoRegular, size: 24.0)!
            FontNormal25  = UIFont(name:  AppFontName.Lato.LatoRegular, size: 25.0)!
            
            //bold
            FontBold10 = UIFont(name:  AppFontName.Lato.LatoBold, size: 10.0)!
            FontBold11 = UIFont(name:  AppFontName.Lato.LatoBold, size: 11.0)!
            FontBold12 = UIFont(name:  AppFontName.Lato.LatoBold, size: 12.0)!
            FontBold13 = UIFont(name:  AppFontName.Lato.LatoBold, size: 13.0)!
            FontBold14 = UIFont(name:  AppFontName.Lato.LatoBold, size: 14.0)!
            FontBold15 = UIFont(name:  AppFontName.Lato.LatoBold, size: 15.0)!
            FontBold16 = UIFont(name:  AppFontName.Lato.LatoBold, size: 15.0)!
            FontBold17 = UIFont(name:  AppFontName.Lato.LatoBold, size: 17.0)!
            FontBold18 = UIFont(name:  AppFontName.Lato.LatoBold, size: 18.0)!
            FontBold19 = UIFont(name:  AppFontName.Lato.LatoBold, size: 19.0)!
            FontBold20 = UIFont(name:  AppFontName.Lato.LatoBold, size: 20.0)!
            FontBold21 = UIFont(name:  AppFontName.Lato.LatoBold, size: 21.0)!
            FontBold22 = UIFont(name:  AppFontName.Lato.LatoBold, size: 22.0)!
            FontBold23 = UIFont(name:  AppFontName.Lato.LatoBold, size: 23.0)!
            FontBold24 = UIFont(name:  AppFontName.Lato.LatoBold, size: 24.0)!
            FontBold25 = UIFont(name:  AppFontName.Lato.LatoBold, size: 25.0)!
            FontBold36 = UIFont(name:  AppFontName.Lato.LatoBold, size: 36.0)!
            
            //font 2
            Font2Bold10 = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 10.0)!
            Font2Bold11 = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 11.0)!
            Font2Bold12 = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 12.0)!
            Font2Bold13 = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 13.0)!
            Font2Bold14 = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 14.0)!
            Font2Bold15 = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 15.0)!
            Font2Bold16 = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 16.0)!
            Font2Bold17 = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 17.0)!
            Font2Bold18 = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 18.0)!
            Font2Bold19 = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 19.0)!
            Font2Bold20 = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 20.0)!
            Font2Bold21 = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 21.0)!
            Font2Bold22 = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 22.0)!
            Font2Bold23 = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 23.0)!
            Font2Bold24 = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 24.0)!
            Font2Bold25 = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 25.0)!
            Font2Bold36 = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 36.0)!
        }
        
        if device == .iPhone6Splus || device == .iPhone6plus || device == .iPhone7plus || device == .iPhone8plus {
            print(" in >>>\(UIDevice().type)")
            //iphone 6 +
            FontNormal10  = UIFont(name:  AppFontName.Lato.LatoRegular, size: 12.0)!
            FontNormal11  = UIFont(name:  AppFontName.Lato.LatoRegular, size: 13.0)!
            FontNormal12  = UIFont(name:  AppFontName.Lato.LatoRegular, size: 14.0)!
            FontNormal13  = UIFont(name:  AppFontName.Lato.LatoRegular, size: 15.0)!
            FontNormal14  = UIFont(name:  AppFontName.Lato.LatoRegular, size: 16.0)!
            FontNormal15  = UIFont(name:  AppFontName.Lato.LatoRegular, size: 17.0)!
            FontNormal16  = UIFont(name:  AppFontName.Lato.LatoRegular, size: 18.0)!
            FontNormal17  = UIFont(name:  AppFontName.Lato.LatoRegular, size: 19.0)!
            FontNormal18  = UIFont(name:  AppFontName.Lato.LatoRegular, size: 20.0)!
            FontNormal19  = UIFont(name:  AppFontName.Lato.LatoRegular, size: 21.0)!
            FontNormal20  = UIFont(name:  AppFontName.Lato.LatoRegular, size: 22.0)!
            FontNormal21  = UIFont(name:  AppFontName.Lato.LatoRegular, size: 23.0)!
            FontNormal22  = UIFont(name:  AppFontName.Lato.LatoRegular, size: 24.0)!
            FontNormal23  = UIFont(name:  AppFontName.Lato.LatoRegular, size: 25.0)!
            FontNormal24  = UIFont(name:  AppFontName.Lato.LatoRegular, size: 26.0)!
            FontNormal25  = UIFont(name:  AppFontName.Lato.LatoRegular, size: 27.0)!
            
            //bold
            FontBold10 = UIFont(name:  AppFontName.Lato.LatoBold, size: 12.0)!
            FontBold11 = UIFont(name:  AppFontName.Lato.LatoBold, size: 13.0)!
            FontBold12 = UIFont(name:  AppFontName.Lato.LatoBold, size: 14.0)!
            FontBold13 = UIFont(name:  AppFontName.Lato.LatoBold, size: 15.0)!
            FontBold14 = UIFont(name:  AppFontName.Lato.LatoBold, size: 16.0)!
            FontBold15 = UIFont(name:  AppFontName.Lato.LatoBold, size: 17.0)!
            FontBold16 = UIFont(name:  AppFontName.Lato.LatoBold, size: 18.0)!
            FontBold17 = UIFont(name:  AppFontName.Lato.LatoBold, size: 19.0)!
            FontBold18 = UIFont(name:  AppFontName.Lato.LatoBold, size: 20.0)!
            FontBold19 = UIFont(name:  AppFontName.Lato.LatoBold, size: 21.0)!
            FontBold20 = UIFont(name:  AppFontName.Lato.LatoBold, size: 22.0)!
            FontBold21 = UIFont(name:  AppFontName.Lato.LatoBold, size: 23.0)!
            FontBold22 = UIFont(name:  AppFontName.Lato.LatoBold, size: 24.0)!
            FontBold23 = UIFont(name:  AppFontName.Lato.LatoBold, size: 25.0)!
            FontBold24 = UIFont(name:  AppFontName.Lato.LatoBold, size: 26.0)!
            FontBold25 = UIFont(name:  AppFontName.Lato.LatoBold, size: 27.0)!
            FontBold36 = UIFont(name:  AppFontName.Lato.LatoBold, size: 38.0)!
            
            //bold
            Font2Bold10 = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 12.0)!
            Font2Bold11 = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 13.0)!
            Font2Bold12 = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 14.0)!
            Font2Bold13 = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 15.0)!
            Font2Bold14 = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 16.0)!
            Font2Bold15 = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 17.0)!
            Font2Bold16 = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 18.0)!
            Font2Bold17 = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 19.0)!
            Font2Bold18 = UIFont(name: AppFontName.Raleway.RalewayBold, size: 20.0)!
            Font2Bold19 = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 21.0)!
            Font2Bold20 = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 22.0)!
            Font2Bold21 = UIFont(name: AppFontName.Raleway.RalewayBold, size: 23.0)!
            Font2Bold22 = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 24.0)!
            Font2Bold23 = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 25.0)!
            Font2Bold24 = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 26.0)!
            Font2Bold25 = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 27.0)!
            Font2Bold36 = UIFont(name: AppFontName.Raleway.RalewayBold, size: 38.0)!
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func checkVersion(){
        let nsObject: AnyObject? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as AnyObject
        let appVersion = nsObject as! String
        let prm:Parameters  = ["version":appVersion ,
                               "os": "iPhone"
        ]
        print(prm)
        MasterWebService.sharedInstance.POST_webservice(Url: EndPoints.User_CheckVersion_URL, prm: prm,  background: true,completion: { _result,_statusCode in
            print(_result)
            
            if _statusCode == 200 {
                
                if _result is NSDictionary {
                    print("dict")
                    print(_result)
                    let Responsedata: NSDictionary = _result as! NSDictionary
                    let status : Int =  Responsedata.value(forKey: "status") as! Int
                    let message : String = Responsedata.value(forKey: "message") as! String
                    if status == 1 {
                        
                    }else{
                        
                        let logOutAlert = UIAlertController(title: "Message", message: message, preferredStyle: UIAlertControllerStyle.alert)
                        
                        logOutAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                            if let url = URL(string: "itms-apps://itunes.apple.com/us/app/green-grubbox/id1343808215?ls=1&mt=8"),
                                UIApplication.shared.canOpenURL(url)
                            {
                                if #available(iOS 10.0, *) {
                                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                } else {
                                    UIApplication.shared.openURL(url)
                                }
                            }
                        }))
                        self.presentControllerOnWindow(controller: logOutAlert)
                    }
                }
            }
        })
    }
    
    func presentControllerOnWindow(controller:UIViewController){
        let alertWindow = UIApplication.shared.keyWindow!
        alertWindow.windowLevel = UIWindowLevelAlert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(controller, animated: true, completion: nil)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        checkVersion()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        checkVersion()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK: Firebase remote notification Handler
    func application(received remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    
    //MARK: Register For Push Notification
    func registerForPushNotifications(application: UIApplication) {
        if #available(iOS 10.0, *){
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted, error) in
                if (granted)
                {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                else{
                    //Do stuff if unsuccessful...
                }
            })
        } else {
            //If user is not on iOS 10 use the old methods we've been using
            let notificationSettings = UIUserNotificationSettings(types: [UIUserNotificationType.badge, UIUserNotificationType.sound, UIUserNotificationType.alert], categories: nil)
            application.registerUserNotificationSettings(notificationSettings)
        }
        
        FirebaseApp.configure() // fire base configrations
    }
    
    //MARK: Delegate Methods For Push Notification
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var token: String = ""
        for i in 0..<deviceToken.count {
            token += String(format: "%02.2hhx", deviceToken[i] as CVarArg)
        }
        print(token)
        DeviceToken = token
        UserDefaults.standard.set(token, forKey: "deviceToken")
        if let refreshedToken = InstanceID.instanceID().token() { print("InstanceID token: \(refreshedToken)")
            DeviceToken = Messaging.messaging().fcmToken!
            UserDefaults.standard.set(DeviceToken, forKey: "deviceToken")
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error){
        print("Device token not available in simulator \(error)")
    }
    
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        
        if appDelegate.TabbarCustomMain != nil {
            // if application.
            let state = UIApplication.shared.applicationState
            if state != .active {
                print("App in Background")
                appDelegate.TabbarCustomMain?.selectedIndex = 2
                img_Location.image = UIImage(named: "Tab_locations_off")
                img_Scranner.image = UIImage(named: "Tab_center")
                img_Account.image = UIImage(named: "Tab_account_on")
            }
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Print message ID.
        print(userInfo)
        if appDelegate.TabbarCustomMain != nil {
            // if application.
            let state = UIApplication.shared.applicationState
            if state != .active {
                print("App in Background")
                appDelegate.TabbarCustomMain?.selectedIndex = 2
                img_Location.image = UIImage(named: "Tab_locations_off")
                img_Scranner.image = UIImage(named: "Tab_center")
                img_Account.image = UIImage(named: "Tab_account_on")
            }else{
                
            }
        } else {
            
        }
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    //MARK: OTher global funtions
    func uicolorFromHex(rgbValue:UInt32)->UIColor
    {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    //MARK: validation for password
    func isValidPassword(password: String) -> Bool
    {
        //let passwordRegex  = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{3,32}"
        let passwordRegex  = "^.{6,32}"
        let passwordTest = NSPredicate(format:"SELF MATCHES %@", passwordRegex)
        return passwordTest.evaluate(with: password)
        
    }
    
    //MARK: alidation for email
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,50}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    //MARK: custom tabbar
    func createCustomTabBar(){
        TabbarCustomMain = UITabBarController()
        let LocationStoryboardId = "LocationVC"
        let ScannerStoryboardId = "ScannerVC"
        let AccountboardId = "AccountVC"
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle.main)
        let viewController1 = storyboard.instantiateViewController(withIdentifier: LocationStoryboardId) as! LocationVC
        let viewController2 = storyboard.instantiateViewController(withIdentifier: ScannerStoryboardId) as! ScannerVC
        let viewController3 = storyboard.instantiateViewController(withIdentifier: AccountboardId) as! AccountVC
        let viewControllers : NSMutableArray = NSMutableArray(capacity: 3)
        
        for i in 0...3
        {
            if (i==0)
            {
                viewController = UINavigationController.init(rootViewController: viewController1)
            }else if (i==1)
            {
                viewController = UINavigationController.init(rootViewController: viewController2)
                
            }else if (i==2)
            {
                viewController = UINavigationController.init(rootViewController: viewController3)
            }
            viewController.navigationBar.isHidden = true
            viewControllers.add(viewController)
        }
        TabbarCustomMain?.viewControllers = [viewControllers[0] as! UIViewController,viewControllers[1] as! UIViewController,viewControllers[2] as! UIViewController]
        TabbarCustomMain?.delegate = self
        TabbarCustomMain?.selectedIndex = 0
        TabbarCustomMain?.tabBar.tintColor = UIColor.clear
        TabbarCustomMain?.tabBar.backgroundColor = UIColor.clear
        TabbarCustomMain?.tabBar.isHidden = true
        let device : Model = UIDevice().type
        
        var HeightForTabbar : CGFloat = 80.0
        if device == .iPhoneX {
            HeightForTabbar =  HeightForTabbar + 20
        }
        tabBarView.frame = CGRect(x: 0, y:(self.window?.bounds.height)! - HeightForTabbar, width: (self.TabbarCustomMain?.view.frame.width)!, height: HeightForTabbar)
        
        //btnLocation
        btnLocation.frame = CGRect(x: 0, y: 0, width: (self.TabbarCustomMain?.view.frame.width)! / 3, height: HeightForTabbar)
        btnLocation.isSelected = true
        btnLocation.addTarget(self, action:#selector(AppDelegate.tabBarClick(_:)), for: UIControlEvents.touchUpInside)
        btnLocation.tag = 0
        btnLocation.backgroundColor = UIColor.clear
        btnLocation.setTitleColor(UIColor.clear, for: UIControlState.normal)
        img_Location.image = UIImage(named: "Tab_locations_on")
        btnLocation.contentMode = .scaleToFill
        
        // btnScranner
        btnScranner.frame = CGRect(x:  btnLocation.frame.width, y: 0, width: btnLocation.frame.width, height: HeightForTabbar)
        btnScranner.isSelected = false
        btnScranner.addTarget(self, action: #selector(AppDelegate.tabBarClick(_:)), for: UIControlEvents.touchUpInside)
        btnScranner.tag = 1
        btnScranner.setTitleColor(UIColor.black, for: UIControlState.normal)
        img_Scranner.image = UIImage(named: "Tab_center")
        btnScranner.contentMode = .scaleToFill
        
        // btnAccount
        btnAccount.frame = CGRect(x: btnLocation.frame.width + btnScranner.frame.width , y: 0, width: btnLocation.frame.width, height: HeightForTabbar)
        btnAccount.isSelected = false
        btnAccount.addTarget(self, action: #selector(AppDelegate.tabBarClick(_:)), for: UIControlEvents.touchUpInside)
        btnAccount.tag = 2
        btnAccount.setTitleColor(UIColor.black, for: UIControlState.normal)
        img_Account.image = UIImage(named: "Tab_account_off")
        btnAccount.contentMode = .scaleToFill
        
        tabBarView.backgroundColor = UIColor.clear
        img_Location.frame = btnLocation.frame
        img_Scranner.frame = btnScranner.frame
        img_Account.frame = btnAccount.frame
        
        imgMain_Location.frame = CGRect(x: btnLocation.frame.origin.x, y: btnLocation.frame.origin.y, width: btnLocation.frame.width, height: btnLocation.frame.width / 1.7)
        imgMain_Scranner.frame = CGRect(x: btnScranner.frame.origin.x, y: btnScranner.frame.origin.y, width: btnScranner.frame.width, height: btnScranner.frame.width / 1.7)
        imgMain_Account.frame = CGRect(x: btnAccount.frame.origin.x, y: btnAccount.frame.origin.y, width: btnAccount.frame.width, height: btnAccount.frame.width / 1.7)
        
        imgMain_Location.image = UIImage(named: "locations_icon")
        imgMain_Scranner.image = UIImage(named: "scan_icon")
        imgMain_Account.image = UIImage(named: "account_icon")
        tabBarView.addSubview(img_Location)
        tabBarView.addSubview(img_Scranner)
        tabBarView.addSubview(img_Account)
        tabBarView.addSubview(imgMain_Location)
        tabBarView.addSubview(imgMain_Scranner)
        tabBarView.addSubview(imgMain_Account)
        tabBarView.addSubview(btnLocation)
        tabBarView.addSubview(btnScranner)
        tabBarView.addSubview(btnAccount)
        TabbarCustomMain?.view.addSubview(tabBarView)
        self.TabbarCustomMain?.selectedIndex = 0
    }
    
    @objc func tabBarClick(_ sender:UIButton)
    {
        let array : NSArray = TabbarCustomMain!.viewControllers! as NSArray
        let nav :UINavigationController = array.object(at: sender.tag) as! UINavigationController
        nav.popToRootViewController(animated: true)
        LastTabSelected = sender.tag
        switch (sender.tag)
        {
        case 0:
            self.TabbarCustomMain?.selectedIndex = 0
            self.tabBarView.isHidden = false
            img_Location.image = UIImage(named: "Tab_locations_on")
            img_Scranner.image = UIImage(named: "Tab_center")
            img_Account.image = UIImage(named: "Tab_account_off")
            break;
        case 1:
            self.TabbarCustomMain?.selectedIndex = 1
            self.tabBarView.isHidden = false
            img_Location.image = UIImage(named: "Tab_locations_off")
            img_Scranner.image = UIImage(named: "Tab_center")
            img_Account.image = UIImage(named: "Tab_account_off")
            break;
        case 2:
            self.TabbarCustomMain?.selectedIndex = 2
            self.tabBarView.isHidden = false
            img_Location.image = UIImage(named: "Tab_locations_off")
            img_Scranner.image = UIImage(named: "Tab_center")
            img_Account.image = UIImage(named: "Tab_account_on")
            break;
        default:
            self.TabbarCustomMain?.selectedIndex = 0
            self.tabBarView.isHidden = false
            img_Location.image = UIImage(named: "Tab_locations_off")
            img_Scranner.image = UIImage(named: "Tab_center")
            img_Account.image = UIImage(named: "Tab_account_off")
            break;
        }
    }
    
    func BoardercolorOfView(sender: UIView,color : UIColor,borderWidth: CGFloat,cornerRadius: CGFloat){
        // Border
        sender.layer.masksToBounds = true
        sender.layer.cornerRadius = cornerRadius
        sender.layer.borderColor = color.cgColor
        sender.layer.borderWidth = borderWidth
        sender.clipsToBounds = true
    }
    
    func ShowShadow(sender:UIView,color : UIColor,shadowRadius: CGFloat,shadowOpacity: CGFloat,shadowOffset:CGSize){
        // shadow
        sender.layer.shadowColor = color.cgColor
        sender.layer.masksToBounds = false
        sender.layer.shadowOffset = shadowOffset
        sender.layer.shadowRadius = shadowRadius
        sender.layer.shadowOpacity = Float(shadowOpacity)
    }
}

extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}

