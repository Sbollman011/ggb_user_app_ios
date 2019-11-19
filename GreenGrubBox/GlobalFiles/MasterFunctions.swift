//
//  MasterFunctions.swift
//  GOIN
//
//  Created by RAVI on 8/23/17.
//  Copyright ©  2017 RAVI. All rights reserved.
//

import Foundation
import UIKit
open class MasterFunctions: NSObject{
    
    open class var sharedInstance : MasterFunctions {
        struct MasterFunctionsInstanc {
            static let instance = MasterFunctions()
        }
        return MasterFunctionsInstanc.instance
    }
    
    
    func convertDate(intDate:Int,formatStr:String) -> String{
        let date:Date  = Date(timeIntervalSince1970:Double(intDate / 1000))
        print(date)
        let InvitedateFormatter: DateFormatter = DateFormatter()
        InvitedateFormatter.dateStyle = DateFormatter.Style.long
        
        let  convertedDate = InvitedateFormatter.string(from: date)
        InvitedateFormatter.timeZone = TimeZone(identifier:"GMT")
      
        print(",",convertedDate)
        InvitedateFormatter.dateFormat = formatStr
            print(InvitedateFormatter.string(from: date))
        return InvitedateFormatter.string(from: date)
    }
    
    
    let context = CIContext(options: nil)
    func blurEffect(img:UIImage) -> UIImage {
        let currentFilter = CIFilter(name: "CIGaussianBlur")
        if  img != nil {
            let beginImage = CIImage(image:img)
            currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
            currentFilter!.setValue(10, forKey: kCIInputRadiusKey)
            
            let cropFilter = CIFilter(name: "CICrop")
            cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
            cropFilter!.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")
            
            let output = cropFilter!.outputImage
            let cgimg = context.createCGImage(output!, from: output!.extent)
            let processedImage = UIImage(cgImage: cgimg!)
            return processedImage
        }
        return img
    }

}
