//
//  Utilities.swift
//  FRC Scouting
//
//  Created by Carly Perdue on 5/8/21.
//

import UIKit
import Firebase
import FirebaseAuth


class Utilities {
  static let db = Firestore.firestore()
  
  static let uid = Auth.auth().currentUser?.uid
}
