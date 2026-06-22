//
//  MyclassesCollectionViewCell.swift
//  ElearnerApp
//
//  Created by Coding Brains on 19/06/26.
//

import UIKit

class MyclassesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var myclassesView: UIView!
    
    @IBOutlet weak var classesLbl: UILabel!
    @IBOutlet weak var classesicon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        myclassesView.layer.borderWidth = 1
        myclassesView.layer.borderColor = UIColor.gray.cgColor
        myclassesView.layer.cornerRadius = 10
    }
}
