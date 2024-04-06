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
