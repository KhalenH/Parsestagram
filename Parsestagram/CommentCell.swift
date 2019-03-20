//
//  CommentCell.swift
//  Parsestagram
//
//  Created by Khalen Hudson on 3/19/19.
//  Copyright © 2019 Khalen Hudson. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UIView!
    
    @IBOutlet weak var commentLabel: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
