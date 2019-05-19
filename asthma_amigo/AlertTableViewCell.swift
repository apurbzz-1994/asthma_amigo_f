//
//  AlertTableViewCell.swift
//  asthma_amigo
//
//  Created by Apurba Nath on 8/5/19.
//  Copyright © 2019 Apurba Nath. All rights reserved.
//

import UIKit

class AlertTableViewCell: UITableViewCell {
    
    @IBOutlet weak var summaryLabel: UILabel!
    
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }

}
