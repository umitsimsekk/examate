//
//  PrivateViewController.swift
//  ExaMate
//
//  Created by Ümit Şimşek on 4.03.2024.
//

import UIKit
protocol PrivateViewControllerInterface : AnyObject {
    func addBarButton()
    
}
class PrivateViewController: UIViewController {
    lazy var viewModel = PrivateViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        viewModel.view = self
        viewModel.viewDidLoad()
    }
}

extension PrivateViewController : PrivateViewControllerInterface {
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
        /*let vc = PrivateChatViewController(with: email)
        vc.title = username
        vc.isNewConversation = true
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
         */
    }
    @objc func didTapSettingButton() {
        let email = viewModel.getCurrentUserEmail()
        let vc = SettingViewController(userEmail: email)
        navigationController?.pushViewController(vc, animated: true)
    }
    private func listeningForConversations() {
        
    }
    func addBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapComposeButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSettingButton))
        listeningForConversations()
    }
    
    
    
}
