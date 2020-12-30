//
//  LocationConfirmationViewController.swift
//  On The Map
//
//  Created by Tommy Lam on 12/29/20.
//

import UIKit
import MapKit

class LocationConfirmationViewController: UIViewController, MKMapViewDelegate  {

    var studentLocationInfo: StudentLocationData?
    var mapCoordinate: CLLocationCoordinate2D?

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        var mapAnnotation = MKPointAnnotation()
        mapAnnotation.coordinate = mapCoordinate!
        mapAnnotation.title = "Selected Location"
        self.mapView.addAnnotation(mapAnnotation)
        self.mapView.reloadInputViews()
    }

    @IBAction func confirmAction(_ sender: Any) {
    }

}
