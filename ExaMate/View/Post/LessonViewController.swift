//
//  LessonViewController.swift
//  ExamMate1
//
//  Created by Ümit Şimşek on 26.11.2023.
//

import UIKit

class LessonViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    
    let lessons = [
        "TYT Türkçe","TYT Matematik","TYT Sosyal Bilimleri","TYT Fen Bilimleri",
        "AYT Matematik","AYT Geometri","AYT Fizik", "AYT Kimya", "AYT Biyoloji", "AYT Matematik","AYT Edebiyat","AYT Tarih-1",
        "AYT Coğrafya-1","AYT Tarih-2","AYT Coğrafya-2","AYT Felsefe", "AYT Din",
        "YDT İngilizce","YDT Almanca", "YDT Fransızca", "YDT Arapça", "YDT Rusça",
    ]
    private let lessonTableView : UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(lessonTableView)
        // Do any additional setup after loading the view.
        setTableViewDelegates()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.lessonTableView.frame = view.bounds
    }
    
    func setTableViewDelegates() {
        self.lessonTableView.dataSource = self
        self.lessonTableView.delegate = self
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        lessons.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = lessons[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let lessonDataDict : [String : String]  = ["lesson": lessons[indexPath.row]]
        NotificationCenter.default.post(name: NSNotification.Name("notificationLesson"), object: nil, userInfo: lessonDataDict)
        dismiss(animated: true)
    }

}
