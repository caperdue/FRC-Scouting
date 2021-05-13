//
//  LoginController.swift
//  FRC Scouting
//
//  Created by Carly Perdue on 5/8/21.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import Firebase


class LoginController: UIViewController {
  
  @IBOutlet weak var signInButton: UIButton!
  @IBOutlet weak var joinTeamButton: UIButton!
  @IBOutlet weak var signOutButton: UIButton!
  
  var teamTextField = UITextField()
  var OK = UIAlertAction()
  var cancel = UIAlertAction()
  
  @IBAction func signInPressed(_ sender: UIButton) {
    GIDSignIn.sharedInstance().signIn()

  }
  
  @IBAction func joinTeamPressed(_ sender: UIButton) {
    let alert = UIAlertController(title: "Join Team", message: "Please enter team name below.", preferredStyle: UIAlertController.Style.alert)
    
    alert.addTextField { textField in
      textField.placeholder = "3572"
      self.teamTextField = textField
    }

    OK = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { UIAlertAction in
      Utilities.db.collection("Teams").document(self.teamTextField.text!).getDocument { document, error in
        // Team already exists
        let uid = Auth.auth().currentUser?.uid
        let teamEntry = self.teamTextField.text!
        let team = Team(id: teamEntry, admins: nil)
        
        do {
          if let document = document, document.exists {
        
          }
          else {
            // No team in existence, create it a
              let _ = try Utilities.db.collection("Teams").document(teamEntry).setData(from: team)
          
          }
            
            // Reset the user's assigned team
            let user = User(id: uid, uid: uid, myTeam: Int(teamEntry)!, teams: nil)
            let _ = try Utilities.db.collection("Users").document(uid!).setData(from: user, merge: true)
          

        }
        
        catch {
          print(error)
        }
        
        self.performSegue(withIdentifier: "myTeamsSegue", sender: self)
    }
    }
      
    OK.isEnabled = false
    cancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { UIAlertAction in
//
    }
    
    teamTextField.addTarget(self, action: #selector(textFieldEditingDidChange(sender:)), for: UIControl.Event.editingChanged)
    
    alert.addAction(OK)
    alert.addAction(cancel)
    self.present(alert, animated: true, completion: nil)

    
  }
  @IBAction func signOutPressed(_ sender: UIButton) {
    do {
      try Auth.auth().signOut()
    } catch let signOutError as NSError {
      print ("Error signing out: %@", signOutError)
    }
  }
  @objc func textFieldEditingDidChange(sender: Any) {
    if teamTextField.text == "" {
      OK.isEnabled = false
      
    }
    else {
      OK.isEnabled = true
    }
  }
  override func viewDidLoad() {
    
    super.viewDidLoad()
    GIDSignIn.sharedInstance()?.presentingViewController = self

    // Add state listener
    Auth.auth().addStateDidChangeListener { auth, user in
      if let user = user {
        // Check if user is assigned to a team yet
        Utilities.db.collection("Users").document(user.uid).getDocument( completion: { document, error in
          if let error = error {
            print(error.localizedDescription + "hi")
            return
          }
          // Check if user has a team assigned.
          if let document = document, document.exists, document.data()?["myTeam"] != nil {
            // Means user has a team assigned already.
            self.performSegue(withIdentifier: "myTeamsSegue", sender: self)
            return
            
          }
          // User has no team.
          else {
            self.signInButton.alpha = 0.5
            self.joinTeamButton.alpha = 1
            self.signInButton.isEnabled = false
            self.joinTeamButton.isEnabled = true
          }
        })
 
      
        
      }
      // User is not signed in
      else {
        
        self.signInButton.alpha = 1
        self.joinTeamButton.alpha = 0.5
        
        self.signInButton.isEnabled = true
        self.joinTeamButton.isEnabled = false

      }
    }
  }
  

  
  
}

