//
//  NewConversationViewModel.swift
//  ExaMate
//
//  Created by Ümit Şimşek on 28.07.2024.
//

import Foundation
protocol NewConversationViewModelInterface {
    var view : NewConversationViewControllerInterface?{ get set}
    var database : DatabaseManagerProtocol { get}
    
    func viewDidLoad()
    func viewDidLayoutSubviews()
    
    func searchUser(hasFetched: Bool,text: String)}

class NewConversationViewModel {
    weak var view : NewConversationViewControllerInterface?
    var database : DatabaseManagerProtocol = DatabaseManager()
    
}

extension NewConversationViewModel : NewConversationViewModelInterface {
    func searchUser(hasFetched: Bool,text: String) {
        
        if hasFetched {
            view?.filterUser(with: text)
        } else {
            self.database.getAllUser { [weak self] result in
                switch result {
                case .success(let user):
                    let fetched  = true
                    let users = user
                    self?.view?.setUserResults(hasFetched: fetched, users: users, query: text)
                case .failure(let error):
                    print("Failed to fetch user \(error)")
                }
            }
        }
    }
    
    func viewDidLoad() {
        view?.setTableViewDelegates()
        view?.setViewDidLoad()
    }
    
    func viewDidLayoutSubviews() {
        view?.configureLayout()
    }
}
