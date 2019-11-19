//
//  VendorCell.swift
//  GreenGrubBox
//
//  Created by Ankit on 2/2/18.
//  Copyright © 2018 Ankit. All rights reserved.
//

import UIKit

class VendorCell: UITableViewCell {

    @IBOutlet weak var lbl_type: UILabel!
    @IBOutlet weak var lbl_distance: UILabel!
    @IBOutlet weak var lbl_name: UILabel!
    @IBOutlet weak var img_vendor: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        img_vendor.image = UIImage(named: "popUp_default_user.png")
    }
}
