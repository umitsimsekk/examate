//
//  AnswerViewController.swift
//  ExamMate1
//
//  Created by Ümit Şimşek on 26.11.2023.
//

import UIKit

class AnswerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let answers = ["A","B","C","D","E","Bilinmiyor"]
    private let answerTableView : UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(answerTableView)
        // Do any additional setup after loading the view.
        title = "Doğru cevap"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        setTableViewDelegates()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.answerTableView.frame = view.bounds
    }
    func setTableViewDelegates() {
        self.answerTableView.delegate = self
        self.answerTableView.dataSource = self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        answers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = answers[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let answerDataDict:[String: String] = ["answer": answers[indexPath.row]]
        NotificationCenter.default.post(name: NSNotification.Name("notificationAnswer"), object: nil,userInfo: answerDataDict)
        dismiss(animated: true)

    }

}
