import UIKit

struct MyDoubtsResponse: Codable {
    let success: Bool
    let doubts: [MyDoubt]
}

struct MyDoubt: Codable {
    let id: Int
    let user_id: Int?
    let batch: String?
    let subject: String?
    let title: String?
    let message: String?
    let image: String?
    let pdf: String?
    let audio: String?
    let status: String?
    let admin_reply: String?
    let replied_at: String?
    let created_at: String?
}

final class MyDoubtsVC: UIViewController {

    private let tableView = UITableView()
    private var doubts: [MyDoubt] = []
    private let backBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        btn.tintColor = .black
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 18
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 0.1
        btn.layer.shadowOffset = CGSize(width: 0, height: 2)
        btn.layer.shadowRadius = 4
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        backBtn.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        setupUI()
        fetchMyDoubts()
    }
    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    private let titleLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "My Doubts"
        lbl.font = .boldSystemFont(ofSize: 24)
        return lbl
    }()
    private func setupUI() {
        view.backgroundColor = UIColor(red: 1, green: 0.96, blue: 0.97, alpha: 1)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MyDoubtCell.self, forCellReuseIdentifier: "MyDoubtCell")
        view.addSubview(backBtn)
        view.addSubview(tableView)

        backBtn.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backBtn.widthAnchor.constraint(equalToConstant: 36),
            backBtn.heightAnchor.constraint(equalToConstant: 36),
            
            tableView.topAnchor.constraint(equalTo: backBtn.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func fetchMyDoubts() {
        let url = URL(string: "https://unarmored-dropper-blatantly.ngrok-free.dev/api/doubts/my-doubts")!
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Doubts Error:", error.localizedDescription)
                return
            }

            guard let data = data else { return }
            print("MY DOUBTS RAW:", String(data: data, encoding: .utf8) ?? "")

            do {
                let result = try JSONDecoder().decode(MyDoubtsResponse.self, from: data)
                DispatchQueue.main.async {
                    self.doubts = result.doubts
                    self.tableView.reloadData()
                }
            } catch {
                print("Decode Error:", error)
            }
        }.resume()
    }
}

extension MyDoubtsVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        doubts.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "MyDoubtCell",
            for: indexPath
        ) as! MyDoubtCell

        cell.configure(with: doubts[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
