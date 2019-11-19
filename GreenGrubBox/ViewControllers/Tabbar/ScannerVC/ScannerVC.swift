//
//  ScannerVC.swift
//  GreenGrubBox
//
//  Created by Ankit on 1/31/18.
//  Copyright © 2018 Ankit. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import AudioToolbox
import MediaPlayer
import Alamofire
class ScannerVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate, AVPlayerViewControllerDelegate {
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var isReading: Bool = false
    
    @IBOutlet weak var viewPreview: UIView!
    @IBOutlet weak var View_Animation: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captureSession = nil;
        View_Animation.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        appDelegate.tabBarView.isHidden = false
    }
    
    func StartScanningProcedure(){
        playerLayer.player = nil
        View_Animation.isHidden = true
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
            // Already Authorized
            layerAppear()
        } else {
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> Void in
                if granted == true {
                    // User granted
                    self.layerAppear()
                } else {
                    // User rejected
                    self.camDenied()
                    //self.navigationController?.popViewController(animated: true)
                }
            })
        }
    }
    
    func camDenied()
    {
        DispatchQueue.main.async
            {
                var alertText = "It looks like your privacy settings are preventing us from accessing your camera to do barcode scanning. You can fix this by doing the following:\n\n1. Close this app.\n\n2. Open the Settings app.\n\n3. Scroll to the bottom and select this app in the list.\n\n4. Turn the Camera on.\n\n5. Open this app and try again."
                
                var alertButton = "OK"
                var goAction = UIAlertAction(title: alertButton, style: .default, handler: nil)
                
                if UIApplication.shared.canOpenURL(URL(string: UIApplicationOpenSettingsURLString)!)
                {
                    alertText = "It looks like your privacy settings are preventing us from accessing your camera to do barcode scanning. You can fix this by doing the following:\n\n1. Touch the Go button below to open the Settings app.\n\n2. Turn the Camera on.\n\n3. Open this app and try again."
                    
                    alertButton = "Go"
                    
                    goAction = UIAlertAction(title: alertButton, style: .default, handler: {(alert: UIAlertAction!) -> Void in
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
                        } else {
                            // Fallback on earlier versions
                        }
                    })
                }
                
                let alert = UIAlertController(title: "Error", message: alertText, preferredStyle: .alert)
                alert.addAction(goAction)
                self.present(alert, animated: true, completion: nil)
        }
    }
    
    func askForPermission(){
        let alert = UIAlertController(title: "Camera access Disabled", message: "Please enable Camera Services in Settings", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func alertPromptToAllowCameraAccessViaSetting() {
        let alert = UIAlertController(
            title: "IMPORTANT",
            message: "Camera access required for Scan!",
            preferredStyle: UIAlertControllerStyle.alert
        )
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel) { alert in
            if AVCaptureDevice.devices(for: AVMediaType.video).count > 0 {
                AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
                    DispatchQueue.main.async() {
                        self.layerAppear()
                        
                    } }
            }
            }
        )
        present(alert, animated: true, completion: nil)
    }
    
    func layerAppear(){
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer.frame = viewPreview.bounds
            viewPreview.layer.addSublayer(videoPreviewLayer)
            
            /* Check for metadata */
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            captureMetadataOutput.metadataObjectTypes = captureMetadataOutput.availableMetadataObjectTypes
            captureMetadataOutput.setMetadataObjectsDelegate(self as AVCaptureMetadataOutputObjectsDelegate, queue: DispatchQueue.main)
            captureSession?.startRunning()
        } catch let error as NSError {
            print(error)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        StartScanningProcedure()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
        playerLayer.player = nil
        View_Animation.isHidden = true
        stopReading()
    }
    
    func RemoveAnimation(){
        playerLayer.player = nil
        View_Animation.isHidden = true
    }
    
    @objc func stopReading() {
        captureSession?.stopRunning()
        captureSession = nil
        if videoPreviewLayer != nil {
            videoPreviewLayer.removeFromSuperlayer()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection){
        for data in metadataObjects {
            let metaData = data
            // print(metaData.description)
            let transformed = videoPreviewLayer?.transformedMetadataObject(for: metaData) as? AVMetadataMachineReadableCodeObject
            if let unwraped = transformed {
                print("Data in QR Code >>>>>>>>>", unwraped.stringValue!)
                self.performSelector(onMainThread: #selector(stopReading), with: nil, waitUntilDone: false)
                AudioServicesPlaySystemSound(1106);
                self.CaviarloadingAnimation(Box: unwraped.stringValue!)
                isReading = false;
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: Animation setup
    var playerLayer =  AVPlayerViewController()
    func CaviarloadingAnimation(Box:String){
        
        let videoURL: URL = Bundle.main.url(forResource: "giphy", withExtension: "mp4")!
        self.playerLayer.view.isHidden = false
        View_Animation.isHidden = false
        if playerLayer.player == nil {
            BoxID = Box
            playerLayer.player = AVPlayer(url: videoURL as URL)
            playerLayer.showsPlaybackControls = false
            playerLayer.view.frame = CGRect(x: 0, y: 0, width: View_Animation.frame.width, height: View_Animation.frame.height)
            NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying(notification:)),
                                                   name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:playerLayer.player?.currentItem)
            playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill.rawValue
            playerLayer.player?.actionAtItemEnd = .none
            playerLayer.view.isUserInteractionEnabled = false
            self.playerLayer.player?.currentItem?.seek(to: kCMTimeZero)
            self.playerLayer.player?.play()
            if View_Animation.isHidden == true {
                playerLayer.view.alpha = 0
            }
            playerLayer.view.backgroundColor = UIColor.clear
            View_Animation.addSubview(playerLayer.view)
            self.view.bringSubview(toFront: View_Animation)
        }
    }
    var BoxID : String = ""
    @objc func playerDidFinishPlaying(notification:NSNotification){
        self.CheckOutWebservice(BoxId: BoxID)
        BoxID = ""
    }
    
    //MARK: CHeck out webservice
    func CheckOutWebservice(BoxId: String){
        var localTimeZoneName: String { return TimeZone.current.identifier }
        print(localTimeZoneName)
        let prm:Parameters  = ["boxId": BoxId,"userId": LoginUserId,"lat": "\(User_Latitute)","long": "\(User_Langitute)","timezone":localTimeZoneName]
        let  headers: HTTPHeaders = ["Content-Type": "application/json","authorization": LoginToken]
        MasterWebService.sharedInstance.POST_WithCustomHeader_webservice(Url: EndPoints.Box_checkOut_URL, prm: prm, Header: headers, background: true, completion: { _result,_statusCode in
            if _statusCode == 200 {
                print("JSON serialization failed")
                if _result is NSDictionary {
                    print("dict")
                    print(_result)
                    let Responsedata: NSDictionary = _result as! NSDictionary
                    let status : Int =  Responsedata.value(forKey: "status") as! Int
                    if status == 0 {
                        let message : String = Responsedata.value(forKey: "message") as! String
                        self.ShowActivity(Message: message,status:status)
                    }else  if status == 1 {
                        let message : String = Responsedata.value(forKey: "message") as! String
                        var isRenewRequire : Int = 0
                        
                        if Responsedata.value(forKey: "isRenewRequire") != nil {
                            isRenewRequire = Responsedata.value(forKey: "isRenewRequire") as! Int
                        }
                        
                        if isRenewRequire == 1 {
                            let alertController = UIAlertController(title: "Message", message: "\(message)", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
                                UIAlertAction in
                                self.RemoveAnimation()
                                self.StartScanningProcedure()
                            }
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
                        }else {
                            self.ShowActivity(Message: message,status:status)
                        }
                    }
                }else
                {
                    self.showAlert(withTitle: "Message", message:  "Somthing went wrong JSON serialization failed.")
                }
                if _result is NSArray {
                    print("array")
                }
            } else {
                self.showAlert(withTitle: "Message", message: "Somthing went wrong.")
            }
        })
    }
    
    func GotoLoginUser(){
        //MARK: remove all nsuserdeffaluts
        LoginUserId = ""
        LoginToken = ""
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.synchronize()
        
        let nav_splaxh_vc  = storyboard?.instantiateViewController(withIdentifier: "Navigtioncontroller") as! UINavigationController
        appDelegate.window?.rootViewController = nav_splaxh_vc
    }

    func ShowActivity(Message: String,status:Int){
        
        let alertController = UIAlertController(title: "Message", message:Message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {
            alert -> Void in
            if status == 0 {
                self.RemoveAnimation()
                self.StartScanningProcedure()
            }else if status == 1 {
                //                let btn: UIButton = UIButton()
                //                btn.tag = 0
                //                appDelegate.tabBarClick(btn)
                self.NavigateTOBoxHistory()
            }
        }))
        let action = alertController.actions[0]
        action.setValue(UIColor.black, forKey: "titleTextColor")
        self.present(alertController, animated: true, completion: nil)
    }
    
    func NavigateTOBoxHistory(){
        let boxHistory_vc  = storyboard?.instantiateViewController(withIdentifier: "BoxHistoryVC") as! BoxHistoryVC
        self.navigationController?.pushViewController(boxHistory_vc, animated: true)
    }
}
