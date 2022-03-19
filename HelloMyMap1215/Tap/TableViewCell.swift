//
//  TableViewCell.swift
//  TMap
//
//  Created by student on 2022/3/15.
//

import UIKit
//客製化cell
class TableViewCell: UITableViewCell {
    //在cell顯示主標
    @IBOutlet weak var titleText: UILabel!
    //在cell顯示副標
    @IBOutlet weak var subTitleText: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
