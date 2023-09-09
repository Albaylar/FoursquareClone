//
//  ListViewController.swift
//  FoursquareClone
//
//  Created by Furkan Deniz Albaylar on 8.09.2023.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class ListViewController: UIViewController {
    
    var placeNameArray = [String]()
    var placeIdArray = [String]()
    var selectedPlaceId = ""
    var selectedPlaceName = ""
    var selectedImage = UIImage()
    var selectedAtmosphere = ""
    var selectedType = ""

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        upadteUI()
        getDataFromFirestore()
        
        
    }
    
    
    

    func upadteUI(){
        tableView.dataSource = self
        tableView.delegate = self
        let navigationButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButton))
        let logOutButton = UIBarButtonItem(title: "LogOut", style: .plain,target: self, action: #selector(addLogOutButton))
        self.navigationItem.rightBarButtonItem = navigationButton
        self.navigationItem.leftBarButtonItem = logOutButton
    }
    func getDataFromFirestore(){
        
        let firestoreDatabase = Firestore.firestore()
        firestoreDatabase.collection("DataPlace").order(by: "Date",descending: true) //Orderby kısmı date e göre sıralamak için kullanılıyor.
            .addSnapshotListener { snapshot, error in
            if error != nil {
                print(error?.localizedDescription)
            }else{
                if snapshot?.isEmpty != true {
                    
                    self.placeNameArray.removeAll(keepingCapacity: false)
                    self.placeIdArray.removeAll(keepingCapacity: false)
                                                  
                    for document in snapshot!.documents {
                        let documentId = document.documentID
                        self.placeIdArray.append(documentId)
                        

                        if let name = document.get("PostName") as? String {
                            self.placeNameArray.append(name)
                        }
                        
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    @objc func addButton() {
        performSegue(withIdentifier: "toDetailVC", sender: nil)
    }
    @objc func addLogOutButton(){
        do{
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "toViewController", sender: nil)
        } catch {
            print(error.localizedDescription)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toUserView" {
            let destinationVC = segue.destination as! detailViewController
            destinationVC.chosenPlaceId = selectedPlaceId
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPlaceId = placeIdArray[indexPath.row]
        self.performSegue(withIdentifier: "toUserView", sender: nil)
    }
   

}
extension ListViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = placeNameArray[indexPath.row]
        return cell
    }
    
    
}
