import UIKit

struct UpdateProfileResponse: Codable {
    let success: Bool
    let message: String
}

final class MyProfileVC: UIViewController {

    private let backBtn = UIButton(type: .system)
    private let headerView = UIView()
    private let profileImageView = UIImageView()

    private let nameTF = UITextField()
    private let phoneTF = UITextField()
    private let stateTF = UITextField()
    private let districtTF = UITextField()
    private let imageTF = UITextField()

    private let updateBtn = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(red: 1, green: 0.96, blue: 0.97, alpha: 1)

        backBtn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backBtn.tintColor = .black
        backBtn.backgroundColor = .white
        backBtn.layer.cornerRadius = 18
        backBtn.addTarget(self, action: #selector(backTapped), for: .touchUpInside)

        headerView.backgroundColor = UIColor(red: 239/255, green: 35/255, blue: 84/255, alpha: 1)
        headerView.layer.cornerRadius = 24
        headerView.clipsToBounds = true

        profileImageView.image = UIImage(systemName: "person.circle.fill")
        profileImageView.tintColor = .white
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 45

        setupTextField(nameTF, placeholder: "Name")
        setupTextField(phoneTF, placeholder: "Phone")
        setupTextField(stateTF, placeholder: "State")
        setupTextField(districtTF, placeholder: "District")
        setupTextField(imageTF, placeholder: "Profile Image URL")

        nameTF.text = "Brijesh Singh"
        phoneTF.text = "9999999999"
        stateTF.text = "Uttar Pradesh"
        districtTF.text = "Lucknow"
        imageTF.text = "https://picsum.photos/300/300"

        updateBtn.setTitle("Update Profile", for: .normal)
        updateBtn.backgroundColor = UIColor(red: 239/255, green: 35/255, blue: 84/255, alpha: 1)
        updateBtn.setTitleColor(.white, for: .normal)
        updateBtn.titleLabel?.font = .boldSystemFont(ofSize: 16)
        updateBtn.layer.cornerRadius = 14
        updateBtn.addTarget(self, action: #selector(updateTapped), for: .touchUpInside)

        [backBtn, headerView, nameTF, phoneTF, stateTF, districtTF, imageTF, updateBtn].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(profileImageView)

        NSLayoutConstraint.activate([
            backBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backBtn.widthAnchor.constraint(equalToConstant: 36),
            backBtn.heightAnchor.constraint(equalToConstant: 36),

            headerView.topAnchor.constraint(equalTo: backBtn.bottomAnchor, constant: 20),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            headerView.heightAnchor.constraint(equalToConstant: 130),

            profileImageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 90),
            profileImageView.heightAnchor.constraint(equalToConstant: 90),

            nameTF.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 24),
            nameTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            nameTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            nameTF.heightAnchor.constraint(equalToConstant: 52),

            phoneTF.topAnchor.constraint(equalTo: nameTF.bottomAnchor, constant: 14),
            phoneTF.leadingAnchor.constraint(equalTo: nameTF.leadingAnchor),
            phoneTF.trailingAnchor.constraint(equalTo: nameTF.trailingAnchor),
            phoneTF.heightAnchor.constraint(equalToConstant: 52),

            stateTF.topAnchor.constraint(equalTo: phoneTF.bottomAnchor, constant: 14),
            stateTF.leadingAnchor.constraint(equalTo: nameTF.leadingAnchor),
            stateTF.trailingAnchor.constraint(equalTo: nameTF.trailingAnchor),
            stateTF.heightAnchor.constraint(equalToConstant: 52),

            districtTF.topAnchor.constraint(equalTo: stateTF.bottomAnchor, constant: 14),
            districtTF.leadingAnchor.constraint(equalTo: nameTF.leadingAnchor),
            districtTF.trailingAnchor.constraint(equalTo: nameTF.trailingAnchor),
            districtTF.heightAnchor.constraint(equalToConstant: 52),

            imageTF.topAnchor.constraint(equalTo: districtTF.bottomAnchor, constant: 14),
            imageTF.leadingAnchor.constraint(equalTo: nameTF.leadingAnchor),
            imageTF.trailingAnchor.constraint(equalTo: nameTF.trailingAnchor),
            imageTF.heightAnchor.constraint(equalToConstant: 52),

            updateBtn.topAnchor.constraint(equalTo: imageTF.bottomAnchor, constant: 28),
            updateBtn.leadingAnchor.constraint(equalTo: nameTF.leadingAnchor),
            updateBtn.trailingAnchor.constraint(equalTo: nameTF.trailingAnchor),
            updateBtn.heightAnchor.constraint(equalToConstant: 56)
        ])
    }

    private func setupTextField(_ tf: UITextField, placeholder: String) {
        tf.placeholder = placeholder
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 12
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 52))
        tf.leftViewMode = .always
    }

    @objc private func updateTapped() {
        let name = nameTF.text ?? ""
        let phone = phoneTF.text ?? ""
        let state = stateTF.text ?? ""
        let district = districtTF.text ?? ""
        let profileImage = imageTF.text ?? ""

        if name.isEmpty || phone.isEmpty {
            showAlert("Name and phone are required")
            return
        }

        updateProfileAPI(
            name: name,
            phone: phone,
            state: state,
            district: district,
            profileImage: profileImage
        )
    }

    private func updateProfileAPI(name: String,
                                  phone: String,
                                  state: String,
                                  district: String,
                                  profileImage: String) {

        let url = URL(string: "https://unarmored-dropper-blatantly.ngrok-free.dev/api/user/profile/update")!
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""

        let params: [String: Any] = [
            "name": name,
            "phone": phone,
            "state": state,
            "district": district,
            "profile_image": profileImage
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: params)

        updateBtn.isEnabled = false
        updateBtn.setTitle("Updating...", for: .normal)

        URLSession.shared.dataTask(with: request) { data, _, error in

            DispatchQueue.main.async {
                self.updateBtn.isEnabled = true
                self.updateBtn.setTitle("Update Profile", for: .normal)
            }

            if let error = error {
                DispatchQueue.main.async {
                    self.showAlert(error.localizedDescription)
                }
                return
            }

            guard let data = data else { return }

            print("UPDATE PROFILE RAW:", String(data: data, encoding: .utf8) ?? "")

            do {
                let result = try JSONDecoder().decode(UpdateProfileResponse.self, from: data)

                DispatchQueue.main.async {
                    self.showAlert(result.message)
                    if let url = URL(string: profileImage) {
                        self.loadImage(url: url)
                    }
                }

            } catch {
                DispatchQueue.main.async {
                    self.showAlert("Something went wrong")
                }
                print("Decode Error:", error)
            }

        }.resume()
    }

    private func loadImage(url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data {
                DispatchQueue.main.async {
                    self.profileImageView.image = UIImage(data: data)
                }
            }
        }.resume()
    }

    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }

    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "E-Learner", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
