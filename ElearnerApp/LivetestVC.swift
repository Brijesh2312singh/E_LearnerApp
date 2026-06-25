//
//  LivetestVC.swift
//  ElearnerApp
//
//  Created by Coding Brains on 23/06/26.
//

import UIKit
struct TestsResponse: Codable {
    let success: Bool
    let message: String
    let data: [TestModel]
}

struct TestModel: Codable {
    let id: Int
    let title: String
    let description: String
    let duration_minutes: Int
    let total_marks: Int
}
struct StartTestResponse: Codable {
    let success: Bool
    let message: String
    let attempt_id: Int
    let test_id: Int
    let duration_minutes: Int
}
struct RecentResultsResponse: Codable {
    let success: Bool
    let message: String
    let data: [RecentResultModel]
}

struct RecentResultModel: Codable {
    let attempt_id: Int
    let test_id: Int
    let title: String
    let image: String?
    let attempted_on: String?
    let score: String
    let rank: Int
    let total_students: Int
    let review_status: String
}

class LivetestVC: UIViewController {
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var resulttableviewhieght: NSLayoutConstraint!
    @IBOutlet weak var upcomingtableviewheight: NSLayoutConstraint!
    @IBOutlet weak var recentresultTableView: UITableView!
    @IBOutlet weak var upcomingtestTableView: UITableView!
    var tests: [TestModel] = []
    var recentResults: [RecentResultModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchRecentResults()
        setupTableViews()
        fetchTests()
    }
    
    func setupTableViews() {
        upcomingtestTableView.delegate = self
        upcomingtestTableView.dataSource = self
        upcomingtestTableView.separatorStyle = .none
        mainScrollView.contentInsetAdjustmentBehavior = .never
        mainScrollView.contentInset = .zero
        mainScrollView.scrollIndicatorInsets = .zero
        recentresultTableView.delegate = self
        recentresultTableView.dataSource = self
        recentresultTableView.separatorStyle = .none
        upcomingtestTableView.isScrollEnabled = false
        upcomingtestTableView.rowHeight = 160
        upcomingtestTableView.estimatedRowHeight = 160
        recentresultTableView.isScrollEnabled = false
        recentresultTableView.rowHeight = 200
        recentresultTableView.estimatedRowHeight = 200
    }
    func fetchRecentResults() {
        let url = URL(string: "https://unarmored-dropper-blatantly.ngrok-free.dev/api/tests/recent-results")!

        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                print("Recent Result API Error:", error.localizedDescription)
                return
            }

            guard let data = data else { return }

            print("RECENT RAW RESPONSE:", String(data: data, encoding: .utf8) ?? "")

            do {
                let result = try JSONDecoder().decode(RecentResultsResponse.self, from: data)

                DispatchQueue.main.async {
                    self.recentResults = result.data
                    self.recentresultTableView.reloadData()
                    self.updateRecentResultHeight()
                }

            } catch {
                print("Recent Decode Error:", error)
            }

        }.resume()
    }
    func updateRecentResultHeight() {
        let rowHeight: CGFloat = 200
        resulttableviewhieght.constant = CGFloat(recentResults.count) * rowHeight
        view.layoutIfNeeded()
    }
    func fetchTests() {
        let url = URL(string: "https://unarmored-dropper-blatantly.ngrok-free.dev/api/tests")!
        
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("API Error:", error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            print("RAW RESPONSE:", String(data: data, encoding: .utf8) ?? "")
            
            do {
                let result = try JSONDecoder().decode(TestsResponse.self, from: data)
                
                DispatchQueue.main.async {
                    self.tests = result.data
                    self.upcomingtestTableView.reloadData()

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        self.updateTableHeight()
                    }
                }
            } catch {
                print("Decode Error:", error)
            }
            
        }.resume()
    }
    func updateTableHeight() {
        upcomingtestTableView
        let rowHeight: CGFloat = 160
        upcomingtableviewheight.constant = CGFloat(tests.count) * rowHeight

        view.layoutIfNeeded()
    }
    @IBAction func viewallBtn(_ sender: UIButton) {
    }
    
    @IBAction func upcomingviewallBtn(_ sender: UIButton) {
    }
    @IBAction func backtapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func startTest(_ sender: UIButton) {
        let index = sender.tag
        let item = tests[index]
        
        startTestAPI(testId: item.id)
    }
    
    func startTestAPI(testId: Int) {
        let url = URL(string: "https://unarmored-dropper-blatantly.ngrok-free.dev/api/tests/start")!
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        
        let params: [String: Any] = [
            "test_id": testId
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: params)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                print("Start Test Error:", error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            print("START TEST RAW:", String(data: data, encoding: .utf8) ?? "")
            
            do {
                let result = try JSONDecoder().decode(StartTestResponse.self, from: data)
                
                DispatchQueue.main.async {
                    let vc = self.storyboard?.instantiateViewController(
                        withIdentifier: "TestDetailsVC"
                    ) as! TestDetailsVC
                    
                    vc.testId = result.test_id
                    vc.attemptId = result.attempt_id
                    vc.durationMinutes = result.duration_minutes
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            } catch {
                print("Start Test Decode Error:", error)
            }
            
        }.resume()
    }
}
func formatDate(_ dateString: String) -> String {
    let inputFormatter = ISO8601DateFormatter()

    if let date = inputFormatter.date(from: dateString) {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd MMM yyyy"
        return outputFormatter.string(from: date)
    }

    return dateString
}
extension LivetestVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        if tableView == upcomingtestTableView {
            return tests.count
        } else if tableView == recentresultTableView {
            return recentResults.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == upcomingtestTableView {
            
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "UpcomingtestTableViewCell",
                for: indexPath
            ) as! UpcomingtestTableViewCell
            
            let item = tests[indexPath.row]
            
            cell.selectionStyle = .none
            
            cell.booktesttitle.text = item.title
            cell.questionLbl.text = "\(item.total_marks) Questions"
            cell.timeLbl.text = "\(item.duration_minutes) Min"
            cell.upcompleteLbl.text = "Upcoming Test"
            
            cell.testView.layer.cornerRadius = 12
            cell.testView.clipsToBounds = true
            
            cell.bookView.layer.cornerRadius = 10
            cell.bookView.clipsToBounds = true
            
            cell.upcompleteView.layer.cornerRadius = 8
            cell.upcompleteView.clipsToBounds = true
            
            cell.starttestBtn.layer.cornerRadius = 8
            cell.starttestBtn.clipsToBounds = true
            
            cell.starttestBtn.tag = indexPath.row
            cell.starttestBtn.addTarget(
                self,
                action: #selector(startTest(_:)),
                for: .touchUpInside
            )
            
            return cell
        }else if tableView == recentresultTableView {
            
            let cell = recentresultTableView.dequeueReusableCell(
                withIdentifier: "RecentresultTableViewCell",
                for: indexPath
            ) as! RecentresultTableViewCell
            
            let item = recentResults[indexPath.row]
            
            cell.selectionStyle = .none
            cell.cupView.layer.cornerRadius = 12
            cell.cupView.clipsToBounds = true
            
            cell.resulttitleLbl.text = item.title
            cell.attempttimeLbl.text = "Attempted on \(formatDate(item.attempted_on ?? ""))"
            cell.marksLbl.text = item.score
            cell.rankLbl.text = "\(item.rank)/\(item.total_students)"
            
            if let image = item.image {
                cell.cupimageView.loadImage(from: image)
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == upcomingtestTableView {
            return 160
        } else if tableView == recentresultTableView {
            return 200
        }
        return 0
    }
}
