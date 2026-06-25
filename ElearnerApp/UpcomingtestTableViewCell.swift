//
//  UpcomingtestTableViewCell.swift
//  ElearnerApp
//
//  Created by Coding Brains on 23/06/26.
//

import UIKit


class UpcomingtestTableViewCell: UITableViewCell {
    @IBOutlet weak var upcompleteView: UIView!
    @IBOutlet weak var upcompleteLbl: UILabel!
    @IBOutlet weak var starttestBtn: UIButton!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var booktesttitle: UILabel!
    @IBOutlet weak var testView: UIView!
    
    @IBOutlet weak var bookImageview: UIImageView!
    @IBOutlet weak var bookView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    @IBAction func starttestBtn(_ sender: UIButton) {
    }
    

}
