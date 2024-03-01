//
//  DatabaseManager.swift
//  ExamMate
//
//  Created by Ümit Şimşek on 23.11.2023.
//

import Foundation
import FirebaseFirestore
protocol DatabaseManagerProtocol {
    func insertUser(model user : User, completion: @escaping(Bool)->Void)
}

class DatabaseManager : DatabaseManagerProtocol {
    
    let database = Firestore.firestore()
    
    func insertUser(model user : User, completion: @escaping(Bool)->Void) {
        guard let data = [
            "username" : user.username,
            "email" : user.email,
            "password" : user.password
        ] as? [String : Any] else {
            completion(false)
            return
        }
        database.collection("User").document(user.email).setData(data) { error in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
}
