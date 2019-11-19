//
//  BoxHistoryCell.swift
//  MapTest
//
//  Created by Dev4 on 2/1/18.
//  Copyright © 2018 Atul. All rights reserved.
//

import UIKit

class BoxHistoryCell: UITableViewCell {
    
    @IBOutlet weak var imgViewForBox: UIImageView!
    @IBOutlet weak var imgViewForItemBox: UIImageView!
    @IBOutlet weak var lblForItemNumber: UILabel!
    @IBOutlet weak var lblForDate: UILabel!
    @IBOutlet weak var lblForVendorName: UILabel!
    @IBOutlet weak var lblForStillWithTou: UILabel!
    @IBOutlet weak var lbl_returnTime: UILabel!
    @IBOutlet weak var lblForTime: UILabel!
    @IBOutlet weak var view_box: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        view_box.layer.cornerRadius = 4
        view_box.layer.borderColor = UIColor.clear.cgColor
        view_box.layer.borderWidth = 1
        view_box.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
