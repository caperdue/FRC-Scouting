//
//  UserTeam.swift
//  FRC Scouting
//
//  Created by Carly Perdue on 5/8/21.
//

import Foundation
import FirebaseFirestoreSwift

struct UserTeam: Codable, Identifiable {
  @DocumentID var id: String?
  var number: Int
  var nickname: String?
  var comments: String?
  var likeStatus: Int
  
}


