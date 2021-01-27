//
//  AddNewLocationViewController.swift
//  On The Map
//
//  Created by Tommy Lam on 12/29/20.
//
// Used location tutorial: https://cocoacasts.com/forward-geocoding-with-clgeocoder

import UIKit
import MapKit

class AddNewLocationViewController: UIViewController {

    var studentCoordinate: CLLocationCoordinate2D?

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func searchAction(_ sender: Any) {
        searchActionInProgress(status: true)
        if (!locationTextField.text!.isEmpty) {
            CLGeocoder().geocodeAddressString(locationTextField.text!) { (placemarks, error) in
                if let locationError = error {
                    self.searchActionInProgress(status: false)
                    let alertVC = UIAlertController(title: error?.localizedDescription, message: "Location Error", preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertVC, animated: true)
                } else {
                    self.searchActionInProgress(status: false)
                    var enteredLocation: CLLocation!

                    enteredLocation = placemarks?.first?.location
                    print("Coordinates: ")
                    print("\(enteredLocation.coordinate.latitude), \(enteredLocation.coordinate.longitude)")
                    self.studentCoordinate = enteredLocation.coordinate
                    self.performSegue(withIdentifier: "performSearch", sender: nil)
                }
            }
        } else {
            searchActionInProgress(status: false)
            let alertVC = UIAlertController(title: "Missing Location", message: "Please enter a location", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertVC, animated: true)
        }
    }

    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "performSearch" {
            let confirmationVC = segue.destination as! LocationConfirmationViewController
            confirmationVC.locationName = locationTextField.text
            confirmationVC.studentLocationInfo = createStudentLocationDataObject(studentCoordinate!)
            confirmationVC.mapCoordinate = studentCoordinate
        }
    }

    func createStudentLocationDataObject(_ coordinate: CLLocationCoordinate2D) -> StudentLocationData{
        return StudentLocationData(createdAt: "", firstName: UdacityAPI.Auth.firstName, lastName: UdacityAPI.Auth.lastName, latitude: coordinate.latitude, longitude: coordinate.longitude, mapString: locationTextField.text, mediaURL: urlTextField.text, objectId: UdacityAPI.Auth.objectId, uniqueKey: UdacityAPI.Auth.key, updatedAt: "")
    }

    func searchActionInProgress(status: Bool) {
        status ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()

        locationTextField.isEnabled = !status
        urlTextField.isEnabled  = !status
    }
}
