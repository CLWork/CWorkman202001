//
//  HomeScreenCell.swift
//  WorkmanCiera_HealthyPawz
//
//  Created by Ciera on 1/24/20.
//  Copyright © 2020 Ciera Workman. All rights reserved.
//

import UIKit

class HomeScreenCell: UITableViewCell {

    @IBOutlet weak var petNameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    @IBOutlet weak var petPhoto: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
   
}
