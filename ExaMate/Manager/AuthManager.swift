//
//  AuthManager.swift
//  ExamMate
//
//  Created by Ümit Şimşek on 18.09.2023.
//

import Foundation
import FirebaseAuth


protocol AuthManagerProtocol {
    func createUser(withEmail email : String, password: String, completion: @escaping(Bool)->Void)
    func signIn(withEmail email: String, password: String, completion: @escaping(Bool)->Void)
    func getCurrentUserEmail() -> String

}
class AuthManager : AuthManagerProtocol {
    let auth = FirebaseAuth.Auth.auth()
    
    func createUser(withEmail email : String, password: String, completion: @escaping(Bool)->Void) {
        auth.createUser(withEmail: email, password: password) { _, error in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    func signIn(withEmail email: String, password: String, completion: @escaping(Bool)->Void) {
        auth.signIn(withEmail: email, password: password) { _, error in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    func getCurrentUserEmail() -> String {
        guard let currentUserEmail = auth.currentUser?.email as? String else {
            return ""
        }
        return currentUserEmail
    }

}
