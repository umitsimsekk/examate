//
//  SettingsClassViewController.swift
//  ExamMate1
//
//  Created by Ümit Şimşek on 21.01.2024.
//

import UIKit

class SettingsClassViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    
    let lessons = [
        "BirinciSınıf","İkinciSınıf","ÜçüncüSınıf","DördüncüSınıf","BeşinciSınıf","AltıncıSınıf","YedinciSınıf","SekizinciSınıf",
        "Lise1","Lise2","Lise3","Lise4","Mezun"
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
        let classDataDict : [String : String]  = ["class": lessons[indexPath.row]]
        NotificationCenter.default.post(name: NSNotification.Name("notificationClass"), object: nil, userInfo: classDataDict)
    }

}
