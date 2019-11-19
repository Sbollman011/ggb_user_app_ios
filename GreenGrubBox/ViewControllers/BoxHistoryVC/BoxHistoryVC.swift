//
//  BoxHistoryVC.swift
//  MapTest
//
//  Created by Dev4 on 2/1/18.
//  Copyright © 2018 Atul. All rights reserved.
//

import UIKit
import Alamofire

class BoxHistoryVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var lbl_status: UILabel!
    @IBOutlet weak var tblViewForBoxHistory: UITableView!
    var Box_History_Array : [Data_Box] = []
    
    //Pull to refresh
    let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl_status.isHidden = true
        tblViewForBoxHistory.delegate = self
        tblViewForBoxHistory.dataSource = self
        tblViewForBoxHistory.register(UINib(nibName: "BoxHistoryCell", bundle: nil), forCellReuseIdentifier: "BoxHistoryCell")
        appDelegate.tabBarView.isHidden = true
        
        // Pull to refresh
        refreshControl.tintColor = appDelegate.uicolorFromHex(rgbValue: 0x7CD141)
        self.tblViewForBoxHistory.addSubview(self.refreshControl)
        self.refreshControl.addTarget(self, action: #selector(BoxHistoryVC.handleRefresh(refreshControl:)), for:  UIControlEvents.valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        currentPage = 1
        pageSize = 20
        self.Box_History_service(isCallInBG: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Box_History_Array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblViewForBoxHistory.dequeueReusableCell(withIdentifier: "BoxHistoryCell", for: indexPath) as! BoxHistoryCell
        let image: String =  Box_History_Array[indexPath.row].boxIcon!
        cell.imgViewForItemBox.showImage(urlofimage: image)
        cell.lblForItemNumber.text = Box_History_Array[indexPath.row].boxId
        cell.lblForDate.text = Box_History_Array[indexPath.row].userCheckOutTime
        cell.lblForVendorName.text = Box_History_Array[indexPath.row].vendorName
        let Rinventory : Bool = Box_History_Array[indexPath.row].returnInventory!
        if Rinventory {
            cell.lblForStillWithTou.text = "Returned to Inventory"
            cell.lbl_returnTime.isHidden = false
            cell.view_box.backgroundColor = appDelegate.uicolorFromHex(rgbValue: 0x89D641)
        }else {
            cell.lblForStillWithTou.text = "Still with you, please return when the grubbing is done"
            cell.lbl_returnTime.isHidden = true
            cell.view_box.backgroundColor = appDelegate.uicolorFromHex(rgbValue: 0xEB9800)
        }
        cell.lblForStillWithTou.sizeToFit()
        cell.lblForStillWithTou.setNeedsLayout()
        cell.lbl_returnTime.text = "\(Box_History_Array[indexPath.row].inventoryTime)"
        
        if (indexPath.row == Box_History_Array.count - 1){
            if (isMore == true){
                self.LoadMore()
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 135
    }
    
    //MARK: Box History
    var currentPage: Int = 1
    var pageSize: Int = 20
    var isMore: Bool = false
    func LoadMore(){
        if isMore == true
        {
            currentPage = currentPage + 1
            pageSize = 20
            Box_History_service(isCallInBG: false)
        }
    }
    
    func PullToRefresh(){
        lbl_status.isHidden = true 
        isMore = false
        currentPage =  1
        pageSize = 20
        Box_History_service(isCallInBG: true)
    }
    
    // MARK:pull to refresh
    @objc func handleRefresh(refreshControl: UIRefreshControl) {
        PullToRefresh()
        refreshControl.endRefreshing()
    }
    
    func Box_History_service(isCallInBG:Bool){
        let  headers: HTTPHeaders = ["Content-Type": "application/json","authorization": LoginToken]
        print(headers)
        MasterWebService.sharedInstance.GET_WithHeaderCustom_webservice(Url:  EndPoints.Box_History_URL + "?userId=\(LoginUserId)&currentPage=\(currentPage)&pageSize=\(pageSize)", prm: nil ,header: headers,background:isCallInBG,completion: {_result,_statusCode in
            if _statusCode == 200 {
                if _result is NSDictionary {
                    print("dict")
                    print(_result)
                    let Responsedata: NSDictionary = _result as! NSDictionary
                    let status : Int =  Responsedata.value(forKey: "status") as! Int
                    if status == 0 {
                        self.StatusCheck()
                        let message : String = Responsedata.value(forKey: "message") as! String
                        self.showErrorToast(message: "\(message)", backgroundColor: UIColor.red)
                    }else if status == 1 {
                        print(Responsedata)
                        let boxHIstory : BoxHIstoryModel = BoxHIstoryModel.init(dictionary: Responsedata)!
                        if self.isMore == true {
                            self.isMore = boxHIstory.isMore
                            self.Box_History_Array =  self.Box_History_Array + boxHIstory.data!
                            self.tblViewForBoxHistory.reloadData()
                        }else {
                            self.isMore = boxHIstory.isMore
                            self.Box_History_Array =  boxHIstory.data!
                            self.tblViewForBoxHistory.reloadData()
                        }
                        self.StatusCheck()
                    }
                } else {
                    self.showErrorToast(message: "Somthing went wrong JSON serialization failed.", backgroundColor: UIColor.red)
                }
                if _result is NSArray {
                    print("array")
                }
            }else{
                self.showErrorToast(message: "Somthing went wrong.", backgroundColor: UIColor.red)
            }
        })
    }
    
    func StatusCheck(){
        if  self.Box_History_Array.count == 0 {
            lbl_status.isHidden = false
        }else {
            lbl_status.isHidden = true
        }
    }
    
    // MARK:IB-Action
    @IBAction func actionOnBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

