//
//  ScoutTeamController.swift
//  FRC Scouting
//
//  Created by Carly Perdue on 5/15/21.
//

import Foundation
import UIKit

class ScoutTeamController: UIViewController {
  var images: [UIImage] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let rightBarButton = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.saveTapped(_:)))
   
    self.navigationItem.rightBarButtonItem = rightBarButton
    //TODO: Add horizontal collection view for images.
    imgCollectionView.dataSource = self
    imgCollectionView.delegate = self
    imgCollectionView.alwaysBounceHorizontal = true
    
    
  }

  @IBOutlet weak var teamNumberField: UITextField!
  @IBOutlet weak var teamNameField: UITextField!
  @IBOutlet weak var commentsTextView: UITextView!
  @IBOutlet weak var likeControl: UISegmentedControl!
  @IBOutlet weak var imgCollectionView: UICollectionView!
  
  @objc func saveTapped(_ sender: UIBarButtonItem) {
    
    
    let numText = teamNumberField.text!
    if !numText.isEmpty && Int(numText) != nil {
      let commentText = commentsTextView.text!.isEmpty ? nil : commentsTextView.text!
      
      do {
    
        _ = try Utilities.db.collection("Users").document(Utilities.uid!).collection("teams").document(teamNumberField.text!).setData(from: UserTeam(id: numText, number: Int(numText)!, nickname: teamNameField.text!, comments: commentText, likeStatus: likeControl.selectedSegmentIndex))
     
      }
      
      catch {
        
        print(error.localizedDescription)
        
      }
      navigationController?.popViewController(animated: true)
    }
  }
}
extension ScoutTeamController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return images.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
  }
  
  
}
