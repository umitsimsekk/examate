//
//  PrivateViewController.swift
//  ExaMate
//
//  Created by Ümit Şimşek on 4.03.2024.
//

import UIKit
protocol PrivateViewControllerInterface : AnyObject {
    func addBarButton()
    func configureLayouts()
    func setTableViewDelegates()
    func setConvos(convos : [Convos])
    func listeningForConversations()
    
}
class PrivateViewController: UIViewController {
    lazy var viewModel = PrivateViewModel()
    var convos = [Convos]()
    
    private var tableView : UITableView = {
       let tableView = UITableView()
        tableView.register(PrivateChatTableViewCell.self
                           , forCellReuseIdentifier: PrivateChatTableViewCell.identifier)
        
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        viewModel.view = self
        viewModel.viewDidLoad()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewModel.viewDidLayoutSubviews()
        
    }
}
extension PrivateViewController{
    @objc func didTapComposeButton() {
        let vc = NewConversationViewController()
        vc.completion = { [weak self] result in
            print(result)
            self?.createNewConvorsation(results: result)
        }
        let navVc = UINavigationController(rootViewController: vc)
        present(navVc, animated: true)
    }
    private func createNewConvorsation(results : User) {
        guard let email = results.email as? String,
              let username = results.username as? String else {
            return
        }
        print(email)
        let vc = PrivateChatViewController(with: email)
        vc.title = username
        vc.isNewConversation = true
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
         
    }
    @objc func didTapSettingButton() {
        let email = viewModel.getCurrentUserEmail()
        let vc = SettingViewController(userEmail: email)
        navigationController?.pushViewController(vc, animated: true)
    }
   
}
extension PrivateViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        convos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PrivateChatTableViewCell.identifier, for: indexPath) as? PrivateChatTableViewCell else {
            return UITableViewCell()
        }
        let conv = convos[indexPath.row]
        cell.configure(username: conv.username, content: conv.content, email: conv.other_email)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = PrivateChatViewController(with: convos[indexPath.row].other_email)
        vc.title = convos[indexPath.row].username
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension PrivateViewController : PrivateViewControllerInterface {
    func listeningForConversations() {
        viewModel.listeningForConversations()
    }
    
    func setConvos(convos: [Convos]) {
        self.convos = convos
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func setTableViewDelegates() {
        view.addSubview(tableView)
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    func configureLayouts() {
        tableView.frame = view.bounds
    }
  
    func addBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapComposeButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSettingButton))
    }
    
}
