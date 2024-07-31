//
//  PrivateViewModel.swift
//  ExaMate
//
//  Created by Ümit Şimşek on 2.04.2024.
//

import Foundation
import UIKit
protocol PrivateViewModelInterface {
    var view : PrivateViewControllerInterface?{ get set}
    var database : DatabaseManagerProtocol { get}
    var auth : AuthManagerProtocol { get}
    
    func listeningForConversations()
    func viewDidLoad()
    func viewDidLayoutSubviews()
}


class PrivateViewModel {
    weak var view: PrivateViewControllerInterface?
    var database : DatabaseManagerProtocol = DatabaseManager()
    var auth: AuthManagerProtocol = AuthManager()
}

extension PrivateViewModel : PrivateViewModelInterface {
    
    func listeningForConversations() {
        guard let currentUserEmail = AuthManager().getCurrentUserEmail() as? String else {
            return
        }
        
        database.getAllConversation(for: currentUserEmail) { [weak self] result in
            switch result {
            case .success(let convos):
                guard !convos.isEmpty else {
                    return
                }
                self!.view?.setConvos(convos: convos)
            case.failure(let error):
                print(error)
            }
        }
    }
    
    func viewDidLayoutSubviews() {
        view?.configureLayouts()
    }
    
    func getCurrentUserEmail() -> String{
        if let email = auth.getCurrentUserEmail() as? String{
            return email
        } else {
            return ""
        }
    }
    func viewDidLoad() {
        view?.addBarButton()
        view?.setTableViewDelegates()
        view?.listeningForConversations()
    }
    
}

