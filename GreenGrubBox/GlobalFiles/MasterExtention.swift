//
//  MasterExtention.swift
//  GOIN
//
//  Created by RAVI on 8/10/17.
//  Copyright ©  2017 RAVI. All rights reserved.
//

import UIKit



//MARK: Alert Extention
extension UIAlertAction{
    @NSManaged var image : UIImage?
    convenience init(title: String?, style: UIAlertActionStyle,image : UIImage?, handler: ((UIAlertAction) -> Swift.Void)? = nil ){
        self.init(title: title, style: style, handler: handler)
        self.image = image
    }
}

//MARK: String Extention
extension String {
    
    var stringByRemovingWhitespaces: String {
        return components(separatedBy: .whitespaces).joined(separator: "")
    }
    
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    func condenseWhitespace() -> String {
        return components(separatedBy: .whitespaces).filter({!$0.isEmpty}).joined(separator: " ")
        // componentsSeparatedByCharactersInSet(.whitespaceCharacterSet())
        // .filter { !$0.isEmpty }
        // .joinWithSeparator(" ")
    }
}

//MARK: Color Extention
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

extension NSString {
    func whitespacesAndNewlines() -> NSString {
        return trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) as NSString
    }
}

//MARK: UIButton Extention
extension UIButton {
    func underline() {
    }
    func buttonCircular() {
        self.layer.cornerRadius = self.frame.width/2
        self.layer.masksToBounds = true
    }
}

//MARK: Image Extention
extension UIImage {
    func crop( rect: CGRect,sscale:CGFloat ) -> UIImage {
        let sbscale = 1.0 / sscale
        var rect = rect
        rect.origin.x *= sbscale
        rect.origin.y *=  sbscale
        rect.size.width *= sbscale
        rect.size.height *= sbscale
        
        let imageRef = self.cgImage!.cropping(to: rect)
        let image = UIImage(cgImage: imageRef!)
        
        return image
    }
    
    func maskWithFullColor(color: UIColor ,full: Bool) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        var bounds: CGRect = CGRect()
        if full == true {
            bounds = CGRect(x: 0, y: 0, width: width, height: height)
        }else {
            bounds = CGRect(x: 0, y: 0, width: width / 2, height: height)
        }
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
}

//MARK: ImageView Extention
extension UIImageView{
    public func imageFromUrl(urlString: String) {
        MasterWebService.sharedInstance.GET_WithHeader_DataRespons(Url: urlString, prm: [:], auth: true, completion: {imgData,statusCod in
            self.image = UIImage(data: (imgData as? Data)!)
        })
    }
    
    public func imageFromServerURL(urlString: String) {
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            print("url string",urlString)
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }

    public func imageFromServerURLWithBlurEffect(urlString: String) {
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            print("url string",urlString)
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image =  image// MasterFunctions.sharedInstance.blurEffect(img: image!)
            })
            
        }).resume()
    }
    
    func imageCircular() {
        self.layer.cornerRadius = self.frame.width/2
        self.layer.masksToBounds = true
    }
    
    func showImage(urlofimage: String){
        self.createDirectory()
        
        let imgarr = urlofimage.components(separatedBy: "/")
        let extantion_name: String = imgarr[imgarr.count - 1]
        self.image = UIImage(named: "contect_user_img.png")
        self.contentMode = .scaleAspectFit
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: "\(path)/MyappDirectory")
        let filePath = url.appendingPathComponent(extantion_name)?.path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath!) {
            //print("FILE AVAILABLE")
            self.image = UIImage(named: "contect_user_img.png")
            self.contentMode = .scaleAspectFit
            if (self.getImage(imagePAth: filePath!)){
            }
        }else{
            //  print("FILE NOT AVAILABLE")
            self.downloadImageFrom(link: urlofimage,contentMode:UIViewContentMode.scaleToFill,nameofImage:extantion_name,indicate: nil)
        }
    }
    
    func ShowImageFromUrl(urlofimage: String, frame: CGRect){
        self.createDirectory()
        let imgarr = urlofimage.components(separatedBy: "/")
        let extantion_name: String = imgarr[imgarr.count - 1]
        self.image = UIImage(named: "contect_user_img.png")
        self.contentMode = .scaleAspectFit
        let indicatore_profilePic: UIActivityIndicatorView = UIActivityIndicatorView()
        indicatore_profilePic.frame = CGRect(x: frame.width / 2 - 10, y: frame.height / 2 - 10, width: 20, height: 20)
        indicatore_profilePic.color = UIColor.white
        indicatore_profilePic.startAnimating()
        indicatore_profilePic.color = UIColor.black
        self.addSubview(indicatore_profilePic)
        self.bringSubview(toFront: indicatore_profilePic)
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: "\(path)/MyappDirectory")
        let filePath = url.appendingPathComponent(extantion_name)?.path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath!) {
            self.image = UIImage(named: "contect_user_img.png")
            self.contentMode = .scaleAspectFit
            if (self.getImage(imagePAth: filePath!)){
                indicatore_profilePic.stopAnimating()
                indicatore_profilePic.isHidden = true
            }
        }else{
            self.downloadImageFrom(link: urlofimage,contentMode:UIViewContentMode.scaleToFill,nameofImage:extantion_name,indicate: indicatore_profilePic)
        }
    }
    
    //MARK: show image with activity indicatore
    func ShowImageFromUrlWithActivityIndicatore(urlofimage: String, frame: CGRect, indicatore : UIActivityIndicatorView) {
        self.createDirectory()
        let imgarr = urlofimage.components(separatedBy: "/")
        let extantion_name: String = imgarr[imgarr.count - 1]
        indicatore.color = UIColor.white
        indicatore.startAnimating()
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: "\(path)/MyappDirectory")
        let filePath = url.appendingPathComponent(extantion_name)?.path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath!) {
            //print("FILE AVAILABLE")
            self.image = UIImage(named: "contect_user_img.png")
            self.contentMode = .scaleAspectFit
            if (self.getImage(imagePAth: filePath!)){
                indicatore.stopAnimating()
                indicatore.isHidden = true
            }
        }else{
            //  print("FILE NOT AVAILABLE")
            self.image = UIImage(named: "contect_user_img.png")
            self.contentMode = .scaleAspectFit
            self.downloadImageFrom(link: urlofimage,contentMode:UIViewContentMode.scaleToFill,nameofImage:extantion_name,indicate: indicatore)
        }
    }
    
    private func downloadImageFrom(link:String, contentMode: UIViewContentMode,nameofImage: String, indicate: UIActivityIndicatorView?) {
        // ClaudFruntUrl +
        URLSession.shared.dataTask( with: NSURL(string:link)! as URL, completionHandler: {
            (data, response, error) -> Void in
            
            DispatchQueue.main.async() { () -> Void in
                self.contentMode =  contentMode
                if (error == nil){
                    if (data == nil){
                        self.image = UIImage(named: "contect_user_img.png")
                        self.contentMode = .scaleAspectFit
                        indicate?.stopAnimating()
                        indicate?.isHidden = true
                    }
                    else if (data != nil)
                    {
                        if let getImage = UIImage(data: data!) {
                            self.image = getImage
                            self.contentMode = .scaleAspectFit
                            self.saveImageDocumentDirectory(sender: getImage,name: nameofImage)
                            // print("download from link\(link)")
                        }
                        indicate?.stopAnimating()
                        indicate?.isHidden = true
                    }
                }
            }
        }).resume()
    }
    
    private func saveImageDocumentDirectory(sender: UIImage , name : String){
        let fileManager = FileManager.default
        print("save with link === >>> \(name)")
        let paths2 = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("MyappDirectory/\(name)")
        let imageData = UIImageJPEGRepresentation(sender, 0.5)!
        fileManager.createFile(atPath: paths2 as String, contents: imageData, attributes: nil)
    }
    
    private func getImage(imagePAth : String) -> Bool {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: imagePAth){
            if let img :UIImage? = UIImage(contentsOfFile: imagePAth)! {
                self.image = img
                self.contentMode = .scaleAspectFit
                return true
            }
            return false
        }else{
            return false
        }
    }
    
    private  func createDirectory(){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("MyappDirectory")
        if !fileManager.fileExists(atPath: paths){
            // print("Already dictionary created.")
        }else{
            
            try! fileManager.createDirectory(atPath: paths, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    private  func deleteDirectory(){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("MyappDirectory")
        if fileManager.fileExists(atPath: paths){
            try! fileManager.removeItem(atPath: paths)
        }else{
            //print("directory not created Something wronge.")
        }
    }
}

//MARK:  UIViewController
extension UIViewController  {
    func showAlert(withTitle title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        let action = alert.actions[0]
        action.setValue(UIColor.black, forKey: "titleTextColor")
        
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK:  UILabel
extension UILabel {
    var numberOfVisibleLines: Int {
        let textSize = CGSize(width: CGFloat(self.frame.size.width), height: CGFloat(MAXFLOAT))
        let rHeight: Int = lroundf(Float(self.sizeThatFits(textSize).height))
        let charSize: Int = lroundf(Float(self.font.pointSize))
        return rHeight / charSize
    }
}

extension UIViewController {
    public func showErrorToast(message:String, duration:Int = 2000, backgroundColor : UIColor) {
        let ToastView: UIView = UIView()
        ToastView.backgroundColor = backgroundColor
        
        let toastLabel : UILabel = UILabel()
        toastLabel.backgroundColor = UIColor.clear
        toastLabel.textColor = UIColor.white;
        toastLabel.textAlignment = .center;
        toastLabel.text = message;
        toastLabel.font = FontNormal16
        toastLabel.numberOfLines = 0;
        
        ToastView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height:50)
        toastLabel.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        
        self.view.addSubview(ToastView)
        ToastView.addSubview(toastLabel)
        UIView.animate(withDuration:0.3, delay:0.0, options:[], animations: {
            ToastView.frame = CGRect(x: 0, y: self.view.frame.height - 50, width: self.view.frame.width, height:50)
        }) { (Bool) in
            UIView.animate(withDuration:0.5, delay:Double(duration) / 1000.0, options:[], animations: {
                ToastView.frame = CGRect(x: 0, y: self.view.frame.height, width: self.view.frame.width, height: 50)
            }) { (Bool) in
                toastLabel.removeFromSuperview()
                ToastView.removeFromSuperview()
            }
        }
    }
    
    func showToast(message : String) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = FontNormal12
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

//MARK: View Extention
extension UIView {
    func fadeIn(withDuration duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 1.0
        })
    }
    
    /// Fade out a view with a duration
    /// - Parameter duration: custom animation duration
    func fadeOut(withDuration duration: TimeInterval = 1.0) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0.0
        })
    }
    
    public func showToast(message:String, duration:Int = 2000) {
        //        let toastLabel = UIPaddingLabel();
        //        toastLabel.padding = 10;
        //        toastLabel.translatesAutoresizingMaskIntoConstraints = false;
        //        toastLabel.backgroundColor = UIColor.darkGray;
        //        toastLabel.textColor = UIColor.white;
        //        toastLabel.textAlignment = .center;
        //        toastLabel.text = message;
        //        toastLabel.numberOfLines = 0;
        //        toastLabel.alpha = 0.9;
        //        toastLabel.layer.cornerRadius = 20;
        //        toastLabel.clipsToBounds = true;
        //        self.addSubview(toastLabel);
        //        self.addConstraint(NSLayoutConstraint(item:toastLabel, attribute:.left, relatedBy:.greaterThanOrEqual, toItem:self, attribute:.left, multiplier:1, constant:20));
        //        self.addConstraint(NSLayoutConstraint(item:toastLabel, attribute:.right, relatedBy:.lessThanOrEqual, toItem:self, attribute:.right, multiplier:1, constant:-20));
        //        self.addConstraint(NSLayoutConstraint(item:toastLabel, attribute:.bottom, relatedBy:.equal, toItem:self, attribute:.bottom, multiplier:1, constant:-70));
        //        self.addConstraint(NSLayoutConstraint(item:toastLabel, attribute:.centerX, relatedBy:.equal, toItem:self, attribute:.centerX, multiplier:1, constant:0));
        //        UIView.animate(withDuration:0.5, delay:Double(duration) / 1000.0, options:[], animations: {
        //            toastLabel.alpha = 0.0;
        //        }) { (Bool) in
        //            toastLabel.removeFromSuperview();
        //        }
    }
} 

////Getting Device modal name
//let modelName = UIDevice.current.modelName
//print(modelName)
public enum Model : String {
    case simulator     = "simulator/sandbox",
    iPod1              = "iPod 1",
    iPod2              = "iPod 2",
    iPod3              = "iPod 3",
    iPod4              = "iPod 4",
    iPod5              = "iPod 5",
    iPad2              = "iPad 2",
    iPad3              = "iPad 3",
    iPad4              = "iPad 4",
    iPad5              = "iPad 5",
    iPhone4            = "iPhone 4",
    iPhone4S           = "iPhone 4S",
    iPhone5            = "iPhone 5",
    iPhone5S           = "iPhone 5S",
    iPhone5C           = "iPhone 5C",
    iPadMini1          = "iPad Mini 1",
    iPadMini2          = "iPad Mini 2",
    iPadMini3          = "iPad Mini 3",
    iPadAir1           = "iPad Air 1",
    iPadAir2           = "iPad Air 2",
    iPadPro9_7         = "iPad Pro 9.7\"",
    iPadPro9_7_cell    = "iPad Pro 9.7\" cellular",
    iPadPro12_9        = "iPad Pro 12.9\"",
    iPadPro12_9_cell   = "iPad Pro 12.9\" cellular",
    iPadPro2_12_9      = "iPad Pro 2 12.9\"",
    iPadPro2_12_9_cell = "iPad Pro 2 12.9\" cellular",
    iPhone6            = "iPhone 6",
    iPhone6plus        = "iPhone 6 Plus",
    iPhone6S           = "iPhone 6S",
    iPhone6Splus       = "iPhone 6S Plus",
    iPhoneSE           = "iPhone SE",
    iPhone7            = "iPhone 7",
    iPhone7plus        = "iPhone 7 Plus",
    iPhone8            = "iPhone 8",
    iPhone8plus        = "iPhone 8 Plus",
    iPhoneX            = "iPhone X",
    unrecognized       = "?unrecognized?"
}

// #-#-#-#-#-#-#-#-#-#-#-#-#-#-#
//MARK: UIDevice extensions
// #-#-#-#-#-#-#-#-#-#-#-#-#-#-#
public extension UIDevice {
    public var type: Model {
        var systemInfo = utsname()
        uname(&systemInfo)
        let modelCode = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                ptr in String.init(validatingUTF8: ptr)
            }
        }
        var modelMap : [ String : Model ] = [
            "i386"      : .simulator,
            "x86_64"    : .simulator,
            "iPod1,1"   : .iPod1,
            "iPod2,1"   : .iPod2,
            "iPod3,1"   : .iPod3,
            "iPod4,1"   : .iPod4,
            "iPod5,1"   : .iPod5,
            "iPad2,1"   : .iPad2,
            "iPad2,2"   : .iPad2,
            "iPad2,3"   : .iPad2,
            "iPad2,4"   : .iPad2,
            "iPad2,5"   : .iPadMini1,
            "iPad2,6"   : .iPadMini1,
            "iPad2,7"   : .iPadMini1,
            "iPhone3,1" : .iPhone4,
            "iPhone3,2" : .iPhone4,
            "iPhone3,3" : .iPhone4,
            "iPhone4,1" : .iPhone4S,
            "iPhone5,1" : .iPhone5,
            "iPhone5,2" : .iPhone5,
            "iPhone5,3" : .iPhone5C,
            "iPhone5,4" : .iPhone5C,
            "iPad3,1"   : .iPad3,
            "iPad3,2"   : .iPad3,
            "iPad3,3"   : .iPad3,
            "iPad3,4"   : .iPad4,
            "iPad3,5"   : .iPad4,
            "iPad3,6"   : .iPad4,
            "iPhone6,1" : .iPhone5S,
            "iPhone6,2" : .iPhone5S,
            "iPad4,2"   : .iPadAir1,
            "iPad5,4"   : .iPadAir2,
            "iPad4,4"   : .iPadMini2,
            "iPad4,5"   : .iPadMini2,
            "iPad4,6"   : .iPadMini2,
            "iPad4,7"   : .iPadMini3,
            "iPad4,8"   : .iPadMini3,
            "iPad4,9"   : .iPadMini3,
            "iPad6,3"   : .iPadPro9_7,
            "iPad6,4"   : .iPadPro9_7_cell,
            "iPad6,12"  : .iPad5,
            "iPad6,7"   : .iPadPro12_9,
            "iPad6,8"   : .iPadPro12_9_cell,
            "iPad7,1"   : .iPadPro2_12_9,
            "iPad7,2"   : .iPadPro2_12_9_cell,
            "iPhone7,1" : .iPhone6plus,
            "iPhone7,2" : .iPhone6,
            "iPhone8,1" : .iPhone6S,
            "iPhone8,2" : .iPhone6Splus,
            "iPhone8,4" : .iPhoneSE,
            "iPhone9,1" : .iPhone7,
            "iPhone9,2" : .iPhone7plus,
            "iPhone9,3" : .iPhone7,
            "iPhone9,4" : .iPhone7plus,
            "iPhone10,3" : .iPhoneX,
            "iPhone10,4" : .iPhone8,
            "iPhone10,5" : .iPhone8plus
        ]
        
        if let model = modelMap[String.init(validatingUTF8: modelCode!)!] {
            if model == .simulator {
                if let simModelCode = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] {
                    if let simModel = modelMap[String.init(validatingUTF8: simModelCode)!] {
                        return simModel
                    }
                }
            }
            return model
        }
        return Model.unrecognized
    }
}
