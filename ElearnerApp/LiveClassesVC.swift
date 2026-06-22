//
//  LiveClassesVC.swift
//  ElearnerApp
//
//  Created by Coding Brains on 22/06/26.
//

import UIKit
struct LiveClassesResponse: Codable {
    let success: Bool
    let message: String
    let todayLiveClasses: [LiveClass]
    let upcomingClasses: [LiveClass]
}

struct LiveClass: Codable {
    let id: Int
    let title: String
    let description: String?
    let teacher_name: String?
    let teacher_image: String?
    let icon: String?
    let icon_bg_color: String?
    let class_date: String?
    let start_time: String?
    let end_time: String?
    let live_link: String?
    let is_live: Int
}
class LiveClassesVC: UIViewController {

    @IBOutlet weak var upcomingclassestableView: UITableView!
    @IBOutlet weak var pagecontroller: UIPageControl!
    @IBOutlet weak var livebannerCollectionView: UICollectionView!
    @IBOutlet weak var tableHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var viewallBtn: UIButton!
    var todayLiveClasses: [LiveClass] = []
       var upcomingClasses: [LiveClass] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCollectionTable()
              liveClassesAPI()
          }

          func setupCollectionTable() {
              livebannerCollectionView.delegate = self
              livebannerCollectionView.dataSource = self
              livebannerCollectionView.isPagingEnabled = true
              livebannerCollectionView.showsHorizontalScrollIndicator = false
              mainScrollView.contentInsetAdjustmentBehavior = .never
              mainScrollView.contentInset = .zero
              mainScrollView.scrollIndicatorInsets = .zero
            

             
              if let layout = livebannerCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                  layout.scrollDirection = .horizontal
                  layout.minimumLineSpacing = 0
              }

              upcomingclassestableView.delegate = self
              upcomingclassestableView.dataSource = self
              upcomingclassestableView.separatorStyle = .none
              upcomingclassestableView.isScrollEnabled = false
              upcomingclassestableView.rowHeight = 140
              upcomingclassestableView.estimatedRowHeight = 140

          }

          func liveClassesAPI() {
              let url = URL(string: "https://unarmored-dropper-blatantly.ngrok-free.dev/api/live-classes")!
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
                      let result = try JSONDecoder().decode(LiveClassesResponse.self, from: data)

                      DispatchQueue.main.async {
                          self.todayLiveClasses = result.todayLiveClasses
                          self.upcomingClasses = result.upcomingClasses

                          self.pagecontroller.numberOfPages = self.todayLiveClasses.count
                          self.pagecontroller.currentPage = 0

                          self.livebannerCollectionView.reloadData()
                          self.upcomingclassestableView.reloadData()
                          self.updateTableHeight()
                      }

                  } catch {
                      print("Decode Error:", error)
                  }

              }.resume()
          }
    func updateTableHeight() {
        upcomingclassestableView.layoutIfNeeded()

        let rowHeight: CGFloat = 140
        tableHeightConstraint.constant = CGFloat(upcomingClasses.count) * rowHeight

        view.layoutIfNeeded()
    }
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

   
}
extension LiveClassesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return todayLiveClasses.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "LiveClassesCollectionViewCell",
            for: indexPath
        ) as! LiveClassesCollectionViewCell

        let item = todayLiveClasses[indexPath.row]

        cell.liveclassView.layer.cornerRadius = 16
        cell.videoView.layer.cornerRadius = 12
        cell.teacherImageView.layer.cornerRadius = cell.teacherImageView.frame.height / 2
        cell.teacherImageView.clipsToBounds = true
        cell.joinnowBtn.layer.cornerRadius = 10
        cell.liveBtn.layer.cornerRadius = 8

        cell.titleLbl.text = item.title
        cell.teachernameLbl.text = item.teacher_name ?? "Teacher"
        cell.timeLbl.text = "\(item.start_time ?? "") - \(item.end_time ?? "")"

        if let image = item.teacher_image {
            cell.teacherImageView.loadImage(from: image)
        }

        cell.joinnowBtn.tag = indexPath.row
        cell.joinnowBtn.addTarget(self, action: #selector(joinLiveClass(_:)), for: .touchUpInside)

        return cell
    }

    @objc func joinLiveClass(_ sender: UIButton) {
        let item = todayLiveClasses[sender.tag]

        if let link = item.live_link,
           let url = URL(string: link) {
            UIApplication.shared.open(url)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width,
                      height: collectionView.frame.height)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == livebannerCollectionView {
            let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
            pagecontroller.currentPage = page
        }
    }
}
extension LiveClassesVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return upcomingClasses.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "UpcomingclassesTableViewCell",
            for: indexPath
        ) as! UpcomingclassesTableViewCell

        let item = upcomingClasses[indexPath.row]

        cell.selectionStyle = .none
        cell.upcomingclassesView.layer.cornerRadius = 14
        cell.globleView.layer.cornerRadius = 12
        cell.globleView.backgroundColor = UIColor(hex: item.icon_bg_color ?? "#DBEAFE")

        cell.subjectLbl.text = item.title
        cell.teachernameLbl.text = item.teacher_name ?? "Teacher"
        cell.timeLbl.text = "\(item.start_time ?? "") - \(item.end_time ?? "")"

        if let image = item.teacher_image {
            cell.teacherImageView.loadImage(from: image)
        }

        if let icon = item.icon {
            cell.globleImageView.loadImage(from: icon)
        }

        cell.calenderBtn.tag = indexPath.row
        cell.calenderBtn.addTarget(self, action: #selector(openUpcomingClass(_:)), for: .touchUpInside)

        return cell
    }

    @objc func openUpcomingClass(_ sender: UIButton) {
        let item = upcomingClasses[sender.tag]

        if let link = item.live_link,
           let url = URL(string: link) {
            UIApplication.shared.open(url)
        }
    }

    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
