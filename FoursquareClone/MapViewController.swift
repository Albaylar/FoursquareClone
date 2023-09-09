//
//  MapViewController.swift
//  FoursquareClone
//
//  Created by Furkan Deniz Albaylar on 8.09.2023.
//

import UIKit
import MapKit
import FirebaseStorage
import Firebase
import FirebaseFirestore

class MapViewController: UIViewController ,MKMapViewDelegate , CLLocationManagerDelegate{
    
    var locationManager = CLLocationManager()

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "< Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButtonClicked))
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveButtonClicked))
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer: )))
        recognizer.minimumPressDuration = 2
        mapView.addGestureRecognizer(recognizer)
    }
    @objc func chooseLocation(gestureRecognizer : UIGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            let touches = gestureRecognizer.location(in: self.mapView)
            let coordinates = self.mapView.convert(touches, toCoordinateFrom: self.mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = PlaceModel.sharedInstance.placeName
            annotation.subtitle = PlaceModel.sharedInstance.placeType
            
            self.mapView.addAnnotation(annotation)
            
            PlaceModel.sharedInstance.placeLatitude = String(coordinates.latitude)
            PlaceModel.sharedInstance.placeLongtitude = String(coordinates.longitude)
            
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    @objc func saveButtonClicked(){
        // FireBase
        let placeModel = PlaceModel.sharedInstance
        let storage = Storage.storage()
        let storageReferance = storage.reference()
        let mediaFolder = storageReferance.child("Media")
        
        if let data = placeModel.placeImage.jpegData(compressionQuality: 0.05) {
            let uuid = UUID().uuidString
            let imageReferance = mediaFolder.child("\(uuid).jpg")
            imageReferance.putData(data,metadata: nil) { metadata, error in
                if error != nil {
                    self.makeAlert(title: "Errror", message: error?.localizedDescription ?? "")
                }else{
                    imageReferance.downloadURL { url, error in
                        if error == nil {
                            let imageUrl = url?.absoluteString
                            //Database
                            let firestoreDataBase = Firestore.firestore()
                            var firestoreReferance : DocumentReference? = nil
                            let fireStorePost = ["imageUrl": imageUrl ?? "","PostedBy":Auth.auth().currentUser?.email! ?? "","PostName" : placeModel.placeName,"PlaceType": placeModel.placeType,"Atmosphere":placeModel.placeAtmosphere,"Date": FieldValue.serverTimestamp(),"Place Longitude": placeModel.placeLongtitude,"Place Latitude" : placeModel.placeLatitude] as [String:Any]
                            firestoreReferance = firestoreDataBase.collection("DataPlace").addDocument(data: fireStorePost,completion: { error in
                                if error != nil {
                                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "")
                                }else{
                                    self.performSegue(withIdentifier: "toListVC", sender: nil)
                                    placeModel.placeImage = UIImage(systemName:"plus.app")!
                                    placeModel.placeName = ""
                                    placeModel.placeType = ""
                                    placeModel.placeAtmosphere = ""
                                }
                            })
                            
                        }
                    }
                }
            }
        }
    }
    @objc func backButtonClicked(){
        //performSegue(withIdentifier: "backToDetail", sender: nil)
        self.dismiss(animated:true, completion: nil)
    }
    func makeAlert(title: String , message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
        
    }
}
