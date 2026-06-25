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
    let banner: MyCourseBanner?
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
struct MyCourseBanner: Codable {
    let title: String?
    let subtitle: String?
    let image: String?
    let color: String?
    let progress: Int?
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
    var banner: MyCourseBanner?
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
                       self.banner = result.banner
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
           let rowHeight: CGFloat = 120
           tableHeightConstraint.constant = CGFloat(courses.count) * rowHeight
           view.layoutIfNeeded()
       }
    @IBAction func backBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    


}
extension MycoarsesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = continueCourseCollectionView.dequeueReusableCell(withReuseIdentifier: "ContinueCourseCollectionViewCell", for: indexPath) as! ContinueCourseCollectionViewCell
        
            return cell
        }
        
    
        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            return CGSize(
                width: continueCourseCollectionView.frame.width,
                height: continueCourseCollectionView.frame.height
            )
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
        cell.upscLbl.text = item.short_title_1 ?? "COURSE"
        cell.prelimsLbl.text = item.short_title_2 ?? "ONLINE"
        cell.yearLbl.text = item.short_title_3 ?? "2026"

        return cell
    }
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        let item = courses[indexPath.row]

        let vc = PurchasedCourseDetailsVC()
        vc.course = item

        navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
