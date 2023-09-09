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

class detailViewController: UIViewController {

    @IBOutlet weak var detailsMapView: MKMapView!
    @IBOutlet weak var detailsAtmosphereLabel: UILabel!
    @IBOutlet weak var detailsTypeLabel: UILabel!
    @IBOutlet weak var detailsNameLabel: UILabel!
    @IBOutlet weak var detailsImageView: UIImageView!
    
    var chosenPlaceId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let FireStoreDataBase = Firestore.firestore()
        let refStore = FireStoreDataBase.collection("DataPlace").document(chosenPlaceId)
        
        refStore.getDocument { document, error in
            if let document = 
        }
    }
}
