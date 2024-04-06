//
//  SettingsLessonViewController.swift
//  ExamMate1
//
//  Created by Ümit Şimşek on 20.01.2024.
//

import UIKit

class SettingLessonViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    var selectedLessons = [Int]()
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "İlet", style: .done, target: self, action: #selector(didTapButton))

    }
    @objc func didTapButton() {
        var output = [String]()
        
        for index in selectedLessons {
            output.append(lessons[index])
        }
        let lessonDataDict : [String : [String]]  = ["lessons" : output]
        NotificationCenter.default.post(name: NSNotification.Name("notificationLesson"), object: nil, userInfo: lessonDataDict)
        
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
        cell.accessoryType = selectedLessons.contains(indexPath.row) ? .checkmark : .none
        cell.backgroundColor = selectedLessons.contains(indexPath.row) ? .lightGray : .clear
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if selectedLessons.contains(indexPath.row) {
            let index = selectedLessons.firstIndex(of: indexPath.row)
            selectedLessons.remove(at: index!)
        } else {
            selectedLessons.append(indexPath.row)
        }
        tableView.reloadData()
    }

}
