//
//  OnboardingVC.swift
//  ElearnerApp
//
//  Created by Coding Brains on 19/06/26.
//

import UIKit

class OnboardingVC: UIViewController {

    @IBOutlet weak var nextBTN: UIButton!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var onboardingCollectiopnView: UICollectionView!
    var slides: [OnboardingSlide] = []
    let indicatorStack = UIStackView()
        var indicators: [UIView] = []

    var currentPage = 0 {
        didSet {
            updateIndicator()
            if currentPage == slides.count - 1 {
                nextBTN.setTitle("Get Started", for: .normal)
            } else {
                nextBTN.setTitle("Next", for: .normal)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        onboardingCollectiopnView.delegate = self
        onboardingCollectiopnView.dataSource = self
        
        nextBTN.layer.cornerRadius = 10
        
        slides = [
            OnboardingSlide(
                title: "Learn Without Limits",
                description: "JAccess quality courses from top educators anytime.",
                image: #imageLiteral(resourceName: "onboarding1"),
            ),
            OnboardingSlide(
                title: "Watch & Leam",
                description: "Engasina video lessons to help you understand better.",
                image: #imageLiteral(resourceName: "onboarding2"),
                
            ),
            OnboardingSlide(
                title: "Achieve Your Goals",
                description: "Track progress, clear doubts and achve suscess.",
                image: #imageLiteral(resourceName: "onboarding3"),
            )
        ]
        pageController.isHidden = true
                setupCustomIndicator()
        
        
    }
    func setupCustomIndicator() {

           indicatorStack.axis = .horizontal
           indicatorStack.spacing = 8
           indicatorStack.alignment = .center
           indicatorStack.distribution = .fill
           indicatorStack.translatesAutoresizingMaskIntoConstraints = false

           view.addSubview(indicatorStack)

           NSLayoutConstraint.activate([
               indicatorStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
               indicatorStack.bottomAnchor.constraint(equalTo: nextBTN.topAnchor, constant: 25),
               indicatorStack.heightAnchor.constraint(equalToConstant: 10)
           ])

           for i in 0..<slides.count {
               let view = UIView()
               view.backgroundColor = i == 0 ? .systemBlue : .systemGray4
               view.layer.cornerRadius = 4
               view.translatesAutoresizingMaskIntoConstraints = false

               view.widthAnchor.constraint(equalToConstant: i == 0 ? 28 : 8).isActive = true
               view.heightAnchor.constraint(equalToConstant: 8).isActive = true

               indicators.append(view)
               indicatorStack.addArrangedSubview(view)
           }
       }
    func updateIndicator() {

            for (index, indicator) in indicators.enumerated() {

                for constraint in indicator.constraints {
                    if constraint.firstAttribute == .width {
                        indicator.removeConstraint(constraint)
                    }
                }

                let width: CGFloat = index == currentPage ? 28 : 8

                indicator.widthAnchor.constraint(equalToConstant: width).isActive = true

                UIView.animate(withDuration: 0.25) {
                    indicator.backgroundColor = index == self.currentPage ? .systemBlue : .systemGray4
                    self.indicatorStack.layoutIfNeeded()
                }
            }
        }
    
    @IBAction func nextTappedBtn(_ sender: UIButton) {
        if currentPage == slides.count - 1 {
                    UserDefaults.standard.set(true, forKey: "onboardingSeen")

            let vc = UIStoryboard(name: "Main", bundle: nil)
                    .instantiateViewController(withIdentifier: "LoginVC") as! LoginVC

                navigationController?.pushViewController(vc, animated: true)
                    return
                }

                currentPage += 1

                onboardingCollectiopnView.scrollToItem(
                    at: IndexPath(item: currentPage, section: 0),
                    at: .centeredHorizontally,
                    animated: true
                )
    }
    
    

}
extension OnboardingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = onboardingCollectiopnView.dequeueReusableCell(withReuseIdentifier: "OnboardingCollectionViewCell", for: indexPath) as! OnboardingCollectionViewCell
        cell.setup(slides[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
}

   

