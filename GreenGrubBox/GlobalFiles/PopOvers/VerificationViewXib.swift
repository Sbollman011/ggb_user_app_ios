//
//  VerificationViewXib.swift
//  ProwlereTest
//
//  Created by Abhi116 on 08/02/18.
//  Copyright © 2018 Techvalens. All rights reserved.
//

import UIKit

class VerificationViewXib: UIView {
    
    @IBOutlet weak var viewForPopView: UIView!
    
    @IBOutlet weak var lblForVerificationMessage: UILabel!
    
    @IBOutlet weak var btnForResendVerificationLink: UIButton!
    
    @IBOutlet weak var btnForCancel: UIButton!
    
   
    
    
    
  
  

    // Call back implementation
    
    public typealias VerificationCallback = ( NSDictionary?,Bool?) -> Void
    private var callback: VerificationCallback?
    
    
    
    
    // MARK: - Dialog initialization
    override open func awakeFromNib() {
        super.awakeFromNib()
        viewForPopView.layer.cornerRadius = 5.0
        viewForPopView.clipsToBounds = true
        
    }
    
    func instanceFromNib() -> UIView {
        
        return UINib(nibName: "VerificationViewXib", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! VerificationViewXib
    }
    
    func Setup(){
        self.layoutIfNeeded()
        self.setNeedsDisplay()
        //        view_main.layer.cornerRadius = 0
        //        view_main.layer.masksToBounds = true
        //        view_main.layer.borderWidth = 0.1
        //        view_main.layer.borderColor = UIColor.clear.cgColor
    }
    
    open func addDiaLogToView(callback: @escaping VerificationCallback){
        
        
       let window = UIApplication.shared.keyWindow!
        let PickerDialog: VerificationViewXib = instanceFromNib() as! VerificationViewXib
        PickerDialog.frame = (window.frame)
        PickerDialog.callback = callback
        PickerDialog.Setup()
        window.addSubview(PickerDialog)
        window.bringSubview(toFront: PickerDialog)
        window.endEditing(true)
    }
    
    
    @IBAction func ActionOnResendBtn(_ sender: UIButton) {
        
        self.callback?(nil, true)
       // CloseDialog()
    }
    @IBAction func ActionOnCloseBtn(_ sender: UIButton) {
        
        self.callback?(nil, false)
        CloseDialog()
    }
    func CloseDialog(){
        self.removeFromSuperview()
    }
    
    
    
    
}
