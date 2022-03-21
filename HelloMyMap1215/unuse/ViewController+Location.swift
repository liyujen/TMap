//
//  ViewController+Location.swift
//  HelloMyMap1215
//
//  Created by student on 2021/12/15.
//

//import Foundation
//import CoreLocation
//import MapKit
//棄用
//extension ViewController:CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//      guard  let location = locations.last else {
//         assertionFailure("Invalid locations.")
//          return
//      }
////        let coordinate = mainMapView.centerCoordinate
//       let coordinate = location.coordinate
////          print("Lat: \(coordinate.latitude), Lon: \(coordinate.longitude)")
//
//      //  Add a annotation view.
//        var storeCoordinate = coordinate
//    storeCoordinate.latitude += 0.0001
//    storeCoordinate.longitude  += 0.0001
////        Move and Zoom the map
//
////
//        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
//        let region = MKCoordinateRegion(center: coordinate, span: span)
//
//        mainMapView.setRegion(region, animated: true)
//
//    }
//}
////enum StoreType {
////    case seven
////    case family
////    case ok
////}
//
////class StoreInfo : NSObject, MKAnnotation{
////    var coordinate: CLLocationCoordinate2D
////    var title: String?
////    var subtitle: String?
////
////    var streType:StoreType?
////
////
////    init(coordinate: CLLocationCoordinate2D) {
////        self.coordinate = coordinate
////
////    }
////}
////extension ViewController: MKMapViewDelegate{
////    func mapView(_ mapView: MKMapView,regionDidChangeAnimated animated: Bool){
////        let region = mapView.region
////        let center = region.center
////        print("Region Updated:\(center.latitude),\(center.longitude)")
////    }
////    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
////     //   /*
//
//      //   */
//        /*
//        if annotation is MKUserLocation {
//            return nil
//        }
//        let storeID = "store"
//        var result = mapView.dequeueReusableAnnotationView(withIdentifier: storeID) //as? MKPinAnnotationView
//
//        if result == nil {
//            //result = MKPinAnnotationView(annotation: annotation, reuseIdentifier: storeID)
//            result = MKAnnotationView(annotation: annotation, reuseIdentifier: storeID)
//        }else{
//            result?.annotation = annotation
//        }
//        result?.canShowCallout = true
//        //result?.pinTintColor = .green  //決定圖標顏色
//       // result?.animatesDrop = true      //圖標降落圖動畫
//
//        let image = UIImage(named: "pointRed.png")
//        result?.image = image
//
//        // Left callout accressory view.
//        result?.leftCalloutAccessoryView = UIImageView(image: image)
//        // Right callout accressory view.
//        let button = UIButton(type: .detailDisclosure) //"i"
//        button.addTarget(self, action: #selector(infoBtnPressed(sender:)), for: .touchUpInside)
//        result?.rightCalloutAccessoryView = button
//
//
//        return result
//
//    }
//         */
////    @objc
////    func infoBtnPressed(sender: UIButton){
////        let alert = UIAlertController(title: "KFC",message: "導航前往?", preferredStyle: .alert)
////        let ok = UIAlertAction(title: "是", style: .default){action in
////            self.navigateTo()
////        }
////        let cancel = UIAlertAction(title: "取消", style: .cancel)
////        alert.addAction(ok)
////        alert.addAction(cancel)
////        present(alert,animated: true)
////    }
////    func navigateTo(){
////        let targetAddress = "台北市北投區崇仰一路5-5號"
////        //ADDRESS -> Lat/Lon
////        let geocoder1 = CLGeocoder()
////        //Async
////        //1)
////        geocoder1.geocodeAddressString(targetAddress){ placemarks,error in
////            if let error = error {
////                print("geocodaAddressString error: \(error)")
////                return
////            }
////            guard let placemark = placemarks?.first,
////                  let coordinate = placemark.location?.coordinate else {
////                      assertionFailure("Invalid Placemark")
////                      return
////                  }
////            print("Lat, Lon:\(coordinate.latitude),\(coordinate.longitude)")
////            //Prepare source map item.
////            let sourceCoordinate = CLLocationCoordinate2DMake(24.686525, 121.815312)
////            let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate)
////            let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
////            //Prepare target map item.
////            let targetPlacemark = MKPlacemark(placemark: placemark)
////            let targetMapItem = MKMapItem(placemark: targetPlacemark)
////
////            let options = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
////            // My LOcation ->B
////           // targetMapItem.openInMaps(launchOptions: options)
////            //A->B
////            let items = [sourceMapItem,targetMapItem]
////            MKMapItem.openMaps(with: items,launchOptions: options)
////
////        }
////        //2)
////        //Lat/Lon -> ADDRESS
////        let geocoder2 = CLGeocoder()
////        let homeLocation = CLLocation(latitude: 25.125459, longitude: 121.510076)
////        geocoder2.reverseGeocodeLocation(homeLocation){ placemarks,error in
////            if let error = error {
////                print("reverseGeocodeLocation error: \(error)")
////                return
////            }
////            guard let placemark = placemarks?.first
//////                  let coordinate = placemark.location?.coordinate
////            else {
////            assertionFailure("Invalid Placemark")
////                return
////        }
////        let postCode = placemark.postalCode ?? "n/a"
////        let countryCode = placemark.isoCountryCode ?? "n/a"
////            let description = placemark.description
////        print("\(postCode)\(countryCode)\(description)")
////    }
////}
////}
////
