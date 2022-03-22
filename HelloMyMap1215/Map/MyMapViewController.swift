//
//  MyMapViewController.swift
//  TMap
//
//  Created by student on 2022/3/16.
//

import UIKit
import MapKit
import CoreLocation
import Firebase
import simd
import Alamofire

class MyMapViewController: UIViewController{
    
    @IBOutlet weak var addTap: UIButton!
    @IBOutlet weak var myMapView: MKMapView!
    
    @IBOutlet weak var changeModeBtn: UIButton!
    
    
    @IBOutlet weak var hintLabel: UILabel!
    let locationManager = CLLocationManager()
    
    var myMapViewTapRecognizer : UITapGestureRecognizer?
    
    var annotationDataGetter: AnnotationDataGetter?
    //addPictureMode開關
    var addPictureMode : DarwinBoolean? {
        didSet{
            if addPictureMode == true{
                print("addPictureMode == true")
                changeModeBtn.isHidden = true
                addTap.isHidden = true
                hintLabel.isHidden = false
                myMapView.addGestureRecognizer(myMapViewTapRecognizer!)
            }else if addPictureMode == false{
                print("addPictureMode == false")
                changeModeBtn.isHidden = false
                addTap.isHidden = false
                hintLabel.isHidden = true
                myMapView.removeGestureRecognizer(myMapViewTapRecognizer!)
            }
        }
    }
    
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
        myMapView.showsUserLocation = true
        configLocationManager()
        centerMapOnUserLocation()
        configComponent()
        configDataGetter()
        
        addPictureMode = false
    }
    
    
    func configComponent(){
        addTap.addTarget(self, action: #selector(addTapAct), for: .touchUpInside)
        hintLabel.isHidden = true
        
        myMapViewTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(myMapViewTapAct))
        
        myMapView.delegate = self
    }
    
    
    func configDataGetter(){
        annotationDataGetter = AnnotationDataGetter(mapView: myMapView)
        annotationDataGetter?.fetchAnnotationData()
    }
    
    
    @objc func addTapAct(){
        addPictureMode = true
    }
    
    @objc func myMapViewTapAct(_ sender: UITapGestureRecognizer){
        
        print("我按了地圖")
        let tapLocation = sender.location(in: myMapView)                               //獲取Tap時所在的位置
        print(tapLocation)
        
        let tapMapCoordinate = myMapView.convert(tapLocation, toCoordinateFrom: myMapView)
        
        //將屏幕上的x,y轉換為地圖上的經緯度
        print(tapMapCoordinate)
        
        
        let alertController = UIAlertController(title: "確定選取正確座標", message: "", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "新增", style: .default, handler: { action in
            print("使用者按下ok")
            
            let tapViewController = self.storyboard?.instantiateViewController(withIdentifier: "TapViewController")
            (tapViewController as! TapViewController).setCoordinate(latitude: tapMapCoordinate.latitude, longitude: tapMapCoordinate.longitude)
            (tapViewController as! TapViewController).delegate = self
            self.present(tapViewController!, animated: true, completion: nil)
            
            //            let annotation=MKPointAnnotation()
            //                           annotation.title=""
            //                           annotation.coordinate=tapMapCoordinate
            //                           annotation.subtitle = ""
            //            self.myMapView.addAnnotation(annotation)
        })
        
        
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel) { (action)-> Void in
            print("使用者按下取消")
            self.addPictureMode = false
            
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    func centerMapOnUserLocation() {
        print("使用者位置在這")
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




extension MyMapViewController: CLLocationManagerDelegate{
//    func mymapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        //   /*
//        let identifier = "default"
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
//        if annotationView==nil{
//            //如果無指定圖片的話，將圖標的設定為圖，記得圖片需要事先放進Assets Folder
//            annotationView=MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            annotationView?.image=UIImage(named: "pointRed.png")
//        }else{
//            annotationView?.annotation=annotation
//        }
//        return annotationView
//
//    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        print("使用者點擊確認，權限改變了，接下來我要做什麼？")
        //myMapView 原本沒有抓到使用者位置，但現在抓到了，所以我要對使用者位置做zoom in
        centerMapOnUserLocation()
    }
    
}

extension MyMapViewController: TapViewControllerDelegate{
    
    func didPublishLocationData(data: AnnotationData) {
        //上傳firebase
        let ref = Database.database().reference().child("Annotation/" + Auth.auth().currentUser!.uid + "/" + NSUUID().uuidString)
        
        
        ref.setValue(data.toAnyObject()){ (error, ref) -> Void in
            if error != nil{
                print(error ?? "上傳失敗")
            }
        }
        
        addPictureMode = false
    }
}


extension MyMapViewController:MKMapViewDelegate{
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation{
            return nil
        }
        
        print("mkMarker 跑到")
        
        // 創建一個重複使用的 AnnotationView
        var mkMarker = mapView.dequeueReusableAnnotationView(withIdentifier: "Markers") as? MKMarkerAnnotationView
        
        if mkMarker == nil {
            mkMarker = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "Markers")
        }
        
        //        if let headShot = (annotation as! PersonAnnotation).smallHeadShot{
        //            mkMarker?.glyphTintColor = .clear
        //            let imageView = UIImageView(frame: CGRect(x: 2, y: 0, width: 25, height: 25))
        //            imageView.tag = 1
        //            imageView.image = headShot
        //            imageView.contentMode = .scaleAspectFill
        //            imageView.layer.cornerRadius = 12
        //            imageView.clipsToBounds = true
        //            mkMarker?.addSubview(imageView)
        //        }
        
        
        if (annotation is CustomMKAnnotation){
            
            let annotationData = (annotation as! CustomMKAnnotation).annotationData
            
            
            let imageView = UIImageView(frame: CGRect(x: 2, y: 0, width: 25, height: 25))
            imageView.tag = 1
            
            if(annotationData?.photosUrl != nil && (annotationData?.photosUrl!.count)! > 0){
                let url : String = (annotationData?.photosUrl![0])!
                AF.request(url).response { (response) in
                    guard let data = response.data, let image = UIImage(data: data)
                    else { return }
                    imageView.image = image
                }
            }
            
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 5
            //imageView.layer.cornerRadius = 12  圓
            imageView.clipsToBounds = true
            imageView.layer.transform=CATransform3DMakeScale(1.5,1.5, 0);//缩小0.5倍
            mkMarker?.addSubview(imageView)
            mkMarker?.glyphImage = UIImage()
            mkMarker?.markerTintColor = .clear
            
            
            mkMarker?.displayPriority = .required
            mkMarker?.titleVisibility = .adaptive
            
        }
        
        
        return mkMarker
    }
    
    
    
}
