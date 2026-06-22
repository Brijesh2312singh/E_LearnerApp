//
//  MycoarsesVC.swift
//  ElearnerApp
//
//  Created by Coding Brains on 22/06/26.
//

import UIKit
struct MyCoursesResponse: Codable {
    let success: Bool
    let message: String
    let continueCourse: MyCourse?
    let courses: [MyCourse]
}

struct MyCourse: Codable {
    let id: Int
    let title: String
    let description: String?
    let image: String?
    let video: String?
    let validity: String?
    let price: String?
    let progress: Int
    let color: String?
    let short_title_1: String?
    let short_title_2: String?
    let short_title_3: String?
}

class MycoarsesVC: UIViewController {

    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var purchesedcoursesTableView: UITableView!
    @IBOutlet weak var continueCourseCollectionView: UICollectionView!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var searchView: UIView!
    var continueCourse: MyCourse?
        var courses: [MyCourse] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
              setupTableCollection()
              myCoursesAPI()
          }

          func setupUI() {
              searchView.layer.cornerRadius = 12
              searchView.clipsToBounds = true

              mainScrollView.contentInsetAdjustmentBehavior = .never
              mainScrollView.contentInset = .zero
              mainScrollView.scrollIndicatorInsets = .zero
          }

          func setupTableCollection() {
              continueCourseCollectionView.delegate = self
              continueCourseCollectionView.dataSource = self

              purchesedcoursesTableView.delegate = self
              purchesedcoursesTableView.dataSource = self
              purchesedcoursesTableView.separatorStyle = .none

              purchesedcoursesTableView.isScrollEnabled = false
              purchesedcoursesTableView.rowHeight = 120
              purchesedcoursesTableView.estimatedRowHeight = 120
          }

          func myCoursesAPI() {
              let url = URL(string: "https://unarmored-dropper-blatantly.ngrok-free.dev/api/my-courses")!

              let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
              print("SAVED TOKEN:", token)

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
                      let result = try JSONDecoder().decode(MyCoursesResponse.self, from: data)

                      DispatchQueue.main.async {
                          self.continueCourse = result.continueCourse
                          self.courses = result.courses

                          self.continueCourseCollectionView.reloadData()
                          self.purchesedcoursesTableView.reloadData()

                          self.updateTableHeight()
                      }

                  } catch {
                      print("Decode Error:", error)
                  }

              }.resume()
          }

    func updateTableHeight() {
        purchesedcoursesTableView.layoutIfNeeded()

        let rowHeight: CGFloat = 120
        tableHeightConstraint.constant = CGFloat(courses.count) * rowHeight

        view.layoutIfNeeded()
    }
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    


}
extension MycoarsesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return continueCourse == nil ? 0 : 1
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "ContinueCourseCollectionViewCell",
            for: indexPath
        ) as! ContinueCourseCollectionViewCell

        guard let item = continueCourse else {
            return cell
        }

        cell.continuecoursesView.layer.cornerRadius = 12
        cell.foundationView.layer.cornerRadius = 8

        cell.batchyearLbl.text = item.title
        cell.percentageLbl.text = "\(item.progress)%"
        cell.progressbar.progress = Float(item.progress) / 100.0

        cell.bpscLbl.text = "BPSC"
        cell.foundationLbl.text = "FOUNDATION"
        cell.yearLbl.text = "BATCH 2026"

        if let image = item.image {
            cell.bookImageView.loadImage(from: image)
        }

        cell.resumecourseBtn.layer.cornerRadius = 8

        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: collectionView.frame.width,
                      height: collectionView.frame.height)
    }
}

extension MycoarsesVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "PurchasedCoursesTableViewCell",
            for: indexPath
        ) as! PurchasedCoursesTableViewCell

        let item = courses[indexPath.row]

        cell.selectionStyle = .none
        cell.coursesView.layer.cornerRadius = 12
        cell.upscprelmsView.layer.cornerRadius = 8

        cell.upscprelimsyearLbl.text = item.title
        cell.dateLbl.text = "Validity: \(item.validity ?? "")"
        cell.upscprelmsView.backgroundColor = UIColor(hex: item.color ?? "#3B82F6")
        cell.upscLbl.text = item.short_title_1 ?? ""
        cell.prelimsLbl.text = item.short_title_2 ?? ""
        cell.yearLbl.text = item.short_title_3 ?? ""

        return cell
    }

    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
