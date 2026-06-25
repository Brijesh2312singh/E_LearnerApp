import UIKit

struct ChangePasswordResponse: Codable {
    let success: Bool
    let message: String
}

final class ChangePasswordVC: UIViewController {

    private let oldPasswordTF = UITextField()
    private let newPasswordTF = UITextField()
    private let confirmPasswordTF = UITextField()
    private let updateBtn = UIButton(type: .system)
    private let backBtn = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }

    private func setupUI() {
        view.backgroundColor = UIColor(red: 1, green: 0.96, blue: 0.97, alpha: 1)

        backBtn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backBtn.tintColor = .black
        backBtn.backgroundColor = .white
        backBtn.layer.cornerRadius = 18
        backBtn.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backBtn)

        setupTextField(oldPasswordTF, placeholder: "Old Password")
        setupTextField(newPasswordTF, placeholder: "New Password")
        setupTextField(confirmPasswordTF, placeholder: "Confirm Password")

        updateBtn.setTitle("Update Password", for: .normal)
        updateBtn.backgroundColor = UIColor(red: 239/255, green: 35/255, blue: 84/255, alpha: 1)
        updateBtn.setTitleColor(.white, for: .normal)
        updateBtn.titleLabel?.font = .boldSystemFont(ofSize: 16)
        updateBtn.layer.cornerRadius = 14
        updateBtn.addTarget(self, action: #selector(updateTapped), for: .touchUpInside)

        [oldPasswordTF, newPasswordTF, confirmPasswordTF, updateBtn].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            backBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backBtn.widthAnchor.constraint(equalToConstant: 36),
            backBtn.heightAnchor.constraint(equalToConstant: 36),

            oldPasswordTF.topAnchor.constraint(equalTo: backBtn.bottomAnchor, constant: 30),
            oldPasswordTF.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            oldPasswordTF.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            oldPasswordTF.heightAnchor.constraint(equalToConstant: 54),

            newPasswordTF.topAnchor.constraint(equalTo: oldPasswordTF.bottomAnchor, constant: 18),
            newPasswordTF.leadingAnchor.constraint(equalTo: oldPasswordTF.leadingAnchor),
            newPasswordTF.trailingAnchor.constraint(equalTo: oldPasswordTF.trailingAnchor),
            newPasswordTF.heightAnchor.constraint(equalToConstant: 54),

            confirmPasswordTF.topAnchor.constraint(equalTo: newPasswordTF.bottomAnchor, constant: 18),
            confirmPasswordTF.leadingAnchor.constraint(equalTo: oldPasswordTF.leadingAnchor),
            confirmPasswordTF.trailingAnchor.constraint(equalTo: oldPasswordTF.trailingAnchor),
            confirmPasswordTF.heightAnchor.constraint(equalToConstant: 54),

            updateBtn.topAnchor.constraint(equalTo: confirmPasswordTF.bottomAnchor, constant: 32),
            updateBtn.leadingAnchor.constraint(equalTo: oldPasswordTF.leadingAnchor),
            updateBtn.trailingAnchor.constraint(equalTo: oldPasswordTF.trailingAnchor),
            updateBtn.heightAnchor.constraint(equalToConstant: 56)
        ])
    }

    private func setupTextField(_ tf: UITextField, placeholder: String) {
        tf.placeholder = placeholder
        tf.isSecureTextEntry = true
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 12
        tf.setLeftPaddingPoints(16)
    }

    @objc private func updateTapped() {
        let old = oldPasswordTF.text ?? ""
        let new = newPasswordTF.text ?? ""
        let confirm = confirmPasswordTF.text ?? ""

        if old.isEmpty || new.isEmpty || confirm.isEmpty {
            showAlert("Please fill all fields")
            return
        }

        if new != confirm {
            showAlert("New password and confirm password do not match")
            return
        }

        changePasswordAPI(oldPassword: old, newPassword: new)
    }

    private func changePasswordAPI(oldPassword: String, newPassword: String) {
        let url = URL(string: "https://unarmored-dropper-blatantly.ngrok-free.dev/api/user/change-password")!
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""

        let params: [String: Any] = [
            "old_password": oldPassword,
            "new_password": newPassword
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: params)

        updateBtn.isEnabled = false
        updateBtn.setTitle("Please wait...", for: .normal)

        URLSession.shared.dataTask(with: request) { data, response, error in

            DispatchQueue.main.async {
                self.updateBtn.isEnabled = true
                self.updateBtn.setTitle("Update Password", for: .normal)
            }

            if let error = error {
                DispatchQueue.main.async {
                    self.showAlert(error.localizedDescription)
                }
                return
            }

            guard let data = data else { return }

            print("CHANGE PASSWORD RAW:", String(data: data, encoding: .utf8) ?? "")

            do {
                let result = try JSONDecoder().decode(ChangePasswordResponse.self, from: data)

                DispatchQueue.main.async {
                    self.showAlert(result.message)

                    if result.success {
                        self.oldPasswordTF.text = ""
                        self.newPasswordTF.text = ""
                        self.confirmPasswordTF.text = ""
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

    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "E-Learner", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(
            frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height)
        )
        leftView = paddingView
        leftViewMode = .always
    }
}
