//
//  ScoutTeamController.swift
//  FRC Scouting
//
//  Created by Carly Perdue on 5/15/21.
//

import Foundation
import UIKit

class ScoutTeamController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let rightBarButton = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.saveTapped(_:)))
    
    self.navigationItem.rightBarButtonItem = rightBarButton
    
    
  }

  @IBOutlet weak var teamNumberField: UITextField!
  @IBOutlet weak var teamNameField: UITextField!
  @IBOutlet weak var commentsTextView: UITextView!
  @IBOutlet weak var likeControl: UISegmentedControl!
  
  
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
