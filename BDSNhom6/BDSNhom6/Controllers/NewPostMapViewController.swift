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

class NewPostMapViewController: UIViewController, UIGestureRecognizerDelegate, UISearchBarDelegate {
    //MARK: Properties
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var btnDone: UIBarButtonItem!
    @IBOutlet weak var txtSearch: UISearchBar!
    
    //MARK: Configurations
    let locationManager = CLLocationManager()
    var coord : CLLocationCoordinate2D? = nil;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // request user location
        requestLocationAccess()
        
        // gesture action
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
        
        // searchbar delegate
        txtSearch.delegate = self
        
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
    
    //MARK: Search address
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let address = txtSearch.text;
        
        if (address?.isEmpty == true) {
            present(Common.Notification(title: "Lỗi", mess: "Xin hãy nhập địa chỉ", okBtn: "Ok"), animated: true, completion: nil);
            return;
        }
        
        // search address
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address!) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    // handle no location found
                    self.present(Common.Notification(title: "Lỗi", mess: "Không tìm thấy địa chỉ này", okBtn: "Ok"), animated: true, completion: nil);
                    return
            }
            
            // clear all anno before add new one
            self.mapView.removeAnnotations(self.mapView.annotations);
            
            // Use your location
            self.coord = location.coordinate;
            
            // add to map annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            self.mapView.addAnnotation(annotation)
        }
    }
    
    //MARK: On Map Tap
    func handleTap(_ gestureReconizer: UITapGestureRecognizer) {
        // clear all anno before add new one
        mapView.removeAnnotations(mapView.annotations);
        
        let location = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
        
        coord = coordinate; // set current coord record
        
        // Add annotation:
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }
    
    //MARK: On Cancel Select Map
    @IBAction func onCancelClick(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Preparing data before go back
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender);
        
        guard let btn = sender as? UIBarButtonItem, btn === btnDone else {
            print("BtnDone not pressed");
            return;
        }
        
        
        // ok now we can return safely
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        // check before done
        if (identifier == "unWindMapSelected")
        {
            if coord == nil {
                let alert = Common.Notification(title: "Lỗi", mess: "Xin hãy nhấp chọn địa điểm của bạn!", okBtn: "Tôi biết rồi")
                self.present(alert, animated: true, completion: nil)
                return false;
            }
        }
        
        return true;
    }
}
