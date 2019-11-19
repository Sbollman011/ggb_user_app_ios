//
//  Constants.swift
//  GOIN
//
//  Created by RAVI on 8/4/17.
//  Copyright ©  2017 RAVI. All rights reserved.
//

import Foundation
import UIKit
let Device_MOdel_name : Model = UIDevice().type
var DeviceSize : CGSize = CGSize()
var DeviceToken : String = ""
    //view.frame.size
let DeviceOSVersion: String = UIDevice.current.systemVersion
var appDelegate = UIApplication.shared.delegate as! AppDelegate
var LoginUserId : String = ""
var LoginToken : String = ""
var User_Latitute : Double = Double()
var User_Langitute : Double = Double()
var isLatestPhase:Bool = false
struct EndPoints {
    
    
    //static let serverPath = "http://52.37.233.101:5000" // Staging
    
    static let serverPath = "http://api.greengrubbox.com" // Live
    
    //static let serverPath = "http://192.168.0.9:5000" // Local
    
    
    //static let strip_key = "pk_live_Jd6lGHcwAsJj7Dctv1DQDAQ2" // Live
    
    static let strip_key = "pk_test_YjaymUsbEdEjfIflmv3S3XhW" // Staging
    
    
    static let Login_URL = "/v1/user/signIn"
    static let Signup_URL = "/v1/user/signUp"
    static let ForgotPassword_URL = "/user/forgot-password"
    static let package_URL =  "/packages"
    static let Complete_registration_URL =  "/v1/user/completeRegistration"
    static let Box_checkOut_URL =  "/user/box-checkOut"
    static let Box_History_URL = "/user/history"
    static let User_Detail_URL = "/user"
    static let User_LogOut_URL = "/user/logout"
    static let User_Vendors_URL = "/user/vendors"
    static let User_VerifyOTP_URL = "/user/verifyOTP"
    static let User_ResendOTP_URL = "/user/resendOTP"
    static let User_CheckVersion_URL = "/validateAppVersion"
    static let User_ChangeMembership_URL = "/user/migrate/membership"
    static let User_EmailVerfiy_URL = "/user/migrate/verifyEmail"
    static let User_EmailVerfiyOTP_URL = "/user/migrate/verifyOTP"   
}

//MARK: Font stup
struct AppFontName {
    
    //Font Family Name = [Lato]
    //Font Names = [["Lato-Bold"]]
    //Font Family Name = [Raleway]
   // Font Names = [["Raleway-Bold"]]
    
    static let LatoName = "Lato"
    struct Lato {
        static let LatoBold : String = "Lato-Bold"
        static let LatoRegular  : String = "Lato"
    }
    static let RalewayName = "Raleway"
    struct Raleway {
        static let RalewayBold : String = "Raleway-Bold"
        static let RalewayRegular  : String = "Raleway"
    }
    
    //Mostra Nuova Bold
    //Mostra Nuova Regular
    
    static let MostraName = "Mostra Nuova"
    struct Mostra {
        static let MostraBold : String = "MostraNuova-Bold"
        static let MostraRegular  : String = "MostraNuova"
    }
}

//iphone 6

var FontNormal10 : UIFont = UIFont(name:  AppFontName.Lato.LatoRegular, size: 10.0)!
var FontNormal11 : UIFont = UIFont(name:  AppFontName.Lato.LatoRegular, size: 11.0)!
var FontNormal12 : UIFont = UIFont(name:  AppFontName.Lato.LatoRegular, size: 12.0)!
var FontNormal13 : UIFont = UIFont(name:  AppFontName.Lato.LatoRegular, size: 13.0)!
var FontNormal14 : UIFont = UIFont(name:  AppFontName.Lato.LatoRegular, size: 14.0)!
var FontNormal15 : UIFont = UIFont(name:  AppFontName.Lato.LatoRegular, size: 15.0)!
var FontNormal16 : UIFont = UIFont(name:  AppFontName.Lato.LatoRegular, size: 16.0)!
var FontNormal17 : UIFont = UIFont(name:  AppFontName.Lato.LatoRegular, size: 17.0)!
var FontNormal18 : UIFont = UIFont(name:  AppFontName.Lato.LatoRegular, size: 18.0)!
var FontNormal19 : UIFont = UIFont(name:  AppFontName.Lato.LatoRegular, size: 19.0)!
var FontNormal20 : UIFont = UIFont(name:  AppFontName.Lato.LatoRegular, size: 20.0)!
var FontNormal21 : UIFont = UIFont(name:  AppFontName.Lato.LatoRegular, size: 21.0)!
var FontNormal22 : UIFont = UIFont(name:  AppFontName.Lato.LatoRegular, size: 22.0)!
var FontNormal23 : UIFont = UIFont(name:  AppFontName.Lato.LatoRegular, size: 23.0)!
var FontNormal24 : UIFont = UIFont(name:  AppFontName.Lato.LatoRegular, size: 24.0)!
var FontNormal25 : UIFont = UIFont(name:  AppFontName.Lato.LatoRegular, size: 25.0)!
var FontNormal26 : UIFont = UIFont(name:  AppFontName.Lato.LatoRegular, size: 26.0)!

//bold
var FontBold10: UIFont = UIFont(name:  AppFontName.Lato.LatoBold, size: 10.0)!
var FontBold11 : UIFont = UIFont(name:  AppFontName.Lato.LatoBold, size: 11.0)!
var FontBold12 : UIFont = UIFont(name:  AppFontName.Lato.LatoBold, size: 12.0)!
var FontBold13 : UIFont = UIFont(name:  AppFontName.Lato.LatoBold, size: 13.0)!
var FontBold14 : UIFont = UIFont(name:  AppFontName.Lato.LatoBold, size: 14.0)!
var FontBold15 : UIFont = UIFont(name:  AppFontName.Lato.LatoBold, size: 15.0)!
var FontBold16 : UIFont = UIFont(name:  AppFontName.Lato.LatoBold, size: 16.0)!
var FontBold17 : UIFont = UIFont(name:  AppFontName.Lato.LatoBold, size: 17.0)!
var FontBold18 : UIFont = UIFont(name:  AppFontName.Lato.LatoBold, size: 18.0)!
var FontBold19 : UIFont = UIFont(name:  AppFontName.Lato.LatoBold, size: 19.0)!
var FontBold20 : UIFont = UIFont(name:  AppFontName.Lato.LatoBold, size: 20.0)!
var FontBold21 : UIFont = UIFont(name:  AppFontName.Lato.LatoBold, size: 21.0)!
var FontBold22 : UIFont = UIFont(name:  AppFontName.Lato.LatoBold, size: 22.0)!
var FontBold23 : UIFont = UIFont(name:  AppFontName.Lato.LatoBold, size: 23.0)!
var FontBold24 : UIFont = UIFont(name:  AppFontName.Lato.LatoBold, size: 24.0)!
var FontBold25 : UIFont = UIFont(name:  AppFontName.Lato.LatoBold, size: 25.0)!

var FontBold28 : UIFont = UIFont(name:  AppFontName.Lato.LatoBold, size: 28.0)!
var FontBold36 : UIFont = UIFont(name:  AppFontName.Lato.LatoBold, size: 36.0)!
//MARK: font 2

//iphone 6
//var Font2Normal10 : UIFont = UIFont(name:  AppFontName.Raleway.RalewayRegular, size: 10.0)!
//var Font2Normal11 : UIFont = UIFont(name:  AppFontName.Raleway.RalewayRegular, size: 11.0)!
//var Font2Normal12 : UIFont = UIFont(name:  AppFontName.Raleway.RalewayRegular, size: 12.0)!
//var Font2Normal13 : UIFont = UIFont(name:  AppFontName.Raleway.RalewayRegular, size: 13.0)!
//var Font2Normal14 : UIFont = UIFont(name:  AppFontName.Raleway.RalewayRegular, size: 14.0)!
//var Font2Normal15 : UIFont = UIFont(name:  AppFontName.Raleway.RalewayRegular, size: 15.0)!
//var Font2Normal16 : UIFont = UIFont(name:  AppFontName.Raleway.RalewayRegular, size: 16.0)!
//var Font2Normal17 : UIFont = UIFont(name:  AppFontName.Raleway.RalewayRegular, size: 17.0)!
//var Font2Normal18 : UIFont = UIFont(name:  AppFontName.Raleway.RalewayRegular, size: 18.0)!
//var Font2Normal19 : UIFont = UIFont(name:  AppFontName.Raleway.RalewayRegular, size: 19.0)!
//var Font2Normal20 : UIFont = UIFont(name:  AppFontName.Raleway.RalewayRegular, size: 20.0)!
//var Font2Normal21 : UIFont = UIFont(name:  AppFontName.Raleway.RalewayRegular, size: 21.0)!
//var Font2Normal22 : UIFont = UIFont(name:  AppFontName.Raleway.RalewayRegular, size: 22.0)!
//var Font2Normal23 : UIFont = UIFont(name:  AppFontName.Raleway.RalewayRegular, size: 23.0)!
//var Font2Normal24 : UIFont = UIFont(name:  AppFontName.Raleway.RalewayRegular, size: 24.0)!
//var Font2Normal25 : UIFont = UIFont(name:  AppFontName.Raleway.RalewayRegular, size: 25.0)!
//var Font2Normal26 : UIFont = UIFont(name:  AppFontName.Raleway.RalewayRegular, size: 26.0)!

//bold
var Font2Bold10: UIFont = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 10.0)!
var Font2Bold11 : UIFont = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 11.0)!
var Font2Bold12 : UIFont = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 12.0)!
var Font2Bold13 : UIFont = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 13.0)!
var Font2Bold14 : UIFont = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 14.0)!
var Font2Bold15 : UIFont = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 15.0)!
var Font2Bold16 : UIFont = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 16.0)!
var Font2Bold17 : UIFont = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 17.0)!
var Font2Bold18 : UIFont = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 18.0)!
var Font2Bold19 : UIFont = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 19.0)!
var Font2Bold20 : UIFont = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 20.0)!
var Font2Bold21 : UIFont = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 21.0)!
var Font2Bold22 : UIFont = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 22.0)!
var Font2Bold23 : UIFont = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 23.0)!
var Font2Bold24 : UIFont = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 24.0)!
var Font2Bold25 : UIFont = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 25.0)!
var Font2Bold26 : UIFont = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 26.0)!
var Font2Bold27 : UIFont = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 27.0)!
var Font2Bold28 : UIFont = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 28.0)!
var Font2Bold36 : UIFont = UIFont(name:  AppFontName.Raleway.RalewayBold, size: 36.0)!

