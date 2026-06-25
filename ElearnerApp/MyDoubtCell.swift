import UIKit

final class MyDoubtCell: UITableViewCell {
    
    private let cardView = UIView()
    private let statusLbl = UILabel()
    private let titleLbl = UILabel()
    private let questionLbl = UILabel()
    private let answerTitleLbl = UILabel()
    private let answerLbl = UILabel()
    
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
        cardView.layer.cornerRadius = 16
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)
        
        [statusLbl, titleLbl, questionLbl, answerTitleLbl, answerLbl].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            cardView.addSubview($0)
        }
        
        statusLbl.font = .boldSystemFont(ofSize: 13)
        titleLbl.font = .boldSystemFont(ofSize: 17)
        questionLbl.font = .systemFont(ofSize: 14)
        questionLbl.numberOfLines = 0
        
        answerTitleLbl.text = "Teacher Answer"
        answerTitleLbl.font = .boldSystemFont(ofSize: 14)
        
        answerLbl.font = .systemFont(ofSize: 14)
        answerLbl.numberOfLines = 0
        answerLbl.textColor = .darkGray
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            statusLbl.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 14),
            statusLbl.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 14),
            
            titleLbl.topAnchor.constraint(equalTo: statusLbl.bottomAnchor, constant: 10),
            titleLbl.leadingAnchor.constraint(equalTo: statusLbl.leadingAnchor),
            titleLbl.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -14),
            
            questionLbl.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 8),
            questionLbl.leadingAnchor.constraint(equalTo: titleLbl.leadingAnchor),
            questionLbl.trailingAnchor.constraint(equalTo: titleLbl.trailingAnchor),
            
            answerTitleLbl.topAnchor.constraint(equalTo: questionLbl.bottomAnchor, constant: 14),
            answerTitleLbl.leadingAnchor.constraint(equalTo: titleLbl.leadingAnchor),
            
            answerLbl.topAnchor.constraint(equalTo: answerTitleLbl.bottomAnchor, constant: 6),
            answerLbl.leadingAnchor.constraint(equalTo: titleLbl.leadingAnchor),
            answerLbl.trailingAnchor.constraint(equalTo: titleLbl.trailingAnchor),
            answerLbl.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -14)
        ])
    }
    
    func configure(with item: MyDoubt) {
        
        let status = item.status ?? "pending"
        
        statusLbl.text = status == "answered"
        ? "🟢 Answered"
        : "🟡 Pending"
        
        titleLbl.text = item.title ?? ""
        
        questionLbl.text = """
        Subject: \(item.subject ?? "")
        
        Q: \(item.message ?? "")
        """
        
        if let reply = item.admin_reply,
           !reply.isEmpty {
            
            answerTitleLbl.isHidden = false
            answerLbl.isHidden = false
            answerLbl.text = reply
            
        } else {
            
            answerTitleLbl.isHidden = true
            answerLbl.isHidden = true
        }
    }
}
