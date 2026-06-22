//
//  BpscclassesCollectionViewCell.swift
//  ElearnerApp
//
//  Created by Coding Brains on 19/06/26.
//

import UIKit

class BpscclassesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var coursetitlename: UILabel!
    @IBOutlet weak var bpscicon: UIImageView!
    @IBOutlet weak var bookView: UIView!
    @IBOutlet weak var bpscView: UIView!
    
    override func awakeFromNib() {
            super.awakeFromNib()
        bookView.layer.cornerRadius = 10
        

            coursetitlename.numberOfLines = 0
            coursetitlename.textAlignment = .center
            coursetitlename.text = "BPSC-UP\nSC"
        }
}
