//
//  MapViewController.swift
//  On The Map
//
//  Created by Tommy Lam on 12/8/20.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    var listOfStudentInfo = [StudentLocationData]()

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        // LocationDataReload
    }

    func locationDataReload() {
        getStudentInfo()
    }

    func getStudentInfo() {
        ParseAPI.getStudentLocationUsingUrl() {(returnedStudentList, error) in
            self.listOfStudentInfo = returnedStudentList ?? []
            DispatchQueue.main.async {
                //self.tableView.reloadData()
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func logoutAction(_ sender: Any) {
        UdacityAPI.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    @IBAction func addNewLocationAction(_ sender: Any) {
    }

    @IBAction func refreshAction(_ sender: Any) {
        locationDataReload()
    }
}
