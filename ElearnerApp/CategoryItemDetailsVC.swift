import UIKit
import AVKit
import Razorpay

struct RazorpayOrderResponse: Codable {
    let success: Bool
    let message: String
    let key_id: String
    let payment_db_id: Int
    let razorpay_order: RazorpayOrder
}

struct RazorpayOrder: Codable {
    let id: String
    let amount: Int
    let currency: String
    let receipt: String
    let status: String
}

struct VerifyPaymentResponse: Codable {
    let success: Bool
    let message: String
}

final class CategoryItemDetailsVC: UIViewController, RazorpayPaymentCompletionProtocolWithData {

    var item: CategoryItem?

    private var razorpay: RazorpayCheckout?
    private var paymentDbId: Int = 0

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let headerView = UIView()
    private let backBtn = UIButton(type: .system)
    private let titleLbl = UILabel()

    private let courseImageView = UIImageView()
    private let nameLbl = UILabel()
    private let descriptionLbl = UILabel()
    private let priceLbl = UILabel()

    private let videoBtn = UIButton(type: .system)
    private let buyBtn = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setData()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(red: 1, green: 0.96, blue: 0.97, alpha: 1)

        headerView.backgroundColor = UIColor(red: 239/255, green: 35/255, blue: 84/255, alpha: 1)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)

        backBtn.setTitle("‹", for: .normal)
        backBtn.titleLabel?.font = .systemFont(ofSize: 34)
        backBtn.tintColor = .white
        backBtn.addTarget(self, action: #selector(backTapped), for: .touchUpInside)

        titleLbl.text = "Course Details"
        titleLbl.textColor = .white
        titleLbl.font = .boldSystemFont(ofSize: 18)
        titleLbl.textAlignment = .center

        [backBtn, titleLbl].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            headerView.addSubview($0)
        }

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)

        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)

        courseImageView.contentMode = .scaleAspectFill
        courseImageView.layer.cornerRadius = 18
        courseImageView.clipsToBounds = true
        courseImageView.backgroundColor = .lightGray

        nameLbl.font = .boldSystemFont(ofSize: 22)
        nameLbl.numberOfLines = 0

        descriptionLbl.font = .systemFont(ofSize: 15)
        descriptionLbl.textColor = .darkGray
        descriptionLbl.numberOfLines = 0

        priceLbl.font = .boldSystemFont(ofSize: 24)
        priceLbl.textColor = UIColor(red: 239/255, green: 35/255, blue: 84/255, alpha: 1)

        videoBtn.setTitle("▶ Watch Demo Video", for: .normal)
        videoBtn.backgroundColor = .white
        videoBtn.setTitleColor(UIColor(red: 239/255, green: 35/255, blue: 84/255, alpha: 1), for: .normal)
        videoBtn.titleLabel?.font = .boldSystemFont(ofSize: 15)
        videoBtn.layer.cornerRadius = 12
        videoBtn.layer.borderWidth = 1
        videoBtn.layer.borderColor = UIColor(red: 239/255, green: 35/255, blue: 84/255, alpha: 1).cgColor
        videoBtn.addTarget(self, action: #selector(videoTapped), for: .touchUpInside)

        buyBtn.setTitle("Buy Now", for: .normal)
        buyBtn.backgroundColor = UIColor(red: 239/255, green: 35/255, blue: 84/255, alpha: 1)
        buyBtn.setTitleColor(.white, for: .normal)
        buyBtn.titleLabel?.font = .boldSystemFont(ofSize: 17)
        buyBtn.layer.cornerRadius = 14
        buyBtn.addTarget(self, action: #selector(buyTapped), for: .touchUpInside)

        [courseImageView, nameLbl, descriptionLbl, priceLbl, videoBtn, buyBtn].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

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

            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            courseImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            courseImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            courseImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            courseImageView.heightAnchor.constraint(equalToConstant: 210),

            nameLbl.topAnchor.constraint(equalTo: courseImageView.bottomAnchor, constant: 18),
            nameLbl.leadingAnchor.constraint(equalTo: courseImageView.leadingAnchor),
            nameLbl.trailingAnchor.constraint(equalTo: courseImageView.trailingAnchor),

            priceLbl.topAnchor.constraint(equalTo: nameLbl.bottomAnchor, constant: 10),
            priceLbl.leadingAnchor.constraint(equalTo: courseImageView.leadingAnchor),

            descriptionLbl.topAnchor.constraint(equalTo: priceLbl.bottomAnchor, constant: 18),
            descriptionLbl.leadingAnchor.constraint(equalTo: courseImageView.leadingAnchor),
            descriptionLbl.trailingAnchor.constraint(equalTo: courseImageView.trailingAnchor),

            videoBtn.topAnchor.constraint(equalTo: descriptionLbl.bottomAnchor, constant: 24),
            videoBtn.leadingAnchor.constraint(equalTo: courseImageView.leadingAnchor),
            videoBtn.trailingAnchor.constraint(equalTo: courseImageView.trailingAnchor),
            videoBtn.heightAnchor.constraint(equalToConstant: 52),

            buyBtn.topAnchor.constraint(equalTo: videoBtn.bottomAnchor, constant: 16),
            buyBtn.leadingAnchor.constraint(equalTo: courseImageView.leadingAnchor),
            buyBtn.trailingAnchor.constraint(equalTo: courseImageView.trailingAnchor),
            buyBtn.heightAnchor.constraint(equalToConstant: 56),
            buyBtn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }

    private func setData() {
        guard let item = item else { return }

        nameLbl.text = item.title
        descriptionLbl.text = item.description
        priceLbl.text = "₹\(item.price ?? "0")"

        if let image = item.image {
            courseImageView.loadImage(from: image)
        }
    }

    @objc private func videoTapped() {
        guard let video = item?.video,
              let url = URL(string: video) else {
            showAlert("Video not available")
            return
        }

        let player = AVPlayer(url: url)
        let vc = AVPlayerViewController()
        vc.player = player

        present(vc, animated: true) {
            player.play()
        }
    }

    @objc private func buyTapped() {
        createRazorpayOrder()
    }

    private func createRazorpayOrder() {
        guard let item = item else { return }

        let url = URL(string: "https://unarmored-dropper-blatantly.ngrok-free.dev/api/payments/razorpay/create-order")!
        print("REQUEST URL ======>", url.absoluteString)

        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""
        let amount = Double(item.price ?? "0") ?? 0

        let params: [String: Any] = [
            "order_id": item.id,
            "amount": amount
        ]

        print("PARAMS ======>", params)

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: params)

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let http = response as? HTTPURLResponse {
                print("STATUS CODE ======>", http.statusCode)
            }

            if let error = error {
                print("Create Order Error:", error.localizedDescription)
                return
            }

            guard let data = data else { return }

            let raw = String(data: data, encoding: .utf8) ?? ""
            print("ORDER RAW:", raw)

            guard raw.trimmingCharacters(in: .whitespacesAndNewlines).first == "{" else {
                DispatchQueue.main.async {
                    self.showAlert("Wrong API URL. JSON nahi aa raha.")
                }
                return
            }

            do {
                let result = try JSONDecoder().decode(RazorpayOrderResponse.self, from: data)

                DispatchQueue.main.async {
                    self.paymentDbId = result.payment_db_id
                    self.openRazorpay(order: result)
                }

            } catch {
                print("Order Decode Error:", error)
            }

        }.resume()
    }

    private func openRazorpay(order: RazorpayOrderResponse) {
        razorpay = RazorpayCheckout.initWithKey(order.key_id, andDelegateWithData: self)

        let options: [String: Any] = [
            "key": order.key_id,
            "amount": order.razorpay_order.amount,
            "currency": order.razorpay_order.currency,
            "name": "E-Learner",
            "description": item?.title ?? "Course Purchase",
            "order_id": order.razorpay_order.id,
            "prefill": [
                "contact": "9999999999",
                "email": "test@gmail.com"
            ],
            "theme": [
                "color": "#EF2354"
            ]
        ]

        razorpay?.open(options)
    }

    func onPaymentSuccess(_ payment_id: String,
                          andData response: [AnyHashable : Any]?) {

        guard let response = response else { return }

        let razorpayOrderId =
            response["razorpay_order_id"] as? String ?? ""

        let razorpaySignature =
            response["razorpay_signature"] as? String ?? ""

        verifyPayment(
            razorpayOrderId: razorpayOrderId,
            razorpayPaymentId: payment_id,
            razorpaySignature: razorpaySignature
        )
    }

    func onPaymentError(_ code: Int32,
                        description str: String,
                        andData response: [AnyHashable : Any]?) {

        print("PAYMENT FAILED:", str)
        print("FAILED RESPONSE:", response ?? [:])

        showAlert("Payment failed")
    }

    func verifyPayment(
        razorpayOrderId: String,
        razorpayPaymentId: String,
        razorpaySignature: String
    ) {

        let url = URL(
            string: "https://unarmored-dropper-blatantly.ngrok-free.dev/api/payments/razorpay/verify"
        )!
        print("REQUEST URL ======>", url.absoluteString)
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""

        let params: [String: Any] = [
                "razorpay_order_id": razorpayOrderId,
                "razorpay_payment_id": razorpayPaymentId,
                "razorpay_signature": razorpaySignature,
                "order_id": item?.id ?? 0,
                "amount": Double(item?.price ?? "0") ?? 0
            ]
        print("PARAMS ======>", params)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: params)

        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                print("Verify Error:", error.localizedDescription)
                DispatchQueue.main.async {
                    self.showAlert(error.localizedDescription)
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.showAlert("No verify data found")
                }
                return
            }

            print("VERIFY RAW:", String(data: data, encoding: .utf8) ?? "")

            do {
                let result = try JSONDecoder().decode(VerifyPaymentResponse.self, from: data)

                DispatchQueue.main.async {
                    if result.success {
                        self.showSuccessAndGoMyCourses(result.message)
                    } else {
                        self.showAlert(result.message)
                    }
                }

            } catch {
                print("Verify Decode Error:", error)
                DispatchQueue.main.async {
                    self.showAlert("Verify decode error")
                }
            }

        }.resume()
    }

    private func showSuccessAndGoMyCourses(_ message: String) {
        let alert = UIAlertController(
            title: "E-Learner",
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "MycoarsesVC") as! MycoarsesVC
            self.navigationController?.pushViewController(vc, animated: true)
        })

        present(alert, animated: true)
    }
    private func showAlert(_ message: String) {
        let alert = UIAlertController(
            title: "E-Learner",
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
}
