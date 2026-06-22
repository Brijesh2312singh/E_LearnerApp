//
//  PurchasedCoursesTableViewCell.swift
//  ElearnerApp
//
//  Created by Coding Brains on 22/06/26.
//

import UIKit



class PurchasedCoursesTableViewCell: UITableViewCell {

    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var calenderBtn: UIButton!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var upscprelimsyearLbl: UILabel!
    @IBOutlet weak var yearLbl: UILabel!
    @IBOutlet weak var prelimsLbl: UILabel!
    @IBOutlet weak var upscLbl: UILabel!
    @IBOutlet weak var upscprelmsView: UIView!
    @IBOutlet weak var coursesView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        coursesView.layer.cornerRadius = 10
        upscprelmsView.layer.cornerRadius = 10
        
       
    }

    @IBAction func calenderTapped(_ sender: UIButton) {
    }
    
    @IBAction func nextTappedBtn(_ sender: UIButton) {
    }
    
}
