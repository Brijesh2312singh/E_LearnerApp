

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var eyeBtn: UIButton!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var emailView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
//   UserDefaults.standard.removeObject(forKey: "authToken")
        emailView.applyStyle(
                cornerRadius: 10,
                borderWidth: 1,
                borderColor: .lightGray
            )

            passwordView.applyStyle(
                cornerRadius: 10,
                borderWidth: 1,
                borderColor: .lightGray
            )
        loginBtn.applyStyle(cornerRadius: 10)

            passwordTF.isSecureTextEntry = true

            eyeBtn.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        checkLogin()
        
    }
    func checkLogin() {
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""

        if !token.isEmpty {
            DispatchQueue.main.async {
                let vc = CustomTabBarVC()

                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen

                self.present(nav, animated: true)
            }
        }
    }
    @IBAction func eyetapped(_ sender: UIButton) {
        passwordTF.isSecureTextEntry.toggle()

            let imageName = passwordTF.isSecureTextEntry
                ? "eye.slash"
                : "eye"

            sender.setImage(
                UIImage(systemName: imageName),
                for: .normal
            )
    }
    
    @IBAction func forgotpasswordTapped(_ sender: UIButton) {
    }
    
    @IBAction func signupTapped(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "SignupVC") as! SignupVC

            navigationController?.pushViewController(vc, animated: true)
                return
            
    }
    @IBAction func loginTapped(_ sender: UIButton) {
        let email = emailTF.text ?? ""
                let password = passwordTF.text ?? ""

                if email.isEmpty || password.isEmpty {
                    showAlert(message: "Please enter email and password")
                    return
                }

                loginAPI(email: email, password: password)
            }

            func loginAPI(email: String, password: String) {

                let url = URL(string: "https://unarmored-dropper-blatantly.ngrok-free.dev/api/auth/login")!

                let params: [String: Any] = [
                    "email": email,
                    "password": password
                ]

                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = try? JSONSerialization.data(withJSONObject: params)

                loginBtn.isEnabled = false

                URLSession.shared.dataTask(with: request) { data, response,
                    error in

                    DispatchQueue.main.async {
                        self.loginBtn.isEnabled = true
                    }

                    if let error = error {
                        print("❌ API ERROR:", error.localizedDescription)
                        DispatchQueue.main.async {
                            self.showAlert(message: error.localizedDescription)
                        }
                        return
                    }

                    guard let data = data else {
                        print("❌ NO DATA")
                        DispatchQueue.main.async {
                            self.showAlert(message: "No data found")
                        }
                        return
                    }
                    print("📡 Status Code:", (response as? HTTPURLResponse)?.statusCode ?? 0)

                            print("✅ RAW RESPONSE:")
                            print(String(data: data, encoding: .utf8) ?? "Unable to print response")
                    do {
                        let result = try JSONDecoder().decode(LoginResponse.self, from: data)
                        print("✅ Success:", result.success)
                                    print("✅ Message:", result.message)
                                    print("✅ Token:", result.token ?? "No Token")
                        DispatchQueue.main.async {
                            if result.success {

                                UserDefaults.standard.set(result.token ?? "", forKey: "authToken")
                                print("NEW TOKEN SAVED:", result.token ?? "")
                                let vc = CustomTabBarVC()

                                let nav = UINavigationController(rootViewController: vc)
                                nav.modalPresentationStyle = .fullScreen

                                self.present(nav, animated: true)

                            } else {
                                self.showAlert(message: result.message)
                            }
                        
                        }

                    } catch {
                        print("❌ Decode Error:", error.localizedDescription)
                        DispatchQueue.main.async {
                            self.showAlert(message: "Decode error")
                        }
                    }

                }.resume()
            }

            func showAlert(message: String) {
                let alert = UIAlertController(
                    title: "Elearner",
                    message: message,
                    preferredStyle: .alert
                )

                alert.addAction(UIAlertAction(title: "OK", style: .default))
                present(alert, animated: true)
            }
        }
