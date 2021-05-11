//
//  UserTeam.swift
//  FRC Scouting
//
//  Created by Carly Perdue on 5/8/21.
//

import Foundation
import FirebaseFirestoreSwift

struct UserTeam: Identifiable, Codable {
  @DocumentID var id: String?
  var number: Int
  var nickName: String?
  var comments: String
  var likeStatus: Int
}
