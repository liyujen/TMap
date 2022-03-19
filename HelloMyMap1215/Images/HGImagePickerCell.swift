//
//  HGImagePickerCell.swift
//  hangge_1512
//
//  Created by hangge on 2017/1/7.
//  Copyright © 2017年 hangge.com. All rights reserved.
//

import UIKit


class HGImagePickerCell: UITableViewCell {
    //相簿名稱
    @IBOutlet weak var titleLabel:UILabel!
    //照片數量
    @IBOutlet weak var countLabel:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutMargins = UIEdgeInsets.zero
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
