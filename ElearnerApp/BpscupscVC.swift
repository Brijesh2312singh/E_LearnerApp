//
//  BpscupscVC.swift
//  ElearnerApp
//
//  Created by Coding Brains on 23/06/26.
//

import UIKit
struct CategoryItemsResponse: Codable {
    let success: Bool
    let category_type: String
    let data: [CategoryItem]
}

struct CategoryItem: Codable {
    let id: Int
    let category_type: String
    let title: String
    let description: String?
    let price: String?
    let image: String?
    let pdf: String?
    let video: String?
    let status: Int
    let created_at: String?
}
class BpscupscVC: UIViewController {
    var categoryType: String = "bpsc_upsc"
        var screenTitle: String = "BPSC-UPSC"

        private var items: [CategoryItem] = []

        private let headerView = UIView()
        private let titleLbl = UILabel()
        private let backBtn = UIButton(type: .system)
        private let tableView = UITableView(frame: .zero, style: .plain)
    override func viewDidLoad() {
        super.viewDidLoad()

      
        setupUI()
               fetchCategoryItems()
           }

           private func setupUI() {
               view.backgroundColor = UIColor(red: 1.0, green: 0.96, blue: 0.97, alpha: 1)

               headerView.backgroundColor = UIColor(red: 239/255, green: 35/255, blue: 84/255, alpha: 1)
               headerView.translatesAutoresizingMaskIntoConstraints = false
               view.addSubview(headerView)

               backBtn.setTitle("‹", for: .normal)
               backBtn.titleLabel?.font = .systemFont(ofSize: 34, weight: .regular)
               backBtn.tintColor = .white
               backBtn.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
               backBtn.translatesAutoresizingMaskIntoConstraints = false
               headerView.addSubview(backBtn)

               titleLbl.text = screenTitle
               titleLbl.textColor = .white
               titleLbl.font = .boldSystemFont(ofSize: 18)
               titleLbl.textAlignment = .center
               titleLbl.translatesAutoresizingMaskIntoConstraints = false
               headerView.addSubview(titleLbl)

               tableView.backgroundColor = .clear
               tableView.separatorStyle = .none
               tableView.showsVerticalScrollIndicator = false
               tableView.dataSource = self
               tableView.delegate = self
               tableView.register(BpscupsTableViewCell.self, forCellReuseIdentifier: "BpscupsTableViewCell")
               tableView.translatesAutoresizingMaskIntoConstraints = false
               view.addSubview(tableView)

               NSLayoutConstraint.activate([
                   headerView.topAnchor.constraint(equalTo: view.topAnchor),
                   headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                   headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                   headerView.heightAnchor.constraint(equalToConstant: 115),

                   backBtn.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 14),
                   backBtn.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -18),
                   backBtn.widthAnchor.constraint(equalToConstant: 40),
                   backBtn.heightAnchor.constraint(equalToConstant: 40),

                   titleLbl.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
                   titleLbl.centerYAnchor.constraint(equalTo: backBtn.centerYAnchor),

                   tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 14),
                   tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 14),
                   tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -14),
                   tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
               ])
           }

           private func fetchCategoryItems() {
               let url = URL(string: "https://unarmored-dropper-blatantly.ngrok-free.dev/api/category-items/\(categoryType)")!

               let token = UserDefaults.standard.string(forKey: "authToken") ?? ""

               var request = URLRequest(url: url)
               request.httpMethod = "GET"
               request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
               request.setValue("application/json", forHTTPHeaderField: "Content-Type")

               URLSession.shared.dataTask(with: request) { data, _, error in

                   if let error = error {
                       print("API Error:", error.localizedDescription)
                       return
                   }

                   guard let data = data else { return }

                   print("RAW RESPONSE:", String(data: data, encoding: .utf8) ?? "")

                   do {
                       let result = try JSONDecoder().decode(CategoryItemsResponse.self, from: data)

                       DispatchQueue.main.async {
                           self.items = result.data
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

       extension BpscupscVC: UITableViewDataSource, UITableViewDelegate {

           func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int {
               return items.count
           }

           func tableView(_ tableView: UITableView,
                          heightForRowAt indexPath: IndexPath) -> CGFloat {
               return 150
           }

           func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {

               let cell = tableView.dequeueReusableCell(
                   withIdentifier: "BpscupsTableViewCell",
                   for: indexPath
               ) as! BpscupsTableViewCell

               cell.configure(with: items[indexPath.row])
               cell.onViewDetails = { [weak self] in
                   guard let self = self else { return }
                   let vc = CategoryItemDetailsVC()
                   vc.item = self.items[indexPath.row]
                   self.navigationController?.pushViewController(vc, animated: true)
               }
               return cell
           }

           func tableView(_ tableView: UITableView,
                          didSelectRowAt indexPath: IndexPath) {

//               let vc = CategoryItemDetailsVC()
//               vc.item = items[indexPath.row]
//               navigationController?.pushViewController(vc, animated: true)
           }
       }
