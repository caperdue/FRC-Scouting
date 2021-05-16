//
//  MyTeamsController.swift
//  FRC Scouting
//
//  Created by Carly Perdue on 5/8/21.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestoreSwift

class MyTeamsController: UIViewController {
  var teams: [UserTeam] = []
  var uid: String?
  var searchActive: Bool = false
  var filtered:[UserTeam] = []
  
  @IBOutlet weak var teamsTableView: UITableView!
  @IBOutlet weak var searchBar: UISearchBar!

  
 
  override func viewDidLoad() {
    super.viewDidLoad()
    teamsTableView.delegate = self
    teamsTableView.dataSource = self
    searchBar.delegate = self
    
    self.teams.sort { team1, team2 in
      return team1.number > team2.number
    }
    
   // navigationItem.hidesBackButton = true
    
    if let uid = Auth.auth().currentUser?.uid {

      Utilities.db.collection("Users").document(uid).collection("teams").addSnapshotListener({ document, error in
        if let error = error {
          print(error)
          return
        }

        if let document = document {
          self.teams = document.documents.compactMap({ QueryDocumentSnapshot -> UserTeam? in
            return try? QueryDocumentSnapshot.data(as: UserTeam.self)
            
          })
        }
        
        
        self.teamsTableView.reloadData()
      })
      let _ = try? Utilities.db.collection("Users").document(uid).collection("teams").document("50").setData(from: UserTeam(id: "50", number: 50, nickname: nil, comments: nil, likeStatus: 0))
    }
    
    //navigationItem.prompt = "Team \(currentUser.myTeam ?? -1)"
    // Register the cells
    let teamNib = UINib(nibName: "TeamCell", bundle: nil)
    teamsTableView.register(teamNib, forCellReuseIdentifier: "TeamCell")
    
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    searchBar.endEditing(true)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    searchBar.endEditing(true)
  }
  
}

extension MyTeamsController: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return searchActive ? filtered.count : teams.count
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
  //TODO: Fix index out of range!!
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "TeamCell", for: indexPath) as! TeamCell
    let tmpTeam = searchActive ? self.filtered[indexPath.section] : self.teams[indexPath.section]
    
    cell.teamNumber.text = String(tmpTeam.number)
    
    switch tmpTeam.likeStatus {
      case 0:
        cell.likeStatus.tintColor = UIColor.red
        cell.likeStatus.image = UIImage(systemName: "hand.thumbsdown.fill")
      case 2:
        cell.likeStatus.tintColor = UIColor.green
        cell.likeStatus.image = UIImage(systemName: "hand.thumbsup.fill")
          
     
      default:
        cell.likeStatus.image = nil
    }

    return cell
    
  }

  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    self.teamsTableView.beginUpdates()
    let currentCell = tableView.cellForRow(at: indexPath)! as! TeamCell
    let uid = Auth.auth().currentUser?.uid
    let teamName = currentCell.teamNumber.text!
    
    //Delete the item in firebase, then delete the cell locally
    Utilities.db.collection("Users").document(uid!).collection("teams").document(teamName).delete()
    self.teamsTableView.deleteRows(at: [indexPath], with: .fade)
    self.teamsTableView.deleteSections([indexPath.section], with: .fade)
    self.teams.remove(at: indexPath.section)
    self.teamsTableView.endUpdates()
    
    }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.performSegue(withIdentifier: "scoutEditSegue", sender: self)
  }

  
}

extension MyTeamsController: UISearchBarDelegate {
  func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    searchActive = true
  }
  func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    searchActive = false
  }
  func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchActive = false
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchActive = false
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    filtered = teams.filter({ team -> Bool in
      let tmp: NSString = String(team.number) as NSString
      var range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
      if let nickname = team.nickname {
        let tmp2: NSString = String(nickname) as NSString
        let range2 = tmp2.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
        range.formUnion(range2)
      }
      return range.location != NSNotFound
    })
    
    if filtered.count == 0 {
      searchActive = false
    }
    else {
      searchActive = true
    }
    
    self.teamsTableView.reloadData()
  }
}
