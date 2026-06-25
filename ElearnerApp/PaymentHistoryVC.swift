import UIKit

struct PaymentHistoryResponse: Codable {
    let success: Bool
    let message: String
    let payments: [PaymentItem]
}

struct PaymentItem: Codable {
    let id: Int
    let user_id: Int?
    let order_id: Int?
    let amount: String?
    let payment_method: String?
    let payment_id: String?
    let status: String?
    let created_at: String?
}

final class PaymentHistoryVC: UIViewController {

    private let backBtn = UIButton(type: .system)
    private let titleLbl = UILabel()
    private let tableView = UITableView()

    private var payments: [PaymentItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchPaymentHistory()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(red: 1, green: 0.96, blue: 0.97, alpha: 1)

        backBtn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backBtn.tintColor = .black
        backBtn.backgroundColor = .white
        backBtn.layer.cornerRadius = 18
        backBtn.addTarget(self, action: #selector(backTapped), for: .touchUpInside)

        titleLbl.text = "Payment History"
        titleLbl.font = .boldSystemFont(ofSize: 24)
        titleLbl.textColor = .black

        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PaymentHistoryCell.self, forCellReuseIdentifier: "PaymentHistoryCell")

        [backBtn, titleLbl, tableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            backBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backBtn.widthAnchor.constraint(equalToConstant: 36),
            backBtn.heightAnchor.constraint(equalToConstant: 36),

            titleLbl.centerYAnchor.constraint(equalTo: backBtn.centerYAnchor),
            titleLbl.leadingAnchor.constraint(equalTo: backBtn.trailingAnchor, constant: 16),

            tableView.topAnchor.constraint(equalTo: backBtn.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func fetchPaymentHistory() {
        let url = URL(string: "https://unarmored-dropper-blatantly.ngrok-free.dev/api/payments/history")!
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, error in

            if let error = error {
                print("Payment History Error:", error.localizedDescription)
                return
            }

            guard let data = data else { return }

            print("PAYMENT HISTORY RAW:", String(data: data, encoding: .utf8) ?? "")

            do {
                let result = try JSONDecoder().decode(PaymentHistoryResponse.self, from: data)

                DispatchQueue.main.async {
                    self.payments = result.payments
                    self.tableView.reloadData()
                }

            } catch {
                print("Decode Error:", error)
            }

        }.resume()
    }

    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
}

extension PaymentHistoryVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return payments.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "PaymentHistoryCell",
            for: indexPath
        ) as! PaymentHistoryCell

        cell.configure(with: payments[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 118
    }
}
