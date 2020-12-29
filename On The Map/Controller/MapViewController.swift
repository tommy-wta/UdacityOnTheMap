//
//  MapViewController.swift
//  On The Map
//
//  Created by Tommy Lam on 12/8/20.
//
// using code and tutorial on MKMap from Hacking with Swift: https://www.hackingwithswift.com/example-code/location/how-to-add-annotations-to-mkmapview-using-mkpointannotation-and-mkpinannotationview

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    var listOfStudentInfo = [StudentLocationData]()
    var mapCoordinates = [MKPointAnnotation]()

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        locationDataReload()

    }

    func locationDataReload() {
        getStudentInfo()
    }

    func getStudentInfo() {
        ParseAPI.getStudentLocationUsingUrl() {(returnedStudentList, error) in
            self.listOfStudentInfo = returnedStudentList ?? []
            self.mapView.removeAnnotations(self.mapCoordinates)
            self.mapCoordinates.removeAll()
            for studentInfo in self.listOfStudentInfo {
                let studentLatData = CLLocationDegrees(studentInfo.latitude ?? 0.0)
                let studentLongData = CLLocationDegrees(studentInfo.longitude ?? 0.0)
                let studentCoordinate = CLLocationCoordinate2D(latitude: studentLatData, longitude: studentLongData)

                let studentFirstName = studentInfo.firstName
                let studentLastName = studentInfo.lastName
                let studentMediaUrl = studentInfo.mediaURL

                let newCoordinate = MKPointAnnotation()
                newCoordinate.coordinate = studentCoordinate
                newCoordinate.title = "\(studentFirstName) \(studentLastName)"
                newCoordinate.subtitle = studentMediaUrl

                self.mapCoordinates.append(newCoordinate)
            }
            DispatchQueue.main.async {
                self.mapView.addAnnotations(self.mapCoordinates)
            }
        }
    }

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

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
            annotationView!.tintColor = .blue
            annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            annotationView!.annotation = annotation
        }

        return annotationView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let mediaLink = view.annotation?.subtitle {
                guard let url = URL(string: mediaLink ?? ""), UIApplication.shared.canOpenURL(url) else {
                    let alertVC = UIAlertController(title: "Bad URL", message: "Unable to open URL", preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    present(alertVC, animated: true)
                    return
                }
                UIApplication.shared.open(url, options: [:])
            }
        }
    }
}
