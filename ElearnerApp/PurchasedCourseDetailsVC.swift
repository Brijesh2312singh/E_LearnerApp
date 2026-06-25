import UIKit
import WebKit

final class PurchasedCourseDetailsVC: UIViewController {

    var course: MyCourse?

    private let titleLbl = UILabel()
    private let descLbl = UILabel()
    private let imageView = UIImageView()
    private let validityLbl = UILabel()
    private let priceLbl = UILabel()
    private let watchBtn = UIButton(type: .system)
    private let backBtn = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setData()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(red: 1, green: 0.96, blue: 0.97, alpha: 1)

        backBtn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backBtn.tintColor = .black
        backBtn.backgroundColor = .white
        backBtn.layer.cornerRadius = 18
        backBtn.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backBtn)

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16

        titleLbl.font = .boldSystemFont(ofSize: 22)
        titleLbl.numberOfLines = 0

        descLbl.font = .systemFont(ofSize: 15)
        descLbl.textColor = .darkGray
        descLbl.numberOfLines = 0

        validityLbl.font = .boldSystemFont(ofSize: 15)
        priceLbl.font = .boldSystemFont(ofSize: 18)

        watchBtn.setTitle("Watch Course", for: .normal)
        watchBtn.backgroundColor = UIColor(red: 239/255, green: 35/255, blue: 84/255, alpha: 1)
        watchBtn.setTitleColor(.white, for: .normal)
        watchBtn.layer.cornerRadius = 14
        watchBtn.addTarget(self, action: #selector(watchTapped), for: .touchUpInside)

        [imageView, titleLbl, descLbl, validityLbl, priceLbl, watchBtn].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            backBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            backBtn.widthAnchor.constraint(equalToConstant: 36),
            backBtn.heightAnchor.constraint(equalToConstant: 36),

            imageView.topAnchor.constraint(equalTo: backBtn.bottomAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.heightAnchor.constraint(equalToConstant: 210),

            titleLbl.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            titleLbl.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            titleLbl.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),

            descLbl.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 12),
            descLbl.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            descLbl.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),

            validityLbl.topAnchor.constraint(equalTo: descLbl.bottomAnchor, constant: 20),
            validityLbl.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),

            priceLbl.topAnchor.constraint(equalTo: validityLbl.bottomAnchor, constant: 10),
            priceLbl.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),

            watchBtn.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            watchBtn.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            watchBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            watchBtn.heightAnchor.constraint(equalToConstant: 56)
        ])
    }

    private func setData() {
        guard let course = course else { return }

        titleLbl.text = course.title
        descLbl.text = course.description
        validityLbl.text = "Validity: \(course.validity ?? "")"
        priceLbl.text = "₹\(course.price ?? "0")"

        if let image = course.image {
            imageView.loadImage(from: image)
        }
    }

    @objc private func watchTapped() {
        guard let video = course?.video, !video.isEmpty else {
            print("VIDEO URL NIL")
            return
        }

        print("VIDEO URL:", video)

        let vc = CourseVideoVC()
        vc.videoURL = video
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
}
