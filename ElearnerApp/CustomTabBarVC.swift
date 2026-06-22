import UIKit

final class CustomTabBarVC: UIViewController {

    private let containerView = UIView()
    private let tabBarView = UIView()

    private let homeBtn = UIButton(type: .system)
    private let coursesBtn = UIButton(type: .system)
    private let currentBtn = UIButton(type: .system)
    private let ebooksBtn = UIButton(type: .system)
    private let profileBtn = UIButton(type: .system)

    private var currentVC: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        navigationController?.setNavigationBarHidden(true, animated: false)

        setupUI()
        setupButtons()
        selectTab(index: 0)
    }

    private func setupUI() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        tabBarView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(containerView)
        view.addSubview(tabBarView)

        tabBarView.backgroundColor = .white
        tabBarView.layer.cornerRadius = 24
        tabBarView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBarView.layer.shadowColor = UIColor.black.cgColor
        tabBarView.layer.shadowOpacity = 0.15
        tabBarView.layer.shadowOffset = CGSize(width: 0, height: -2)
        tabBarView.layer.shadowRadius = 8

        NSLayoutConstraint.activate([

            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: tabBarView.topAnchor),

            tabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tabBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tabBarView.heightAnchor.constraint(equalToConstant: 75)
        ])
    }

    private func setupButtons() {
        setupButton(homeBtn, title: "Home", image: "house.fill", tag: 0)
        setupButton(coursesBtn, title: "My Courses", image: "book", tag: 1)
        setupButton(currentBtn, title: "Currents", image: "safari", tag: 2)
        setupButton(ebooksBtn, title: "Ebooks", image: "books.vertical", tag: 3)
        setupButton(profileBtn, title: "Profile", image: "person", tag: 4)

        let stack = UIStackView(arrangedSubviews: [
            homeBtn,
            coursesBtn,
            currentBtn,
            ebooksBtn,
            profileBtn
        ])

        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false

        tabBarView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: tabBarView.topAnchor, constant: 8),
            stack.leadingAnchor.constraint(equalTo: tabBarView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: tabBarView.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: tabBarView.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupButton(_ button: UIButton, title: String, image: String, tag: Int) {
        button.tag = tag
        button.tintColor = .gray
        button.setTitle(title, for: .normal)
        button.setImage(UIImage(systemName: image), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 10, weight: .medium)
        button.titleLabel?.textAlignment = .center
        button.contentHorizontalAlignment = .center
        button.addTarget(self, action: #selector(tabTapped(_:)), for: .touchUpInside)

        button.imageEdgeInsets = UIEdgeInsets(top: -18, left: 18, bottom: 0, right: -18)
        button.titleEdgeInsets = UIEdgeInsets(top: 30, left: -18, bottom: 0, right: 18)
    }

    @objc private func tabTapped(_ sender: UIButton) {
        selectTab(index: sender.tag)
    }

    private func selectTab(index: Int) {
        [homeBtn, coursesBtn, currentBtn, ebooksBtn, profileBtn].forEach {
            $0.tintColor = .gray
        }

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: UIViewController

        switch index {
        case 0:
            homeBtn.tintColor = .systemBlue
            vc = storyboard.instantiateViewController(withIdentifier: "HomeVC")

        case 1:
            coursesBtn.tintColor = .systemBlue
            vc = storyboard.instantiateViewController(withIdentifier: "MycoarsesVC")

        case 2:
            currentBtn.tintColor = .systemBlue
            vc = storyboard.instantiateViewController(withIdentifier: "HomeVC")

        case 3:
            ebooksBtn.tintColor = .systemBlue
            vc = storyboard.instantiateViewController(withIdentifier: "HomeVC")

        case 4:
            profileBtn.tintColor = .systemBlue
            vc = storyboard.instantiateViewController(withIdentifier: "HomeVC")

        default:
            return
        }

        changeVC(vc)
    }

    private func changeVC(_ vc: UIViewController) {
        currentVC?.willMove(toParent: nil)
        currentVC?.view.removeFromSuperview()
        currentVC?.removeFromParent()

        addChild(vc)

        vc.view.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(vc.view)

        NSLayoutConstraint.activate([
            vc.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            vc.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            vc.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            vc.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])

        vc.didMove(toParent: self)
        currentVC = vc
    }
}
