//
//  HistoryTableViewCell.swift
//  CambioMoedasDIO
//
//  Created by Felipe Santos on 14/01/24.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public func setTitle(_ title: String) {
        lblTitle.text = title
    }
}
