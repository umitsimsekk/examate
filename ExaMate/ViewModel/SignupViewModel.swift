//
//  LoginViewModel.swift
//  ExamMate
//
//  Created by Ümit Şimşek on 18.09.2023.
//

import Foundation
protocol SignupViewModelInterface {
    var view : SignupViewControllerInterface?{ get set}
    var database : DatabaseManagerProtocol { get}
    var auth : AuthManagerProtocol { get}

    func viewDidLoad()
    func viewDidLayoutSubviews()
}
class SignupViewModel {
    weak var view: SignupViewControllerInterface?
    var database : DatabaseManagerProtocol = DatabaseManager()
    var auth: AuthManagerProtocol = AuthManager()
    
}

extension SignupViewModel : SignupViewModelInterface {
    func signup(user : User) {
        auth.createUser(withEmail: user.email, password: user.password) { created in
            if created {
                self.database.insertUser(model: user) { inserted in
                    if inserted {
                        self.view?.showAlert(title: "Success", message: "Successfuly signed up")
                    } else {
                        self.view?.showAlert(title: "Error", message: "Failed insert")
                    }
                }
            } else {
                self.view?.showAlert(title: "Error!", message: "Failed to sign up..." )
            }
        }
    }
    func viewDidLoad() {
        view?.configViews()
        view?.addTarget()
    }
    
    func viewDidLayoutSubviews() {
        view?.setFrames()
    }
    
    
}
