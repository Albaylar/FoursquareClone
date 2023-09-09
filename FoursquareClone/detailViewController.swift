//
//  detailViewController.swift
//  FoursquareClone
//
//  Created by Furkan Deniz Albaylar on 8.09.2023.
//

import UIKit
import MapKit
import Firebase
import FirebaseFirestore

class detailViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var detailsMapView: MKMapView!
    @IBOutlet weak var detailsAtmosphereLabel: UILabel!
    @IBOutlet weak var detailsTypeLabel: UILabel!
    @IBOutlet weak var detailsNameLabel: UILabel!
    @IBOutlet weak var detailsImageView: UIImageView!
    var chosenlatitude = Double()
    var chosenLongitude = Double()
    
    
    var chosenPlaceId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailsMapView.delegate = self
        
        
        let FireStoreDataBase = Firestore.firestore()
        let refStore = FireStoreDataBase.collection("DataPlace").document(chosenPlaceId)
         
        refStore.getDocument { [self] document, error in
            if let document = document {
                let data = document.data()
                
                if let placeName = data?["PostName"] as? String {
                    self.detailsNameLabel.text = placeName
                }
                if let placeType = data?["PlaceType"] as? String {
                    self.detailsTypeLabel.text = placeType
                }
                if let placeAtmosphere = data?["Atmosphere"] as? String {
                    self.detailsAtmosphereLabel.text = placeAtmosphere
                }
                if let placeImage = data?["imageUrl"] as? String {
                    if let url = URL(string: placeImage) {
                        do{
                            if let imageData = try? Data(contentsOf: url) {
                                self.detailsImageView.image = UIImage(data: imageData)
                            }
                        }catch{
                            self.makeAlert(title: "Errror", message: error.localizedDescription)
                            
                        }
                        
                    }
                }
                if let placeLatitude = data?["Place Latitude"] as? String {
                    if let placeLatitudeDouble = Double(placeLatitude) {
                        self.chosenlatitude = placeLatitudeDouble
                        
                    }
                }
                if let placeLongitude = data?["Place Longitude"] as? String {
                    if let placeLongitudeDouble = Double(placeLongitude) {
                        self.chosenLongitude = placeLongitudeDouble
                    }
                }
                let location = CLLocationCoordinate2D(latitude: self.chosenlatitude, longitude: self.chosenLongitude)
                let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                let region = MKCoordinateRegion(center: location, span: span)
                self.detailsMapView.setRegion(region, animated: true)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = location
                annotation.title = " \(self.detailsNameLabel.text ?? "")"
                self.detailsMapView.addAnnotation(annotation)
                
            }
        }
    }
    
    func makeAlert(title: String , message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
        
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
            
        }else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if self.chosenLongitude != 0.0 && self.chosenlatitude != 0.0 {
            let requestLocation = CLLocation(latitude: self.chosenlatitude, longitude: self.chosenLongitude)
            CLGeocoder().reverseGeocodeLocation(requestLocation) { placemarks, error in
                if let placemark = placemarks {
                    if placemark.count > 0 {
                        let mkPlaceMark = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: mkPlaceMark)
                        mapItem.name = self.detailsNameLabel.text
                        
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                        mapItem.openInMaps(launchOptions: launchOptions)
                        
                    }
                    
                }
            }
        }
    }
    
}
