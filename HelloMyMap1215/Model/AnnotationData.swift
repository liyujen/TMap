//
//  AnnotationData.swift
//  TMap
//
//  Created by student on 2022/3/20.
//

import Foundation
import UIKit
import Firebase

class AnnotationData{
    
    var title : String
    var subTitle : String
    var latitude : String
    var longitude : String
    var photosUrl : [String]?
    
    init(title: String, subTitle: String, latitude : String, longitude : String,photosUrl: [String]?){
        self.title = title
        self.subTitle = subTitle
        self.latitude = latitude
        self.longitude = longitude
        self.photosUrl = photosUrl
    }
    
    init(snapShot:DataSnapshot){
        
        let snapShotValue = snapShot.value as! [String: AnyObject]
        
        if let title = snapShotValue["title"] as? String,
           let subTitle = snapShotValue["subTitle"] as? String,
           let latitude = snapShotValue["latitude"] as? String,
           let longitude = snapShotValue["longitude"] as? String
        {
            self.title = title
            self.subTitle = subTitle
            self.latitude = latitude
            self.longitude = longitude
        }else{
            self.title = ""
            self.subTitle = ""
            self.latitude = ""
            self.longitude = ""
        }
        photosUrl = snapShotValue["photosUrl"] as? [String]
    }
    
    func toAnyObject() -> Any {
        return [
            "title": title,
            "subTitle": subTitle,
            "latitude": latitude,
            "longitude": longitude,
            "photosUrl":photosUrl,
        ]
    }
    
}
