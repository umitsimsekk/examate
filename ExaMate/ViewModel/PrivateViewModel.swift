//
//  PrivateViewModel.swift
//  ExaMate
//
//  Created by Ümit Şimşek on 2.04.2024.
//

import Foundation
protocol PrivateViewModelInterface {
    var view : PrivateViewControllerInterface?{ get set}
    var database : DatabaseManagerProtocol { get}
    var auth : AuthManagerProtocol { get}
    func viewDidLoad()
}


class PrivateViewModel {
    weak var view: PrivateViewControllerInterface?
    var database : DatabaseManagerProtocol = DatabaseManager()
    var auth: AuthManagerProtocol = AuthManager()
}

extension PrivateViewModel : PrivateViewModelInterface {
    func getCurrentUserEmail() -> String{
        if let email = auth.getCurrentUserEmail() as? String{
            return email
        } else {
            return ""
        }
    }
    func viewDidLoad() {
        view?.addBarButton()
    }
    
}

