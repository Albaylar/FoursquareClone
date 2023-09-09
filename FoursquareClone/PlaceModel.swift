//
//  PlaceModel.swift
//  FoursquareClone
//
//  Created by Furkan Deniz Albaylar on 8.09.2023.
//

import Foundation
import UIKit

class PlaceModel {
    static let sharedInstance = PlaceModel()
    var placeName =  ""
    var placeType = ""
    var placeAtmosphere = ""
    var placeImage = UIImage()
    var placeLongtitude = ""
    var placeLatitude = ""
    
    private init(){
        
    }
 }
