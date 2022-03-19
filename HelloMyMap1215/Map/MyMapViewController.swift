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
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)   {
        print("init nibName style")
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        print("init coder style")
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        // Do any additional setup after loading the view.
        
        
        // view.backgroundColor = .green
    }
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //         Get the new view controller using segue.destination.
    //         Pass the selected object to the new view controller.
    //    }
    //
    
}
