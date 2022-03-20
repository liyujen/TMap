//
//  MyMapViewController.swift
//  TMap
//
//  Created by student on 2022/3/16.
//

import UIKit
import MapKit
import CoreLocation

class MyMapViewController: UIViewController {
    
    @IBOutlet weak var addTap: UIButton!
    @IBOutlet weak var myMapView: MKMapView!
    
    @IBOutlet weak var changeModeBtn: UIButton!
    
 
    @IBOutlet weak var hintLabel: UILabel!
    let locationManager = CLLocationManager()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        print("init nibName style")
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        print("init coder style")
        super.init(coder: aDecoder)
    }
    
    fileprivate func configLocationManager() {
        //Instance method
        locationManager.requestAlwaysAuthorization()
        
        //Strart updating location.
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .fitness
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configLocationManager()
        centerMapOnUserLocation()
        configComponent()
    }
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //         Get the new view controller using segue.destination.
    //         Pass the selected object to the new view controller.
    //    }
    //
    @IBAction func respondToMap(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: myMapView)                               //獲取Tap時所在的位置
        print(tapLocation)
        
        let tapMapCoordinate = myMapView.convert(tapLocation, toCoordinateFrom: myMapView)         //將屏幕上的x,y轉換為地圖上的經緯度
        print(tapMapCoordinate)
        
   
        let alertController = UIAlertController(title: "確定選取正確座標", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "新增", style: .default, handler: { action in
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "TapVC")
                self.present(viewController!, animated: true, completion: nil)
            print("使用者按下ok")
            let annotation=MKPointAnnotation()
                           annotation.title=""
                           annotation.coordinate=tapMapCoordinate
                           annotation.subtitle = ""
            self.myMapView.addAnnotation(annotation)
        })

        
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel) { (action)-> Void in
            print("使用者按下取消")
            
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        
        self.present(alertController, animated: true, completion: nil)
    }
    func mymapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
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

        
    
   
    func configComponent(){
        addTap.addTarget(self, action: #selector(addTapAct), for: .touchUpInside)
        hintLabel.isHidden = true
        
    }
    @objc func addTapAct(){
        changeModeBtn.isHidden = true
        addTap.isHidden = true
        hintLabel.isHidden = false
       
    }
   
    
    
    func centerMapOnUserLocation() {
        
        guard let coordinates = locationManager.location?.coordinate else { return }
        
        let zoomWidth = myMapView.visibleMapRect.size.width
        var meter : Double = 500
        if zoomWidth < 3694{
            meter = zoomWidth * 500/3694
        }
        let coordinateRegion = MKCoordinateRegion(center: coordinates, latitudinalMeters: meter, longitudinalMeters: meter)
        myMapView.setRegion(coordinateRegion, animated: true)
        
    }
}
extension ViewController: MKMapViewDelegate{}



extension MyMapViewController: CLLocationManagerDelegate{
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        print("使用者點擊確認，權限改變了，接下來我要做什麼？")
        //myMapView 原本沒有抓到使用者位置，但現在抓到了，所以我要對使用者位置做zoom in
        centerMapOnUserLocation()
    }
    
}
