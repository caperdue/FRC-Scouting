//
//  Team.swift
//  FRC Scouting
//
//  Created by Carly Perdue on 5/8/21.
//

import Foundation


struct Team: Codable {
  var number: Int
  var nickName: String?
  var comments: String
  var likeStatus: Int
}
