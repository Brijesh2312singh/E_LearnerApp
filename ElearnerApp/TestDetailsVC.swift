import UIKit

struct QuestionsResponse: Codable {
    let success: Bool
    let message: String
    let data: [QuestionModel]
}

struct QuestionModel: Codable {
    let id: Int
    let test_id: Int
    let question: String
    let option_a: String
    let option_b: String
    let option_c: String
    let option_d: String
    let marks: Int
}

struct SaveAnswerResponse: Codable {
    let success: Bool
    let message: String
}

struct SubmitTestResponse: Codable {
    let success: Bool
    let message: String
    let result: SubmitResult?
}

struct SubmitResult: Codable {
    let attempt_id: Int
    let review_status: String
}

final class TestDetailsVC: UIViewController {

    var testId: Int = 1
    var attemptId: Int = 1
    var durationMinutes: Int = 0
    private var questions: [QuestionModel] = []
    private var currentIndex = 0
    private var selectedAnswers: [Int: String] = [:]

    private let headerView = UIView()
    private let titleLbl = UILabel()
    private let timerLbl = UILabel()

    private let progressCard = UIView()
    private let questionNoLbl = UILabel()
    private let marksLbl = UILabel()
    private let progressView = UIProgressView(progressViewStyle: .default)

    private let questionCard = UIView()
    private let questionLbl = UILabel()

    private let optionA = UIButton(type: .system)
    private let optionB = UIButton(type: .system)
    private let optionC = UIButton(type: .system)
    private let optionD = UIButton(type: .system)

    private let saveBtn = UIButton(type: .system)
    private let previousBtn = UIButton(type: .system)
    private let nextBtn = UIButton(type: .system)

    private var selectedOption: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchQuestions()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.97, green: 0.96, blue: 1, alpha: 1)

        headerView.backgroundColor = UIColor(red: 1.0, green: 0.23, blue: 0.19, alpha: 1.0);        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)

        let backBtn = UIButton(type: .system)
        backBtn.setTitle("←", for: .normal)
        backBtn.titleLabel?.font = .boldSystemFont(ofSize: 28)
        backBtn.tintColor = .white
        backBtn.addTarget(self, action: #selector(backTapped), for: .touchUpInside)

        titleLbl.text = "BPSC Live Mock Test"
        titleLbl.textColor = .white
        titleLbl.font = .boldSystemFont(ofSize: 18)
        titleLbl.textAlignment = .center

        timerLbl.text = "59:45"
        timerLbl.textColor = .white
        timerLbl.font = .boldSystemFont(ofSize: 14)
        timerLbl.textAlignment = .center
        timerLbl.layer.borderWidth = 1
        timerLbl.layer.borderColor = UIColor.white.cgColor
        timerLbl.layer.cornerRadius = 8
        timerLbl.clipsToBounds = true

        [backBtn, titleLbl, timerLbl].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            headerView.addSubview($0)
        }

        progressCard.backgroundColor = .white
        progressCard.layer.cornerRadius = 14
        progressCard.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressCard)

        questionNoLbl.font = .systemFont(ofSize: 15, weight: .semibold)
        marksLbl.font = .systemFont(ofSize: 14)
        marksLbl.textAlignment = .right
        progressView.progressTintColor = UIColor(red: 0.38, green: 0.27, blue: 0.88, alpha: 1)

        [questionNoLbl, marksLbl, progressView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            progressCard.addSubview($0)
        }

        questionCard.backgroundColor = .white
        questionCard.layer.cornerRadius = 16
        questionCard.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(questionCard)

        questionLbl.font = .boldSystemFont(ofSize: 20)
        questionLbl.numberOfLines = 0
        questionLbl.translatesAutoresizingMaskIntoConstraints = false
        questionCard.addSubview(questionLbl)

        [optionA, optionB, optionC, optionD].enumerated().forEach { index, button in
            button.tag = index
            button.contentHorizontalAlignment = .left
            button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
            button.tintColor = .black
            button.backgroundColor = .white
            button.layer.cornerRadius = 12
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
            button.translatesAutoresizingMaskIntoConstraints = false
            button.addTarget(self, action: #selector(optionTapped(_:)), for: .touchUpInside)
            questionCard.addSubview(button)
        }

        previousBtn.setTitle("‹ Previous", for: .normal)
        saveBtn.setTitle("▣ Save Answer", for: .normal)
        nextBtn.setTitle("Next ›", for: .normal)

        [previousBtn, saveBtn, nextBtn].forEach {
            $0.layer.cornerRadius = 12
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(red: 0.38, green: 0.27, blue: 0.88, alpha: 1).cgColor
            $0.titleLabel?.font = .boldSystemFont(ofSize: 14)
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        nextBtn.backgroundColor = UIColor(red: 1.0, green: 0.23, blue: 0.19, alpha: 1.0)
        nextBtn.setTitleColor(.white, for: .normal)

        previousBtn.addTarget(self, action: #selector(previousTapped), for: .touchUpInside)
        nextBtn.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        saveBtn.addTarget(self, action: #selector(saveAnswerTapped), for: .touchUpInside)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 120),

            backBtn.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            backBtn.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -22),
            backBtn.widthAnchor.constraint(equalToConstant: 40),

            titleLbl.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLbl.centerYAnchor.constraint(equalTo: backBtn.centerYAnchor),

            timerLbl.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            timerLbl.centerYAnchor.constraint(equalTo: backBtn.centerYAnchor),
            timerLbl.widthAnchor.constraint(equalToConstant: 70),
            timerLbl.heightAnchor.constraint(equalToConstant: 36),

            progressCard.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
            progressCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            progressCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            progressCard.heightAnchor.constraint(equalToConstant: 95),

            questionNoLbl.topAnchor.constraint(equalTo: progressCard.topAnchor, constant: 16),
            questionNoLbl.leadingAnchor.constraint(equalTo: progressCard.leadingAnchor, constant: 16),

            marksLbl.topAnchor.constraint(equalTo: progressCard.topAnchor, constant: 16),
            marksLbl.trailingAnchor.constraint(equalTo: progressCard.trailingAnchor, constant: -16),

            progressView.leadingAnchor.constraint(equalTo: progressCard.leadingAnchor, constant: 16),
            progressView.trailingAnchor.constraint(equalTo: progressCard.trailingAnchor, constant: -16),
            progressView.bottomAnchor.constraint(equalTo: progressCard.bottomAnchor, constant: -22),

            questionCard.topAnchor.constraint(equalTo: progressCard.bottomAnchor, constant: 16),
            questionCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            questionCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            questionLbl.topAnchor.constraint(equalTo: questionCard.topAnchor, constant: 24),
            questionLbl.leadingAnchor.constraint(equalTo: questionCard.leadingAnchor, constant: 16),
            questionLbl.trailingAnchor.constraint(equalTo: questionCard.trailingAnchor, constant: -16),

            optionA.topAnchor.constraint(equalTo: questionLbl.bottomAnchor, constant: 28),
            optionB.topAnchor.constraint(equalTo: optionA.bottomAnchor, constant: 14),
            optionC.topAnchor.constraint(equalTo: optionB.bottomAnchor, constant: 14),
            optionD.topAnchor.constraint(equalTo: optionC.bottomAnchor, constant: 14),
            optionD.bottomAnchor.constraint(equalTo: questionCard.bottomAnchor, constant: -24)
        ])

        [optionA, optionB, optionC, optionD].forEach {
            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: questionCard.leadingAnchor, constant: 16),
                $0.trailingAnchor.constraint(equalTo: questionCard.trailingAnchor, constant: -16),
                $0.heightAnchor.constraint(equalToConstant: 58)
            ])
        }

        NSLayoutConstraint.activate([
            previousBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            previousBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            previousBtn.widthAnchor.constraint(equalToConstant: 105),
            previousBtn.heightAnchor.constraint(equalToConstant: 52),

            saveBtn.leadingAnchor.constraint(equalTo: previousBtn.trailingAnchor, constant: 10),
            saveBtn.bottomAnchor.constraint(equalTo: previousBtn.bottomAnchor),
            saveBtn.widthAnchor.constraint(equalToConstant: 120),
            saveBtn.heightAnchor.constraint(equalToConstant: 52),

            nextBtn.leadingAnchor.constraint(equalTo: saveBtn.trailingAnchor, constant: 10),
            nextBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nextBtn.bottomAnchor.constraint(equalTo: previousBtn.bottomAnchor),
            nextBtn.heightAnchor.constraint(equalToConstant: 52)
        ])
    }

    private func fetchQuestions() {
        let url = URL(string: "https://unarmored-dropper-blatantly.ngrok-free.dev/api/tests/\(testId)/questions")!
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("API Error:", error.localizedDescription)
                return
            }

            guard let data = data else { return }
            print(String(data: data, encoding: .utf8) ?? "")

            do {
                let result = try JSONDecoder().decode(QuestionsResponse.self, from: data)
                DispatchQueue.main.async {
                    self.questions = result.data
                    self.loadQuestion()
                }
            } catch {
                print("Decode Error:", error)
            }
        }.resume()
    }

    private func loadQuestion() {
        guard questions.indices.contains(currentIndex) else { return }

        let q = questions[currentIndex]
        selectedOption = selectedAnswers[q.id]

        questionNoLbl.text = "Question \(currentIndex + 1) of \(questions.count)"
        marksLbl.text = "\(q.marks) Marks"
        questionLbl.text = q.question

        optionA.setTitle("  A    \(q.option_a)", for: .normal)
        optionB.setTitle("  B    \(q.option_b)", for: .normal)
        optionC.setTitle("  C    \(q.option_c)", for: .normal)
        optionD.setTitle("  D    \(q.option_d)", for: .normal)

        progressView.progress = Float(currentIndex + 1) / Float(questions.count)

        nextBtn.setTitle(currentIndex == questions.count - 1 ? "Submit" : "Next ›", for: .normal)

        updateOptionUI()
    }

    @objc private func optionTapped(_ sender: UIButton) {
        let options = ["A", "B", "C", "D"]
        selectedOption = options[sender.tag]

        let questionId = questions[currentIndex].id
        selectedAnswers[questionId] = selectedOption

        updateOptionUI()
    }

    private func updateOptionUI() {
        let buttons = [optionA, optionB, optionC, optionD]
        let options = ["A", "B", "C", "D"]

        for (index, button) in buttons.enumerated() {
            if selectedOption == options[index] {
                button.layer.borderColor = UIColor(red: 0.38, green: 0.27, blue: 0.88, alpha: 1).cgColor
                button.backgroundColor = UIColor(red: 0.94, green: 0.91, blue: 1, alpha: 1)
            } else {
                button.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
                button.backgroundColor = .white
            }
        }
    }

    @objc private func saveAnswerTapped() {
        guard let selectedOption = selectedOption else {
            showAlert("Please select an option")
            return
        }

        let questionId = questions[currentIndex].id

        let url = URL(string: "https://unarmored-dropper-blatantly.ngrok-free.dev/api/tests/save-answer")!
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""

        let params: [String: Any] = [
            "attempt_id": attemptId,
            "question_id": questionId,
            "selected_option": selectedOption
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: params)

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let data = data else { return }
            print(String(data: data, encoding: .utf8) ?? "")

            DispatchQueue.main.async {
                self.showAlert("Answer saved successfully")
            }
        }.resume()
    }

    @objc private func previousTapped() {
        if currentIndex > 0 {
            currentIndex -= 1
            loadQuestion()
        }
    }

    @objc private func nextTapped() {
        if currentIndex == questions.count - 1 {
            submitTest()
        } else {
            currentIndex += 1
            loadQuestion()
        }
    }

    private func submitTest() {
        let url = URL(string: "https://unarmored-dropper-blatantly.ngrok-free.dev/api/tests/submit")!
        let token = UserDefaults.standard.string(forKey: "authToken") ?? ""

        let params: [String: Any] = [
            "attempt_id": attemptId
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: params)

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }

            guard let data = data else { return }
            print(String(data: data, encoding: .utf8) ?? "")

            do {
                let result = try JSONDecoder().decode(SubmitTestResponse.self, from: data)

                DispatchQueue.main.async {
                    self.showAlert(result.message)
                }

            } catch {
                print("Decode Error:", error)
            }
        }.resume()
    }

    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Elearner", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
}
