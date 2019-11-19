//
//  PinVerify.swift
//  Prowler
//
//  Created by dev15 on 4/13/18.
//  Copyright © 2018 dev. All rights reserved.
//
import Foundation
import UIKit

class PinVerify: UIView {
    
    @IBOutlet weak var ViewForMain: UIView!
    
    // Call back implementation
    public typealias PinVerifyCallback = ( NSDictionary?,Bool?) -> Void
    private var callback: PinVerifyCallback?
    
    // MARK: - Dialog initialization
    override open func awakeFromNib() {
        super.awakeFromNib()
        ViewForMain.layer.cornerRadius = 5.0
        ViewForMain.clipsToBounds = true
    }
    
    func instanceFromNib() -> UIView {
        return UINib(nibName: "PinVerify", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PinVerify
    }
    
    func Setup(){
        self.layoutIfNeeded()
        self.setNeedsDisplay()
    }
    
    open func addDiaLogToView(callback: @escaping PinVerifyCallback){
        let window = UIApplication.shared.keyWindow!
        let PickerDialog: PinVerify = instanceFromNib() as! PinVerify
        PickerDialog.frame = (window.frame)
        PickerDialog.callback = callback
        PickerDialog.Setup()
        window.addSubview(PickerDialog)
        window.bringSubview(toFront: PickerDialog)
        window.endEditing(true)
    }
    
    @IBAction func ActionOnCloseBtn(_ sender: UIButton) {
        self.callback?(nil, false)
       self.removeFromSuperview()
    }
}
