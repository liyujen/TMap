////
////  Tap.swift
////  TMap
////
////  Created by student on 2022/3/14.
////
//
//import Foundation
//import UIKit
//import CoreData
//
////LocationData
//class LocationData : NSManagedObject {
//
//    override func awakeFromInsert() {
//        self.tapID = UUID().uuidString
//    }
//
//    override func prepareForDeletion() {
//        if let fileName = self.imageName{
//            let homeURL = URL(fileURLWithPath: NSHomeDirectory())
//            let docURL = homeURL.appendingPathComponent("Documents")
//            let photoURL = docURL.appendingPathComponent(fileName)
//            do {
//                try  FileManager.default.removeItem(at: photoURL)
//            }catch{
//            print("error \(error)")
//        }
//        }
//    }
//    //假設cell裡面的資料內容
//    @NSManaged  var pointtext : String?
//    @NSManaged  var viewpointtext : String?
//    @NSManaged  var text : String?
//    //var image : UIImage?
//    @NSManaged  var tapID : String // = UUID().uuidString
//    @NSManaged  var imageName : String?
//    @NSManaged  var seq : Int16
//    @NSManaged var latitude : String?
//    @NSManaged var longitude : String?
//
//    func image() -> UIImage? {
//        if let fileName = self.image() {
////            let homeURL = URL(fileURLWithPath: NSHomeDirectory())
////            let docURL = homeURL.appendingPathComponent("Documents")
////            let photoURL = docURL.appendingPathComponent(String.Type)
////            return UIImage(contentsOfFile: photoURL.path)
//        }
//        return nil
//    }
//    // 縮圖
//    func thumbnailImage() -> UIImage? {
//            if let image =  self.image() {
//                let thumbnailSize = CGSize(width:50, height: 50); //設定縮圖大小
//                let scale = UIScreen.main.scale //找出目前螢幕的scale，視網膜技術為2.0
//
//                //產生畫布，第一個參數指定大小,第二個參數true:不透明（黑色底）,false表示透明背景,scale為螢幕scale
//                UIGraphicsBeginImageContextWithOptions(thumbnailSize,false,scale)
//
//                //計算長寬要縮圖比例，取最大值MAX會變成UIViewContentModeScaleAspectFill
//                //最小值MIN會變成UIViewContentModeScaleAspectFit
//                let widthRatio = thumbnailSize.width / image.size.width;
//                let heightRadio = thumbnailSize.height / image.size.height;
//
//                let ratio = max(widthRatio,heightRadio);
//
//                let imageSize = CGSize(width:image.size.width*ratio,height: image.size.height*ratio);
//                //以下兩橫可以縮圖裁圓型
////                let circle = UIBezierPath(ovalIn: CGRect(x:0,y:0,width:thumbnailSize.width,height: thumbnailSize.height))
////                circle.addClip()
//
//                image.draw(in:CGRect(x: -(imageSize.width-thumbnailSize.width)/2.0,y: -(imageSize.height-thumbnailSize.height)/2.0,
//                    width: imageSize.width,height: imageSize.height))
//                //取得畫布上的縮圖
//                let smallImage = UIGraphicsGetImageFromCurrentImageContext();
//                //關掉畫布
//                UIGraphicsEndImageContext();
//                return smallImage
//            }else{
//                return nil;
//            }
//        }
//}
