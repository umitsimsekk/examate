//
//  ChatViewController.swift
//  ExaMate
//
//  Created by Ümit Şimşek on 4.03.2024.
//

import UIKit
class ChatViewController: UIViewController {
    let channelsName = ["AYT Kanalı" , "TYT Kanalı" , "YDS Kanalı"]
    let channelLogo = ["ayt", "tyt", "lang"]
    private let chatTableView : UITableView = {
       let tableView = UITableView()
        tableView.register(ChatTableViewCell.self, forCellReuseIdentifier:  ChatTableViewCell.identifier)
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sohbet Odaları"
        navigationController?.navigationBar.prefersLargeTitles = true
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        view.addSubview(chatTableView)
        setTableViewDelegates()
    }
    override func viewDidLayoutSubviews() {
        super .viewDidLayoutSubviews()
        chatTableView.frame = view.bounds
    }
    
    func setTableViewDelegates() {
        self.chatTableView.dataSource = self
        self.chatTableView.delegate = self
    }

}
extension ChatViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        channelsName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.identifier, for: indexPath) as? ChatTableViewCell else {
            return UITableViewCell()
        }
        let name = channelsName[indexPath.row]
        let logo = channelLogo[indexPath.row]
        cell.configure(photo: logo, name: name)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ChannelChatViewController()
        vc.channelName = channelsName[indexPath.row]
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(vc, animated: true)
        
    }
}

