import UIKit
import WebKit

final class CourseVideoVC: UIViewController {

    var videoURL: String = ""

    private let webView = WKWebView()
    private let backBtn = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadVideo()
    }

    private func setupUI() {
        view.backgroundColor = .black

        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)

        backBtn.setTitle("✕", for: .normal)
        backBtn.tintColor = .white
        backBtn.titleLabel?.font = .boldSystemFont(ofSize: 24)
        backBtn.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        backBtn.layer.cornerRadius = 18
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        backBtn.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        view.addSubview(backBtn)

        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            backBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            backBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backBtn.widthAnchor.constraint(equalToConstant: 36),
            backBtn.heightAnchor.constraint(equalToConstant: 36)
        ])
    }

    private func loadVideo() {
        guard let url = URL(string: videoURL) else { return }
        webView.load(URLRequest(url: url))
    }

    @objc private func backTapped() {
        dismiss(animated: true)
    }
}
