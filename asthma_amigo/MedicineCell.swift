//
//  MedicineCell.swift
//  asthma_amigo
//
//  Created by Apurba Nath on 4/4/19.
//  Copyright © 2019 Apurba Nath. All rights reserved.
//

import UIKit

class MedicineCell: UITableViewCell {
    
    @IBOutlet weak var medImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var alertImg: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
