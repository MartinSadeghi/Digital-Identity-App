//
//  MessageCell.swift
//  Digital Identity App
//
//  Created by Mohammadreza Sadeghi on 25/03/2021.
//

import UIKit

class MasterCell: UITableViewCell {

    @IBOutlet var msgBubble: UIView!
    @IBOutlet var msgLabel: UILabel!
    @IBOutlet var personImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        msgBubble.layer.cornerRadius = msgBubble.frame.size.height / 5
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
