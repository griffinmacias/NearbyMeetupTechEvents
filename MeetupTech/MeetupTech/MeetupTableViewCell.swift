//
//  MeetupTableViewCell.swift
//  MeetupTech
//
//  Created by Mason Macias on 10/19/16.
//  Copyright © 2016 griffinmacias. All rights reserved.
//

import UIKit

class MeetupTableViewCell: UITableViewCell {
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func clearContents() {
        self.nameLabel.text = ""
        self.addressLabel.text = ""
        self.distanceLabel.text = ""
        self.imageView?.image = nil
    }

    
}
