//
//  OnboardingCollectionViewCell.swift
//  ElearnerApp
//
//  Created by Coding Brains on 19/06/26.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    let identifier = String(describing: OnboardingCollectionViewCell.self)
    @IBOutlet weak var slideTitleDescriptionLbl: UILabel!
    @IBOutlet weak var slideTitleLbl: UILabel!
    @IBOutlet weak var slideimageView: UIImageView!
    func setup(_ slide: OnboardingSlide) {
        slideimageView.image = slide.image
        slideTitleLbl.text = slide.title
        slideTitleDescriptionLbl.text = slide.description
    }
}
