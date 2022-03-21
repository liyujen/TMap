////
////  ViewController.swift
////  HelloMyMap1215
////
////  Created by student on 2021/12/15.
////
//
//import UIKit
//import CoreLocation
//import MapKit
//
//棄用
//class ViewController: UIViewController, CLLocationManagerDelegate {
//    
//    @IBOutlet weak var mainMapView: MKMapView!
//    
//    let locationManager = CLLocationManager()
//   
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        //Instance method
//    //    locationManager.requestAlwaysAuthorization()
//        
//        //Strart updating location.
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.activityType = .fitness
//        locationManager.delegate = self
//        locationManager.startUpdatingLocation()
//        
////        locationManager.allowsBackgroundLocationUpdates = true
////        locationManager.pausesLocationUpdatesAutomatically = false
//        
//      //  mainMapView.delegate = self
////
//        
//    }
//
//    @IBAction func cancelBtn(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
//    }
//    
//    @IBAction func mapTypeChanged(_ sender: UISegmentedControl) {
//        let targetIndex = sender.selectedSegmentIndex
//            switch targetIndex{
//            case 0:
//                mainMapView.mapType = .standard
//            case 1:
//                mainMapView.mapType = .satellite
//            case 2:
//                mainMapView.mapType = .hybrid
//            case 3:
//                mainMapView.mapType = .hybridFlyover
//               // Tokyo Sky Tree: 35.710063, 139.8107
////                let coordinate = CLLocationCoordinate2D(latitude: 25.033671, longitude: 121.564427)
////                let camera = MKMapCamera(lookingAtCenter: coordinate, fromDistance: 800, pitch: 60, heading: 0)
////                mainMapView.camera = camera
//            default:
//                mainMapView.mapType = .standard
//          }
//        }
//        
//       
//
//    
//        
//        /*
//        //在地圖上標註位置
//               let geoCoder = CLGeocoder()
//        geoCoder.geocodeAddressString(CLLocation.String, completionHandler: {
//                   placemarks, error in
//                   if error != nil {
//                       print(error)
//                       return
//                   }
//                   if let placemarks = placemarks {
//                       // 取得第一個座標
//                       let placemark = placemarks[0]
//                       // 加上地圖標註
//                       let annotation = MKPointAnnotation()
//                       if let location = placemark.location {
//                           // 顯示標註(大頭針)
//                           annotation.coordinate = location.coordinate
//                           self.mapView.addAnnotation(annotation)
//                           // 設定縮放程度
//                           let region =
//                               MKCoordinateRegionMakeWithDistance(annotation.coordinate, 250, 250)
//                           self.mapView.setRegion(region, animated: false)
//                       }
//                   }
//                 })
//    */
////    }
//    
//}
//
// 
//
