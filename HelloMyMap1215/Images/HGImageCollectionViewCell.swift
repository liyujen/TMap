//
//  HGImageCollectionViewCell.swift
//  hangge_1512
//
//  Created by hangge on 2017/1/7.
//  Copyright © 2017年 hangge.com. All rights reserved.
//

import UIKit

//圖片縮圖集單元格
open class HGImageCollectionViewCell: UICollectionViewCell {
    //顯示縮圖
    @IBOutlet weak var imageView:UIImageView!
    
    //顯示選取
    @IBOutlet weak var selectedIcon:UIImageView!
    
    //設置是否選取
    open override var isSelected: Bool {
        didSet{
            if isSelected {
                selectedIcon.image = UIImage(named: "hg_image_selected")
            }else{
                selectedIcon.image = UIImage(named: "hg_image_not_selected")
            }
        }
    }
    
    //圖標動畫
    func playAnimate() {
        //圖標先縮小，再放大
        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: .allowUserInteraction,
                                animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2,
                               animations: {
                self.selectedIcon.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            })
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.4,
                               animations: {
                self.selectedIcon.transform = CGAffineTransform.identity
            })
            }, completion: nil)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
}
