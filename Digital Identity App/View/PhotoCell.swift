//
//  PhotoCell.swift
//  Digital Identity App
//
//  Created by Mohammadreza Sadeghi on 30/03/2021.
//

import UIKit

class PhotoCell: UITableViewCell {
    @IBOutlet var photoView: UIView!
    @IBOutlet var photoImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        photoView.layer.cornerRadius = photoView.frame.size.height / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
