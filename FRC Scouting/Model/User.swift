//
//  User.swift
//  FRC Scouting
//
//  Created by Carly Perdue on 5/9/21.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Identifiable, Codable {
  @DocumentID var id: String?
  var uid: String?
  var myTeam: Int?
  var teams: [Int]?
  
  

}


