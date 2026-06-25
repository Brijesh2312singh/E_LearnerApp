import UIKit

final class PaymentHistoryCell: UITableViewCell {

    private let cardView = UIView()
    private let amountLbl = UILabel()
    private let statusLbl = UILabel()
    private let paymentIdLbl = UILabel()
    private let methodLbl = UILabel()
    private let dateLbl = UILabel()

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
        backgroundColor = .clear
        selectionStyle = .none

        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 15
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)

        amountLbl.font = .boldSystemFont(ofSize: 18)
        amountLbl.textColor = UIColor(red: 239/255, green: 35/255, blue: 84/255, alpha: 1)

        statusLbl.font = .boldSystemFont(ofSize: 13)
        statusLbl.textAlignment = .center
        statusLbl.layer.cornerRadius = 10
        statusLbl.clipsToBounds = true

        paymentIdLbl.font = .systemFont(ofSize: 12)
        paymentIdLbl.textColor = .darkGray

        methodLbl.font = .systemFont(ofSize: 13)
        methodLbl.textColor = .black

        dateLbl.font = .systemFont(ofSize: 12)
        dateLbl.textColor = .gray

        [amountLbl, statusLbl, paymentIdLbl, methodLbl, dateLbl].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            cardView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7),

            amountLbl.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            amountLbl.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),

            statusLbl.centerYAnchor.constraint(equalTo: amountLbl.centerYAnchor),
            statusLbl.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            statusLbl.widthAnchor.constraint(equalToConstant: 86),
            statusLbl.heightAnchor.constraint(equalToConstant: 28),

            paymentIdLbl.topAnchor.constraint(equalTo: amountLbl.bottomAnchor, constant: 10),
            paymentIdLbl.leadingAnchor.constraint(equalTo: amountLbl.leadingAnchor),
            paymentIdLbl.trailingAnchor.constraint(equalTo: statusLbl.leadingAnchor, constant: -10),

            methodLbl.topAnchor.constraint(equalTo: paymentIdLbl.bottomAnchor, constant: 8),
            methodLbl.leadingAnchor.constraint(equalTo: amountLbl.leadingAnchor),

            dateLbl.centerYAnchor.constraint(equalTo: methodLbl.centerYAnchor),
            dateLbl.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16)
        ])
    }

    func configure(with item: PaymentItem) {
        amountLbl.text = "₹\(item.amount ?? "0")"

        let status = item.status ?? "unknown"
        statusLbl.text = status.capitalized

        if status == "success" || status == "paid" {
            statusLbl.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.15)
            statusLbl.textColor = .systemGreen
        } else if status == "created" {
            statusLbl.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.15)
            statusLbl.textColor = .systemOrange
        } else {
            statusLbl.backgroundColor = UIColor.systemRed.withAlphaComponent(0.15)
            statusLbl.textColor = .systemRed
        }

        paymentIdLbl.text = "Payment ID: \(item.payment_id ?? "-")"
        methodLbl.text = "Method: \(item.payment_method ?? "-")"
        dateLbl.text = item.created_at?.prefix(10).description ?? ""
    }
}
