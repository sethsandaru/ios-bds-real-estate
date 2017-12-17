//
//  PostMapViewController.swift
//  BDSNhom6
//
//  Created by Phat Tran on 12/17/17.
//  Copyright © 2017 Nhom 6 Estate. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PostMapViewController: UIViewController {
    //MARK: Properties
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: Config
    var post : Post? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        guard post != nil else {
            print("Post error");
            // show error message
            
            // pop to frontpage
            self.navigationController?.popViewController(animated: true);
            return;
        }

        // add marker
        if post?.Latt == 0 && post?.Long == 0 {
            // looking for address
            let geoCoder = CLGeocoder();
            geoCoder.geocodeAddressString((post?.Address)!) {
                (placemarks, error) in
                
                guard
                    let placemarks = placemarks,
                    let location = placemarks.first?.location
                    else {
                        // handle no location found
                        self.present(Common.Notification(title: "Lỗi", mess: "Không tìm thấy địa chỉ này", okBtn: "Ok"), animated: true, completion: nil);
                        return
                }
                
                // set coord
                self.post?.Latt = Double(location.coordinate.latitude);
                self.post?.Long = Double(location.coordinate.longitude);
                self.setAnno();
            }
        }
        else {
            // set anno to this
            setAnno();
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setAnno()
    {
        let coord : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: (post?.Latt)!, longitude: (post?.Long)!)
        
        // Add annotation:
        let annotation = MKPointAnnotation()
        annotation.coordinate = coord
        mapView.addAnnotation(annotation)
        
        // camera to anno
        mapView.showAnnotations(mapView.annotations, animated: true);
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
