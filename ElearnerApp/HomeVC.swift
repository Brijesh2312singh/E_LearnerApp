//
//  HomeVC.swift
//  ElearnerApp
//
//  Created by Coding Brains on 19/06/26.
//

import UIKit

class HomeVC: UIViewController {
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    @IBOutlet weak var bpscCollectionView: UICollectionView!
    @IBOutlet weak var pagecontroller: UIPageControl!
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var classesCollectionView: UICollectionView!
    @IBOutlet weak var sidemenu: UIButton!
    var topMenus: [TopMenu] = []
      var banners: [Banner] = []
      var sections: [HomeSection] = []
    var currentBannerIndex = 0
    var bannerTimer: Timer?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionViews()
        setupBpscLayout()
        homeAPI()
        setupBannerLayout()
        mainScrollView.contentInsetAdjustmentBehavior = .never
        mainScrollView.setContentOffset(.zero, animated: false)
    }
    
    func setupCollectionViews() {
            classesCollectionView.delegate = self
            classesCollectionView.dataSource = self

            bannerCollectionView.delegate = self
            bannerCollectionView.dataSource = self

            bpscCollectionView.delegate = self
            bpscCollectionView.dataSource = self
        }
    func setupBannerLayout() {
        if let layout = bannerCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
        }
    }
    func setupBpscLayout() {

        let layout = UICollectionViewFlowLayout()

        let spacing: CGFloat = 4

        let width = (bpscCollectionView.frame.width - spacing) / 2

        layout.itemSize = CGSize(width: width, height: 90)
        layout.minimumInteritemSpacing = spacing
        layout.minimumLineSpacing = spacing

        layout.sectionInset = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0
        )

        bpscCollectionView.collectionViewLayout = layout
    }
    func homeAPI() {
            let url = URL(string: "https://unarmored-dropper-blatantly.ngrok-free.dev/api/home")!

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

                do {
                    let result = try JSONDecoder().decode(HomeResponse.self, from: data)

                    DispatchQueue.main.async {
                        self.topMenus = result.data.topMenus
                        self.banners = result.data.banners
                        self.sections = result.data.sections

                        self.pagecontroller.numberOfPages = self.banners.count
                        self.pagecontroller.currentPage = 0

                        self.classesCollectionView.reloadData()
                        self.bannerCollectionView.reloadData()
                        self.bpscCollectionView.reloadData()

                        self.startBannerAutoScroll()
                    }

                } catch {
                    print("Decode Error:", error)
                    print(String(data: data, encoding: .utf8) ?? "")
                }

            }.resume()
        }

        func startBannerAutoScroll() {
            bannerTimer?.invalidate()

            bannerTimer = Timer.scheduledTimer(withTimeInterval: 3.0,
                                               repeats: true) { [weak self] _ in

                guard let self = self else { return }
                guard self.banners.count > 0 else { return }

                self.currentBannerIndex += 1

                if self.currentBannerIndex >= self.banners.count {
                    self.currentBannerIndex = 0
                }

                let indexPath = IndexPath(item: self.currentBannerIndex, section: 0)

                self.bannerCollectionView.scrollToItem(
                    at: indexPath,
                    at: .centeredHorizontally,
                    animated: true
                )

                self.pagecontroller.currentPage = self.currentBannerIndex
            }
        }

        deinit {
            bannerTimer?.invalidate()
        }
    }
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == classesCollectionView {
            return topMenus.count
        } else if collectionView == bannerCollectionView {
            return banners.count
        } else if collectionView == bpscCollectionView {
            return sections.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == classesCollectionView {
            
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "MyclassesCollectionViewCell",
                for: indexPath
            ) as! MyclassesCollectionViewCell
            
            let item = topMenus[indexPath.row]
            cell.classesLbl.text = item.title
            cell.classesicon.loadImage(from: item.icon)
            
            return cell
            
        } else if collectionView == bannerCollectionView {
            
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "BannerCollectionViewCell",
                for: indexPath
            ) as! BannerCollectionViewCell
            
            let item = banners[indexPath.row]
            cell.bannerImageView.loadImage(from: item.image)
            
            return cell
            
        } else if collectionView == bpscCollectionView {
            
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "BpscclassesCollectionViewCell",
                for: indexPath
            ) as! BpscclassesCollectionViewCell
            
            let item = sections[indexPath.row]
            
            cell.coursetitlename.numberOfLines = 0
            cell.coursetitlename.textAlignment = .center
            cell.coursetitlename.text = item.title == "BPSC-UPSC" ? "BPSC-UP\nSC" : item.title
            
            cell.bpscicon.loadImage(from: item.icon)
            cell.bpscView.backgroundColor = UIColor(hex: item.color)
            cell.bpscView.layer.cornerRadius = 10
            cell.bpscView.clipsToBounds = true
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if collectionView == classesCollectionView {

            let item = topMenus[indexPath.row]
            print("CLICKED:", item.title)

            if item.title == "My Courses" {
                let vc = storyboard?.instantiateViewController(withIdentifier: "MycoarsesVC") as! MycoarsesVC
                navigationController?.pushViewController(vc, animated: true)

            } else if item.title == "Live Classes" {
                let vc = storyboard?.instantiateViewController(withIdentifier: "LiveClassesVC") as! LiveClassesVC
                navigationController?.pushViewController(vc, animated: true)

            } else if item.title == "Live Tests" {
                let vc = storyboard?.instantiateViewController(withIdentifier: "LivetestVC") as! LivetestVC
                navigationController?.pushViewController(vc, animated: true)
                
            }
        }
        else if collectionView == bpscCollectionView {

                let item = sections[indexPath.row]

                print("CATEGORY CLICK:", item.title)

                let vc = BpscupscVC()

                switch item.title {

                case "BPSC-UPSC":
                    vc.categoryType = "bpsc_upsc"
                    vc.screenTitle = "BPSC-UPSC"

                case "TRE Course":
                    vc.categoryType = "tre_course"
                    vc.screenTitle = "TRE Course"

                case "Test Series Prelims":
                    vc.categoryType = "test_series_prelims"
                    vc.screenTitle = "Test Series Prelims"

                case "Test Series Mains":
                    vc.categoryType = "test_series_mains"
                    vc.screenTitle = "Test Series Mains"

                case "e-Book":
                    vc.categoryType = "ebooks"
                    vc.screenTitle = "e-Books"

                case "One Day Exams":
                    vc.categoryType = "one_day_exams"
                    vc.screenTitle = "One Day Exams"

                case "Current Affairs":
                    vc.categoryType = "current_affairs"
                    vc.screenTitle = "Current Affairs"

                case "Practice Set":
                    vc.categoryType = "practice_set"
                    vc.screenTitle = "Practice Set"

                default:
                    return
                }

                navigationController?.pushViewController(vc, animated: true)
            }
        }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == bpscCollectionView {
            
            
            let spacing: CGFloat = 4
            let width = (collectionView.frame.width - spacing) / 2
            
            return CGSize(width: width, height: 90)
        }
        
        
        if collectionView == bannerCollectionView {
            return CGSize(
                width: collectionView.frame.width,
                height: collectionView.frame.height
            )
        }
        
        if collectionView == classesCollectionView {
            return CGSize(
                width: collectionView.frame.width / 3,
                height: collectionView.frame.height
            )
        }
        
        return CGSize(width: 100, height: 100)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView == bannerCollectionView {
            let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
            
            currentBannerIndex = page
            pagecontroller.currentPage = page
        }
    }
}

extension UIColor {
    convenience init(hex: String) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexString = hexString.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgb)

        self.init(
            red: CGFloat((rgb >> 16) & 0xFF) / 255.0,
            green: CGFloat((rgb >> 8) & 0xFF) / 255.0,
            blue: CGFloat(rgb & 0xFF) / 255.0,
            alpha: 1
        )
    }
}

extension UIImageView {
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }

        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}
