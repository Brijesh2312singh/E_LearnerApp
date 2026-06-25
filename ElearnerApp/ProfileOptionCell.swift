import UIKit

final class ProfileOptionCell: UITableViewCell {

    private let cardView = UIView()
    private let iconView = UIImageView()
    private let titleLbl = UILabel()
    private let arrowLbl = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear

        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 14
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)

        iconView.tintColor = UIColor(red: 239/255, green: 35/255, blue: 84/255, alpha: 1)
        titleLbl.font = .systemFont(ofSize: 16, weight: .semibold)
        arrowLbl.text = "›"
        arrowLbl.font = .systemFont(ofSize: 24)
        arrowLbl.textColor = .gray

        [iconView, titleLbl, arrowLbl].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            cardView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),

            iconView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            iconView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),

            titleLbl.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 14),
            titleLbl.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),

            arrowLbl.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            arrowLbl.centerYAnchor.constraint(equalTo: cardView.centerYAnchor)
        ])
    }

    func configure(icon: String, title: String) {
        iconView.image = UIImage(systemName: icon)
        titleLbl.text = title
    }
}
