//
//  TeamCell.swift
//  FRC Scouting
//
//  Created by Carly Perdue on 5/8/21.
//

import UIKit

class TeamCell: UITableViewCell {
  
  @IBOutlet weak var teamNumber: UILabel!
  @IBOutlet weak var likeStatus: UIImageView!
  @IBOutlet weak var background: UIView!
  
  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        background.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
