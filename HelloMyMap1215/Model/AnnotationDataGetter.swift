//
//  AnnptationDataGetter.swift
//  TMap
//
//  Created by student on 2022/3/20.
//

import Foundation
import MapKit
import Firebase


class AnnotationDataGetter{
    
    var mapView : MKMapView
    
    init(mapView:MKMapView){
        self.mapView = mapView
    }
    
    
    func fetchAnnotationData(){
        print("fetchAnnotationData")
        let ref = Database.database().reference().child("Annotation/" + Auth.auth().currentUser!.uid)
        ref.observe(.childAdded, with:{ (snapshot)  in
            
            let data = AnnotationData(snapShot: snapshot)
            print(data.title)
            let annotation = CustomMKAnnotation()
            annotation.title = data.title
            annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly:Double(data.latitude)!)!, longitude: CLLocationDegrees(exactly:Double(data.longitude)!)!)
            annotation.subtitle = data.subTitle
            annotation.annotationData = data
            self.mapView.addAnnotation(annotation)
        })
        
    }
    
    func fetchOtherUserAnnotationData(){
        print("fetchAnnotationData")
        let ref = Database.database().reference().child("Annotation/"
                                                        + Auth.auth().currentUser!.uid)
        ref.observe(.childAdded, with:{ (snapshot)  in
            
            let data = AnnotationData(snapShot: snapshot)
            print(data.title)
            let annotation = CustomMKAnnotation()
            annotation.title = data.title
            annotation.coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(exactly:Double(data.latitude)!)!, longitude: CLLocationDegrees(exactly:Double(data.longitude)!)!)
            annotation.subtitle = data.subTitle
            annotation.annotationData = data
            self.mapView.addAnnotation(annotation)
        })
        
    }
    
}
