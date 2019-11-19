//
//  SliderMediaVC.swift
//  Caviar
//
//  Created by MacOs on 2/23/17.
//  Copyright © 2017 MacOs. All rights reserved.
//

import Foundation
import UIKit

class SliderMediaVC: UIViewController,UIGestureRecognizerDelegate,UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    var PictureMedia : [String] = []
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var btnClose: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        let collCell = UINib(nibName: "ImageCollectionCell", bundle: nil)
        self.collection.register(collCell, forCellWithReuseIdentifier: "ImageCollectionCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true )
    }
    
    var layoutenable: Bool = false
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if  layoutenable == false {
            layoutenable = true
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            //let size = collection.frame.height / 2 - 5
            layout.itemSize = CGSize(width: self.view.frame.width, height:self.view.frame.height)
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
            collection!.collectionViewLayout = layout
            collection.isPagingEnabled = true
            self.collection.delegate = self
            self.collection.dataSource = self
            collection.reloadData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        layoutenable = false
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    
    @IBAction func ActionOnbtnClose(_ sender: UIButton) {
        Goback()
    }
    
    //MARK: COllection view
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return PictureMedia.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell: ImageCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath as IndexPath) as! ImageCollectionCell
        let url = URL.init(string:PictureMedia[indexPath.row] as String)
        cell.img_picture.sd_setImage(with: url , placeholderImage: UIImage(named: "popUp_default_user.png"))
        cell.scrollview.contentSize = CGSize(width: self.view.frame.width , height: self.view.frame.height)
        cell.scrollview.delegate = self
        cell.scrollview.isScrollEnabled = true
        cell.scrollview.isDirectionalLockEnabled = true
        cell.scrollview.backgroundColor = UIColor.clear
        cell.SetDeleageOfscrolview()
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    @objc func Goback(){
        self.dismiss(animated: true, completion: nil)
    }
}
