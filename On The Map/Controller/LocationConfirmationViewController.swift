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
    var locationName: String?

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        var mapAnnotation = MKPointAnnotation()
        mapAnnotation.coordinate = mapCoordinate!
        mapAnnotation.title = "Selected Location: \(locationName!)"
        mapView.addAnnotation(mapAnnotation)
        mapView.showAnnotations(mapView.annotations, animated: true)
    }

    @IBAction func confirmAction(_ sender: Any) {
        ParseAPI.addNewLocation(locationData: studentLocationInfo!) {(success,error) in
            if success {
                DispatchQueue.main.async {
                    print("Add new location success")
                    self.dismiss(animated: true, completion: nil)
                }
            } else {
                DispatchQueue.main.async {
                    
                    let alertVC = UIAlertController(title: "Error", message: error?.localizedDescription ?? "", preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertVC, animated: true)
                }
            }
        }
    }

}
