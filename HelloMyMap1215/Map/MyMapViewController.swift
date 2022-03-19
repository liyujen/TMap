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
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        // Do any additional setup after loading the view.
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
