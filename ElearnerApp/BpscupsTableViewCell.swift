import UIKit

class BpscupsTableViewCell: UITableViewCell {

    private let cardView = UIView()
    private let courseImageView = UIImageView()
    private let titleLbl = UILabel()
    private let descriptionLbl = UILabel()
    private let priceLbl = UILabel()
    private let buyBtn = UIButton(type: .system)

    var onViewDetails: (() -> Void)?

    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
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
        cardView.layer.cornerRadius = 16
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.shadowOpacity = 0.08
        cardView.layer.shadowOffset = CGSize(width: 0, height: 4)
        cardView.layer.shadowRadius = 10
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)

        courseImageView.contentMode = .scaleAspectFill
        courseImageView.layer.cornerRadius = 12
        courseImageView.clipsToBounds = true
        courseImageView.backgroundColor = UIColor(red: 0.95, green: 0.90, blue: 0.93, alpha: 1)
        courseImageView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(courseImageView)

        titleLbl.font = .boldSystemFont(ofSize: 15)
        titleLbl.textColor = .black
        titleLbl.numberOfLines = 2
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(titleLbl)

        descriptionLbl.font = .systemFont(ofSize: 12)
        descriptionLbl.textColor = .darkGray
        descriptionLbl.numberOfLines = 2
        descriptionLbl.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(descriptionLbl)

        priceLbl.font = .boldSystemFont(ofSize: 17)
        priceLbl.textColor = UIColor(red: 239/255, green: 35/255, blue: 84/255, alpha: 1)
        priceLbl.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(priceLbl)

        buyBtn.setTitle("View Details", for: .normal)
        buyBtn.backgroundColor = UIColor(red: 239/255, green: 35/255, blue: 84/255, alpha: 1)
        buyBtn.setTitleColor(.white, for: .normal)
        buyBtn.titleLabel?.font = .boldSystemFont(ofSize: 12)
        buyBtn.layer.cornerRadius = 9
        buyBtn.translatesAutoresizingMaskIntoConstraints = false
        buyBtn.addTarget(self, action: #selector(viewDetailsTapped), for: .touchUpInside)
        cardView.addSubview(buyBtn)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            courseImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            courseImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            courseImageView.widthAnchor.constraint(equalToConstant: 105),
            courseImageView.heightAnchor.constraint(equalToConstant: 105),

            titleLbl.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 18),
            titleLbl.leadingAnchor.constraint(equalTo: courseImageView.trailingAnchor, constant: 12),
            titleLbl.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),

            descriptionLbl.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 6),
            descriptionLbl.leadingAnchor.constraint(equalTo: titleLbl.leadingAnchor),
            descriptionLbl.trailingAnchor.constraint(equalTo: titleLbl.trailingAnchor),

            priceLbl.leadingAnchor.constraint(equalTo: titleLbl.leadingAnchor),
            priceLbl.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -18),

            buyBtn.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            buyBtn.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -14),
            buyBtn.widthAnchor.constraint(equalToConstant: 95),
            buyBtn.heightAnchor.constraint(equalToConstant: 34)
        ])
    }

    func configure(with item: CategoryItem) {
        titleLbl.text = item.title
        descriptionLbl.text = item.description
        priceLbl.text = "₹\(item.price ?? "0")"

        if let image = item.image {
            courseImageView.loadImage(from: image)
        }
    }

    @objc private func viewDetailsTapped() {
        onViewDetails?()
    }
}
