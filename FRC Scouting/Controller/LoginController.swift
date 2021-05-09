//
//  LoginController.swift
//  FRC Scouting
//
//  Created by Carly Perdue on 5/8/21.
//

import UIKit
import GoogleSignIn
import FirebaseAuth


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
    
    var alert = UIAlertController(title: "Join Team", message: "Please enter team name below.", preferredStyle: UIAlertController.Style.alert)
    
    alert.addTextField { textField in
      textField.placeholder = "3572"
      self.teamTextField = textField
    }
    
    OK = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) { UIAlertAction in
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
      self.signInButton.isEnabled = !self.signInButton.isEnabled
      self.joinTeamButton.isEnabled = !self.joinTeamButton.isEnabled
      if let user = user {
        self.signInButton.alpha = 0.5
        self.joinTeamButton.alpha = 1

        
      } else {
        self.signInButton.alpha = 1
        self.joinTeamButton.alpha = 0.5

}
    }
  }
  

  
  
}

