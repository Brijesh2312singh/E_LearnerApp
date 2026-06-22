//
//  SignupVC.swift
//  ElearnerApp
//
//  Created by Coding Brains on 19/06/26.
//

import UIKit

class SignupVC: UIViewController {

    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var phonenumberTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var eyeBtn: UIButton!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var phonenumberView: UIView!
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var nameView: UIView!
    @IBOutlet weak var signupBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailView.applyStyle(
            cornerRadius: 10,
            borderWidth: 1,
            borderColor: .lightGray
        )
        nameView.applyStyle(
            cornerRadius: 10,
            borderWidth: 1,
            borderColor: .lightGray
        )
        phonenumberView.applyStyle(
            cornerRadius: 10,
            borderWidth: 1,
            borderColor: .lightGray
        )
        passwordView.applyStyle(
            cornerRadius: 10,
            borderWidth: 1,
            borderColor: .lightGray
        )
        signupBtn.applyStyle(cornerRadius: 10)
        passwordTF.isSecureTextEntry = true

        eyeBtn.setImage(UIImage(systemName: "eye.slash"), for: .normal)
       
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
    @IBAction func signupTapped(_ sender: UIButton) {
        let name = nameTF.text ?? ""
                let email = emailTF.text ?? ""
                let phone = phonenumberTF.text ?? ""
                let password = passwordTF.text ?? ""
                
                if name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty {
                    showAlert(message: "Please fill all fields")
                    return
                }
                
                signupAPI(
                    name: name,
                    email: email,
                    phone: phone,
                    password: password
                )
            }
            
            func signupAPI(name: String, email: String, phone: String, password: String) {
                
                let url = URL(string: "https://unarmored-dropper-blatantly.ngrok-free.dev/api/auth/signup")!
                
                let params: [String: Any] = [
                    "name": name,
                    "email": email,
                    "phone": phone,
                    "password": password
                ]
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = try? JSONSerialization.data(withJSONObject: params)
                
                signupBtn.isEnabled = false
                
                URLSession.shared.dataTask(with: request) { data, response, error in
                    
                    DispatchQueue.main.async {
                        self.signupBtn.isEnabled = true
                    }
                    
                    if let error = error {
                        DispatchQueue.main.async {
                            self.showAlert(message: error.localizedDescription)
                        }
                        return
                    }
                    
                    guard let data = data else {
                        DispatchQueue.main.async {
                            self.showAlert(message: "No data found")
                        }
                        return
                    }
                    
                    do {
                        let result = try JSONDecoder().decode(SignupResponse.self, from: data)
                        
                        DispatchQueue.main.async {
                            if result.success {
                                self.showAlert(message: result.message)
                                
                                let vc = UIStoryboard(name: "Main", bundle: nil)
                                    .instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
                                
                                self.navigationController?.pushViewController(vc, animated: true)
                            } else {
                                self.showAlert(message: result.message)
                            }
                        }
                        
                    } catch {
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

    @IBAction func loginTapped(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "LoginVC") as! LoginVC

            navigationController?.pushViewController(vc, animated: true)
                return
        
    }
}
