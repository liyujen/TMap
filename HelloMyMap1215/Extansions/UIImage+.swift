//
//  UIImage+.swift
//  TMap
//
//  Created by student on 2022/3/20.
//

import Foundation
import UIKit

//壓縮方式
extension UIImage{
    
    public func imageWithNewSize(size: CGSize) -> UIImage? {
        
        if self.size.height > size.height {
            
            let width = size.height / self.size.height * self.size.width
            
            let newImgSize = CGSize(width: width, height: size.height)
            
            UIGraphicsBeginImageContext(newImgSize)
            
            self.draw(in: CGRect(x: 0, y: 0, width: newImgSize.width, height: newImgSize.height))
            
            let theImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            guard let newImg = theImage else { return  nil}
            
            return newImg
            
        } else {
            
            let newImgSize = CGSize(width: size.width, height: size.height)
            
            UIGraphicsBeginImageContext(newImgSize)
            
            self.draw(in: CGRect(x: 0, y: 0, width: newImgSize.width, height: newImgSize.height))
            
            let theImage = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            guard let newImg = theImage else { return  nil}
            
            return newImg
        }
        
    }
    
    func compressQuality(maxLength:NSInteger) -> UIImage {
        var compression:CGFloat = 1
        var data = self.jpegData(compressionQuality: compression)!
        if data.count < maxLength {
            return UIImage(data: data)!
        }
        var max:CGFloat = 1
        var min:CGFloat = 0
        for _ in 0..<6 {
            compression = (max + min)/2
            data = self.jpegData(compressionQuality: compression)!
            if Double(data.count) < Double(maxLength)*0.9 {
                min = compression
            } else if data.count > maxLength {
                max = compression
            } else {
                break
            }
        }
        
        return UIImage(data: data)!
    }
    
}
