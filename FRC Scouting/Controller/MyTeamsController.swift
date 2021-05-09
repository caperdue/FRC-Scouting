//
//  MyTeamsController.swift
//  FRC Scouting
//
//  Created by Carly Perdue on 5/8/21.
//

import UIKit

class MyTeamsController: UIViewController {
  var myTeams: [Team] = [Team(number: 9, nickName: nil, comments: "", likeStatus: 0), Team(number: 9, nickName: nil, comments: "", likeStatus: 0)]
  
  @IBOutlet weak var teamsTableView: UITableView!
 
  override func viewDidLoad() {
    super.viewDidLoad()
    teamsTableView.delegate = self
    teamsTableView.dataSource = self
    
    let teamNib = UINib(nibName: "TeamCell", bundle: nil)
    teamsTableView.register(teamNib, forCellReuseIdentifier: "TeamCell")
  }
}

extension MyTeamsController: UITableViewDelegate, UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return myTeams.count
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
    let cell = tableView.dequeueReusableCell(withIdentifier: "TeamCell", for: indexPath) as UITableViewCell
    
    return cell
    
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
    self.teamsTableView.beginUpdates()
    myTeams.remove(at: indexPath.section)
    teamsTableView.deleteRows(at: [indexPath], with: .fade)
    teamsTableView.deleteSections(IndexSet([indexPath.section]), with: .fade)
    self.teamsTableView.endUpdates()
    }

  
  
}
