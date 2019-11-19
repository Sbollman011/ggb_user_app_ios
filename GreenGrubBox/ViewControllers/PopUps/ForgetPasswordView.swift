
//
//  ForgetPasswordView.swift
//  GreenGrubBox
//
//  Created by dev2 on 2/9/18.
//  Copyright © 2018 Ankit. All rights reserved.
//

import UIKit

class ForgetPasswordView: UIView {
    
    @IBOutlet weak var view_main: UIView!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lbSubtitle: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnCross: UIButton!
    @IBOutlet weak var txt_email: UITextField!
    
    // MARK: - Dialog initialization
    override open func awakeFromNib() {
        super.awakeFromNib()
        view_main.layer.cornerRadius = 5
        view_main.layer.masksToBounds = true
        view_main.layer.borderWidth = 1
        view_main.layer.borderColor = UIColor.white.cgColor
    }
    
    func instanceFromNib() -> UIView {
        return UINib(nibName: "ForgetPasswordView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! ForgetPasswordView
    }
    
    @IBAction func ActionOnbtnCross(_ sender: UIButton) {
        self.callback?("",false)
        self.removeFromSuperview()
    }
    
    @IBAction func ActionOnbtnSubmit(_ sender: UIButton) {
        self.endEditing(true)
        if txt_email.text?.condenseWhitespace() != "" {
            if appDelegate.isValidEmail(testStr: (txt_email.text!.condenseWhitespace()))
            {
                self.callback?(txt_email.text,true)
                self.removeFromSuperview()
            } else {
                self.removeFromSuperview()
                self.callback?("Please enter valid email address.",false)
            }
        }else {
            self.removeFromSuperview()
            self.callback?("Please enter a email address.",false)
        }
    }
    
    public typealias ForgetPasswordCallback = (String?,Bool?) -> Void
    private var callback: ForgetPasswordCallback?
    
    func AddForgetPopUp(callback: @escaping ForgetPasswordCallback){
        
        let window = UIApplication.shared.keyWindow!
        let PickerDialog: ForgetPasswordView = ForgetPasswordView().instanceFromNib() as! ForgetPasswordView
        PickerDialog.frame = (window.frame)
        PickerDialog.callback = callback
        
        PickerDialog.lblTitle.font = FontBold20
        PickerDialog.lbSubtitle.font = FontNormal11
        PickerDialog.lblEmail.font = Font2Bold11
        PickerDialog.btnSubmit.titleLabel?.font = FontBold15
        PickerDialog.btnCross.titleLabel?.font = FontBold15
        
        window.addSubview(PickerDialog)
        window.bringSubview(toFront: PickerDialog)
        window.endEditing(true)
        PickerDialog.fadeIn()
    }
}
