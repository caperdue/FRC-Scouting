//
//  MyTeamsController.swift
//  FRC Scouting
//
//  Created by Carly Perdue on 5/8/21.
//

import UIKit
import FirebaseAuth
import Firebase

class MyTeamsController: UIViewController {
  var teams: [UserTeam] = []
  var uid: String?
  
  @IBOutlet weak var teamsTableView: UITableView!
 
  override func viewDidLoad() {
    super.viewDidLoad()
    teamsTableView.delegate = self
    teamsTableView.dataSource = self
    
    if let uid = Auth.auth().currentUser?.uid {
      let userTeam = UserTeam(id: "897", number:"897", nickname: "j", comments: "kk", likeStatus: "kk")

      let _ = try? Utilities.db.collection("Users").document(uid).collection("teams").document("3572").setData(from: userTeam)
                        
      Utilities.db.collection("Users").document(uid).collection("teams").addSnapshotListener({ document, error in
        if let error = error {
          print(error)
          return
        }

        if let document = document {
          self.teams = document.documents.compactMap({ element in
            return try? element.data(as: UserTeam.self)
          })
        }
        
        self.teamsTableView.reloadData()
      })
    }
    
    //navigationItem.prompt = "Team \(currentUser.myTeam ?? -1)"
    // Register the cells
    let teamNib = UINib(nibName: "TeamCell", bundle: nil)
    teamsTableView.register(teamNib, forCellReuseIdentifier: "TeamCell")
    
  }
  
}

extension MyTeamsController: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return teams.count
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }

  
  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
      return 5
  }
  
  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
          return UIView()
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TeamCell", for: indexPath) as! TeamCell
    cell.teamNumber.text = self.teams[indexPath.section].number

    return cell
    
  }
  //Fix delete bug
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    self.teamsTableView.beginUpdates()
    let currentCell = tableView.cellForRow(at: indexPath)! as! TeamCell
    let uid = Auth.auth().currentUser?.uid
    let teamName = currentCell.teamNumber.text!
    Utilities.db.collection("Users").document(uid!).collection("teams").document(teamName).delete()
    
    }

  
}
