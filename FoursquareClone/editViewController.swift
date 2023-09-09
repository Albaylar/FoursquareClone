//
//  detailViewController.swift
//  FoursquareClone
//
//  Created by Furkan Deniz Albaylar on 8.09.2023.
//

import UIKit


class editViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var atmosphereText: UITextField!
    @IBOutlet weak var typeText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        placeImageView.isUserInteractionEnabled = true
        let imageTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTap))
        placeImageView.addGestureRecognizer(imageTapRecognizer)
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(gestureRecognizer)
    }

    @objc func hideKeyboard(){
        self.view.endEditing(true)
    }
    @objc func imageTap(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
    @IBAction func nextButtonClicked(_ sender: Any) {
        
        if nameText.text != "" && typeText.text != "" && atmosphereText.text != "" {
            if let chosenImage = placeImageView.image {
                let placeModel = PlaceModel.sharedInstance
                placeModel.placeName = nameText.text!
                placeModel.placeType = typeText.text!
                placeModel.placeAtmosphere = atmosphereText.text!
                placeModel.placeImage = chosenImage
                 
            }
            performSegue(withIdentifier: "toMapViewController", sender: nil)
        } else {
            makeAlert(title: "Error", message: "OK")
        }
        func makeAlert(title: String , message: String){
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
            alert.addAction(okButton)
            self.present(alert, animated: true)
            
        }
        
    }
    
}
