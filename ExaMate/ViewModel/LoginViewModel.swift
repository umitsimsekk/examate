//
//  LoginViewModel.swift
//  ExamMate
//
//  Created by Ümit Şimşek on 18.09.2023.
//

import Foundation
import FirebaseAuth

protocol LoginViewModelInterface {
    var view : LoginViewControllerInterface?{ get set}
    var database : DatabaseManagerProtocol { get}
    var auth : AuthManagerProtocol { get}

    func viewDidLoad()
    func viewDidLayoutSubviews()
}

class LoginViewModel {
    weak var view: LoginViewControllerInterface?
     var database : DatabaseManagerProtocol = DatabaseManager()
    var auth: AuthManagerProtocol = AuthManager()
    
}

extension LoginViewModel : LoginViewModelInterface {
    func login(user: User) {
        
    }
    func viewDidLoad() {
        view?.addTarget()
        view?.configViews()
    }
    
    func viewDidLayoutSubviews() {
        view?.setFrames()
    }

}
