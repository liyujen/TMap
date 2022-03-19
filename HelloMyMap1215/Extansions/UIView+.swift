//
//  UIView+.swift
//  TMap
//
//  Created by student on 2022/3/19.
//

import Foundation
import UIKit

extension UIView {
    
    
    func setLoadingView(_ status: Bool){
        
        if status {
            //加入毛玻璃效果 xib
            if let array = Bundle.main.loadNibNamed("LoadingView", owner: nil, options: nil) {
                let loadingView = array.first as? UIView
                loadingView?.frame.origin = CGPoint(x: 0, y: 0)
                loadingView?.frame.size = UIScreen.main.bounds.size
                loadingView?.tag = 408
                if loadingView != nil {
                    self.addSubview(loadingView!)
                }
            }
        } else {
            //移除
            for view in self.subviews{
                if(view.tag == 408){
                    view.removeFromSuperview()
                }
            }
        }
        
    }
    
}
