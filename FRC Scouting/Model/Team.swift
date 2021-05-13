//
//  Team.swift
//  FRC Scouting
//
//  Created by Carly Perdue on 5/9/21.
//

import Foundation
import FirebaseFirestoreSwift

struct Team: Identifiable, Codable {
  @DocumentID var id: String?
  var admins: [String]?

}
