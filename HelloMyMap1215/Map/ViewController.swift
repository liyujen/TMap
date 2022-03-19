//
//  ViewController.swift
//  HelloMyMap1215
//
//  Created by student on 2021/12/15.
//

import UIKit
import CoreLocation
import MapKit


class ViewController: UIViewController {
    
    @IBOutlet weak var mainMapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Class method 類別方法
        //檢查使用者有沒有開定位
        if CLLocationManager.locationServicesEnabled() == false{
            
        }
        // Do any additional setup after loading the view.
        
        //Request permission
        //Instance method
        locationManager.requestAlwaysAuthorization()
        
        //Strart updating location.
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .fitness
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
//        locationManager.allowsBackgroundLocationUpdates = true
//        locationManager.pausesLocationUpdatesAutomatically = false
        
      //  mainMapView.delegate = self
//
        
    }

    
    @IBAction func mapTypeChanged(_ sender: UISegmentedControl) {
        let targetIndex = sender.selectedSegmentIndex
            switch targetIndex{
            case 0:
                mainMapView.mapType = .standard
            case 1:
                mainMapView.mapType = .satellite
            case 2:
                mainMapView.mapType = .hybrid
            case 3:
                mainMapView.mapType = .hybridFlyover
               // Tokyo Sky Tree: 35.710063, 139.8107
                let coordinate = CLLocationCoordinate2D(latitude: 25.033671, longitude: 121.564427)
                let camera = MKMapCamera(lookingAtCenter: coordinate, fromDistance: 800, pitch: 60, heading: 0)
                mainMapView.camera = camera
            default:
                mainMapView.mapType = .standard
          }
        }
   

    @IBAction func respondToMap(_ sender: UITapGestureRecognizer) {
        
        let tapLocation = sender.location(in: mainMapView)                               //獲取Tap時所在的位置
        print(tapLocation)
        
        let tapMapCoordinate = mainMapView.convert(tapLocation, toCoordinateFrom: mainMapView)         //將屏幕上的x,y轉換為地圖上的經緯度
        print(tapMapCoordinate)
        

      
        let annotation=MKPointAnnotation()
               annotation.title=""
               annotation.coordinate=tapMapCoordinate
               annotation.subtitle = ""
               mainMapView.addAnnotation(annotation)
   
        let alertController = UIAlertController(title: "確定選取正確座標", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "新增", style: .default, handler: { action in
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "TapVC")
                self.present(viewController!, animated: true, completion: nil)
            print("使用者按下ok")
        })

        
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel) { (action)-> Void in
            print("使用者按下取消")
            
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        
        self.present(alertController, animated: true, completion: nil)
    }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
         //   /*
             let identifier = "default"
             var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
              if annotationView==nil{
                  //如果無指定圖片的話，將圖標的設定為圖，記得圖片需要事先放進Assets Folder
                 annotationView=MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                 annotationView?.image=UIImage(named: "pointRed.png")
          }else{
              annotationView?.annotation=annotation
                   }
            return annotationView
            
        }


    
        
        /*
        //在地圖上標註位置
               let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(CLLocation.String, completionHandler: {
                   placemarks, error in
                   if error != nil {
                       print(error)
                       return
                   }
                   if let placemarks = placemarks {
                       // 取得第一個座標
                       let placemark = placemarks[0]
                       // 加上地圖標註
                       let annotation = MKPointAnnotation()
                       if let location = placemark.location {
                           // 顯示標註(大頭針)
                           annotation.coordinate = location.coordinate
                           self.mapView.addAnnotation(annotation)
                           // 設定縮放程度
                           let region =
                               MKCoordinateRegionMakeWithDistance(annotation.coordinate, 250, 250)
                           self.mapView.setRegion(region, animated: false)
                       }
                   }
                 })
    */
//    }
    
}

 

