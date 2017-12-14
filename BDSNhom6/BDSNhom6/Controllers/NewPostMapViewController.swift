//
//  NewPostMapViewController.swift
//  BDSNhom6
//
//  Created by Phat Tran on 12/15/17.
//  Copyright © 2017 Nhom 6 Estate. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class NewPostMapViewController: UIViewController, UIGestureRecognizerDelegate {
    //MARK: Properties
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: Configurations
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // request user location
        requestLocationAccess()
        
        // gesture action
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    //MARK: Request permission location
    func requestLocationAccess() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return
            
        case .denied, .restricted:
            print("location access denied")
            
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    //MARK: On Map Tap
    func handleTap(_ gestureReconizer: UITapGestureRecognizer) {
        // clear all anno before add new one
        mapView.removeAnnotations(mapView.annotations);
        
        let location = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
        
        // Add annotation:
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
    
    //MARK: On Cancel Select Map
    @IBAction func onCancelClick(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
