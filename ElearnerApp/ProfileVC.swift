import UIKit

final class ProfileVC: UIViewController {

    private let headerView = UIView()
    private let profileImageView = UIImageView()
    private let nameLbl = UILabel()
    private let emailLbl = UILabel()
    private let tableView = UITableView()

    let menuItems = [
        ("person.fill", "My Profile"),
        ("book.fill", "My Courses"),
        ("questionmark.circle.fill", "My Doubts"),
        ("bell.fill", "Notifications"),
        ("creditcard.fill", "Payment History"),
        ("lock.fill", "Change Password"),
        ("rectangle.portrait.and.arrow.right", "Logout")
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTable()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(red: 1, green: 0.96, blue: 0.97, alpha: 1)

        headerView.backgroundColor = UIColor(red: 239/255, green: 35/255, blue: 84/255, alpha: 1)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)

        profileImageView.image = UIImage(systemName: "person.circle.fill")
        profileImageView.tintColor = .white
        profileImageView.contentMode = .scaleAspectFit

        nameLbl.text = "Brijesh Singh"
        nameLbl.textColor = .white
        nameLbl.font = .boldSystemFont(ofSize: 22)

        emailLbl.text = "brijesh123@gmail.com"
        emailLbl.textColor = .white.withAlphaComponent(0.9)
        emailLbl.font = .systemFont(ofSize: 14)

        [profileImageView, nameLbl, emailLbl].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            headerView.addSubview($0)
        }

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 230),

            profileImageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: nameLbl.topAnchor, constant: -12),
            profileImageView.widthAnchor.constraint(equalToConstant: 82),
            profileImageView.heightAnchor.constraint(equalToConstant: 82),

            nameLbl.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            nameLbl.bottomAnchor.constraint(equalTo: emailLbl.topAnchor, constant: -6),

            emailLbl.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            emailLbl.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -30),

            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupTable() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(ProfileOptionCell.self, forCellReuseIdentifier: "ProfileOptionCell")
    }
}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        menuItems.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "ProfileOptionCell",
            for: indexPath
        ) as! ProfileOptionCell
        
        cell.configure(icon: menuItems[indexPath.row].0, title: menuItems[indexPath.row].1)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: UIViewController
        
        switch indexPath.row {
            
        case 0:
            navigationController?.pushViewController(MyProfileVC(), animated: true)
            
        case 1:
            
            vc = storyboard.instantiateViewController(withIdentifier: "MycoarsesVC")
            
        case 2:
            navigationController?.pushViewController(MyDoubtsVC(), animated: true)
            
        case 3:
            navigationController?.pushViewController(NotificationsVC(), animated: true)
            
        case 4:
            navigationController?.pushViewController(
                PaymentHistoryVC(),
                animated: true
            )

        case 5:
            navigationController?.pushViewController(
                ChangePasswordVC(),
                animated: true
            )

        case 6:
            logoutTapped()
            
        default:
            break
        }
    }
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    private func logoutTapped() {
        let alert = UIAlertController(
            title: "Logout",
            message: "Are you sure you want to logout?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive) { _ in
            UserDefaults.standard.removeObject(forKey: "authToken")
            UserDefaults.standard.synchronize()
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            let nav = UINavigationController(rootViewController: vc)
            
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = scene.windows.first {
                window.rootViewController = nav
                window.makeKeyAndVisible()
            }
        })
        
        present(alert, animated: true)
    }
}
