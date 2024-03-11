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
    func viewWillAppear()
}

class LoginViewModel {
    weak var view: LoginViewControllerInterface?
     var database : DatabaseManagerProtocol = DatabaseManager()
    var auth: AuthManagerProtocol = AuthManager()
    
}

extension LoginViewModel : LoginViewModelInterface {
   
    func login(user: User) {
        auth.signIn(withEmail: user.email, password: user.password) { success in
            if success {
                self.view?.showAlert(title: "Success", message: "User successfuly signed in",action: true)
            }else {
                self.view?.showAlert(title: "Error", message: "User not signed in",action: false)
            }
        }
    }
    func checkLogin() {
        guard let user = FirebaseAuth.Auth.auth().currentUser else {
            return
        }
        view?.showMainTabbar()
    }
    func viewDidLoad() {
        view?.addTarget()
        view?.configViews()
    }
    
    func viewDidLayoutSubviews() {
        view?.setFrames()
    }
    func viewWillAppear() {
        checkLogin()
    }

}
