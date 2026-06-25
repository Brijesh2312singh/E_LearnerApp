import UIKit

final class NotificationsVC: UIViewController {

    private let tableView = UITableView()

    private let notifications = [
        ("Your doubt has been answered", "Teacher replied to your History doubt."),
        ("Course purchased successfully", "History Prelims Test Series added to My Courses."),
        ("New Live Test Available", "BPSC Live Mock Test is now available."),
        ("Payment Successful", "Your Razorpay payment was completed.")
    ]
    private let backBtn = UIButton(type: .system)
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    private func setupUI() {
        view.backgroundColor = UIColor(red: 1, green: 0.96, blue: 0.97, alpha: 1)
        title = "Notifications"
        backBtn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backBtn.tintColor = .black
        backBtn.backgroundColor = .white
        backBtn.layer.cornerRadius = 18
        backBtn.layer.shadowColor = UIColor.black.cgColor
        backBtn.layer.shadowOpacity = 0.08
        backBtn.layer.shadowOffset = CGSize(width: 0, height: 2)
        backBtn.layer.shadowRadius = 4
        backBtn.addTarget(self, action: #selector(backTapped), for: .touchUpInside)

        backBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backBtn)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NotificationCell.self, forCellReuseIdentifier: "NotificationCell")

        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        NSLayoutConstraint.activate([

            backBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backBtn.widthAnchor.constraint(equalToConstant: 36),
            backBtn.heightAnchor.constraint(equalToConstant: 36),

            tableView.topAnchor.constraint(equalTo: backBtn.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension NotificationsVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notifications.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "NotificationCell",
            for: indexPath
        ) as! NotificationCell

        let item = notifications[indexPath.row]
        cell.configure(title: item.0, subtitle: item.1)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        92
    }
}

final class NotificationCell: UITableViewCell {

    private let cardView = UIView()
    private let iconView = UIImageView()
    private let titleLbl = UILabel()
    private let subtitleLbl = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none

        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 14

        iconView.image = UIImage(systemName: "bell.fill")
        iconView.tintColor = UIColor(red: 239/255, green: 35/255, blue: 84/255, alpha: 1)

        titleLbl.font = .boldSystemFont(ofSize: 15)
        subtitleLbl.font = .systemFont(ofSize: 13)
        subtitleLbl.textColor = .darkGray
        subtitleLbl.numberOfLines = 2

        [cardView, iconView, titleLbl, subtitleLbl].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        contentView.addSubview(cardView)
        cardView.addSubview(iconView)
        cardView.addSubview(titleLbl)
        cardView.addSubview(subtitleLbl)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7),

            iconView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            iconView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 26),
            iconView.heightAnchor.constraint(equalToConstant: 26),

            titleLbl.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            titleLbl.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 14),
            titleLbl.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),

            subtitleLbl.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 6),
            subtitleLbl.leadingAnchor.constraint(equalTo: titleLbl.leadingAnchor),
            subtitleLbl.trailingAnchor.constraint(equalTo: titleLbl.trailingAnchor)
        ])
    }

    func configure(title: String, subtitle: String) {
        titleLbl.text = title
        subtitleLbl.text = subtitle
    }
}
