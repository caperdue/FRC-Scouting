//
//  AppDelegate.swift
//  FRC Scouting
//
//  Created by Carly Perdue on 5/8/21.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

@main

class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
  
  func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
    if let error = error {
       // Exit early. Error occurred or user has chosen to not sign in at this point
      return
     }

     guard let authentication = user.authentication else { return }
     let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
    

    
    Auth.auth().signIn(with: credential, completion: {(result, error) in
      if let error = error {
        return
      }
      let uid = Auth.auth().currentUser?.uid
      Utilities.db.collection("Users").document(uid!).getDocument(completion: {(document, error) in
        // User already exists, do nothing
        if let document = document, document.exists {
          return
        }
        
        // Create the new user
        else {
          do {
            let newUser = User(id: uid, uid: uid, myTeam: nil, teams: nil)
            let _ = try Utilities.db.collection("Users").document(uid!).setData(from: newUser)
          }
          
          catch {
            print(error)
          }
        
        }

    })

  })
    }


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    FirebaseApp.configure()
    GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
    GIDSignIn.sharedInstance().delegate = self
    
    return true
  }

  // MARK: UISceneSession Lifecycle

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }


}

