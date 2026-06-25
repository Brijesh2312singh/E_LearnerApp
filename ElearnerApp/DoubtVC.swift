import UIKit

class DoubtVC: UIViewController {

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private var selectedImage: UIImage?
    private let imagePicker = UIImagePickerController()
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Ask a Doubt"
        lbl.font = .boldSystemFont(ofSize: 24)
        return lbl
    }()

    private let subjectTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Select Subject"
        tf.borderStyle = .roundedRect
        return tf
    }()

    private let titleTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Doubt Title"
        tf.borderStyle = .roundedRect
        return tf
    }()

    private let descriptionTV: UITextView = {
        let tv = UITextView()
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.cornerRadius = 10
        tv.font = .systemFont(ofSize: 16)
        return tv
    }()

    private let uploadBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Upload Image", for: .normal)
        btn.backgroundColor = .systemGray6
        btn.layer.cornerRadius = 10
        return btn
    }()
    private let myDoubtsBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("My Doubts", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .systemBlue
        btn.layer.cornerRadius = 12
        return btn
    }()
    private let submitBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Submit Doubt", for: .normal)
        btn.backgroundColor = UIColor(red: 1, green: 0.16, blue: 0.35, alpha: 1)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 12
        return btn
    }()

    private let tableView = UITableView()

    let doubts = [
        ("History Question", "Pending"),
        ("Polity Question", "Answered"),
        ("Geography Question", "Pending")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        submitBtn.addTarget(self, action: #selector(submitDoubtTapped), for: .touchUpInside)
        imagePicker.delegate = self
        uploadBtn.addTarget(self, action: #selector(uploadTapped), for: .touchUpInside)
        title = "Doubts"
        view.backgroundColor = .white

        setupUI()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        myDoubtsBtn.addTarget(self, action: #selector(openMyDoubts), for: .touchUpInside)
    }
    @objc func openMyDoubts() {
        let vc = MyDoubtsVC()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func uploadTapped() {
        let alert = UIAlertController(title: "Upload Image", message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Camera", style: .default) { _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true)
            }
        })

        alert.addAction(UIAlertAction(title: "Gallery", style: .default) { _ in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true)
        })

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alert, animated: true)
    }
    @objc private func submitDoubtTapped() {
        let batch = "Batch 1"
        let subject = subjectTF.text ?? ""
        let title = titleTF.text ?? ""
        let message = descriptionTV.text ?? ""

        if subject.isEmpty || title.isEmpty || message.isEmpty {
            showAlert("Please fill all fields")
            return
        }

        submitDoubtAPI(
            batch: batch,
            subject: subject,
            title: title,
            message: message,
            image: selectedImage
        )
    }

    private func submitDoubtAPI(batch: String,
                                subject: String,
                                title: String,
                                message: String,
                                image: UIImage?) {

        let url = URL(string: "https://unarmored-dropper-blatantly.ngrok-free.dev/api/doubts/create")!
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""

        let boundary = "Boundary-\(UUID().uuidString)"

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        func addText(_ name: String, _ value: String) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }

        addText("batch", batch)
        addText("subject", subject)
        addText("title", title)
        addText("message", message)

        if let image = image,
           let imageData = image.jpegData(compressionQuality: 0.7) {

            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"image\"; filename=\"doubt.jpg\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body

        submitBtn.isEnabled = false

        URLSession.shared.dataTask(with: request) { data, response, error in

            DispatchQueue.main.async {
                self.submitBtn.isEnabled = true
            }

            if let error = error {
                DispatchQueue.main.async {
                    self.showAlert(error.localizedDescription)
                }
                return
            }

            guard let data = data else { return }

            print("DOUBT RAW:", String(data: data, encoding: .utf8) ?? "")

            DispatchQueue.main.async {
                self.showAlert("Doubt submitted successfully")
                self.subjectTF.text = ""
                self.titleTF.text = ""
                self.descriptionTV.text = ""
                self.selectedImage = nil
                self.uploadBtn.setTitle("Upload Image", for: .normal)
            }

        }.resume()
    }

    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "E-Learner", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    private func setupUI() {

        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        [titleLabel,
         subjectTF,
         titleTF,
         descriptionTV,
         uploadBtn,
         submitBtn,
         myDoubtsBtn,
         tableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            myDoubtsBtn.topAnchor.constraint(equalTo: submitBtn.bottomAnchor, constant: 15),
            myDoubtsBtn.leadingAnchor.constraint(equalTo: submitBtn.leadingAnchor),
            myDoubtsBtn.trailingAnchor.constraint(equalTo: submitBtn.trailingAnchor),
            myDoubtsBtn.heightAnchor.constraint(equalToConstant: 50),

            tableView.topAnchor.constraint(equalTo: myDoubtsBtn.bottomAnchor, constant: 20),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

            subjectTF.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            subjectTF.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            subjectTF.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            subjectTF.heightAnchor.constraint(equalToConstant: 50),

            titleTF.topAnchor.constraint(equalTo: subjectTF.bottomAnchor, constant: 15),
            titleTF.leadingAnchor.constraint(equalTo: subjectTF.leadingAnchor),
            titleTF.trailingAnchor.constraint(equalTo: subjectTF.trailingAnchor),
            titleTF.heightAnchor.constraint(equalToConstant: 50),

            descriptionTV.topAnchor.constraint(equalTo: titleTF.bottomAnchor, constant: 15),
            descriptionTV.leadingAnchor.constraint(equalTo: titleTF.leadingAnchor),
            descriptionTV.trailingAnchor.constraint(equalTo: titleTF.trailingAnchor),
            descriptionTV.heightAnchor.constraint(equalToConstant: 120),

            uploadBtn.topAnchor.constraint(equalTo: descriptionTV.bottomAnchor, constant: 15),
            uploadBtn.leadingAnchor.constraint(equalTo: titleTF.leadingAnchor),
            uploadBtn.trailingAnchor.constraint(equalTo: titleTF.trailingAnchor),
            uploadBtn.heightAnchor.constraint(equalToConstant: 50),

            submitBtn.topAnchor.constraint(equalTo: uploadBtn.bottomAnchor, constant: 20),
            submitBtn.leadingAnchor.constraint(equalTo: titleTF.leadingAnchor),
            submitBtn.trailingAnchor.constraint(equalTo: titleTF.trailingAnchor),
            submitBtn.heightAnchor.constraint(equalToConstant: 55),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 300),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
}
extension DoubtVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        if let image = info[.originalImage] as? UIImage {
            selectedImage = image
            uploadBtn.setTitle("Image Selected ✅", for: .normal)
        }

        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
extension DoubtVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        doubts.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
    -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
        )

        let item = doubts[indexPath.row]

        cell.textLabel?.text = "\(item.0) - \(item.1)"

        return cell
    }
}
