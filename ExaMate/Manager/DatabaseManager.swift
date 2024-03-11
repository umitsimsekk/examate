//
//  DatabaseManager.swift
//  ExamMate
//
//  Created by Ümit Şimşek on 23.11.2023.
//

import Foundation
import FirebaseFirestore
enum DataError : Error {
    case fetchPostError
    case fetchCommentError
    case fetchChatError
    case fetchUserError
}
protocol DatabaseManagerProtocol {
    
    //User
    func insertUser(model user : User, completion: @escaping(Bool)->Void)
    
    
    
    //Post
    func insertPost(model post : Post,completion: @escaping(Bool)->Void)
    func getAllPost(completion: @escaping(Result<[Post],DataError>)->Void)
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
    
    func insertPost(model post : Post,completion: @escaping(Bool)->Void) {
        guard let data = [
            "postedBy" : post.postedBy,
            "postId" : post.postId,
            "question" : post.question,
            "lesson" : post.lesson,
            "answer" : post.answer,
            "imgUrl" : post.imgUrl?.absoluteString ?? "",
            "created" : post.timestamp
        ] as? [String : Any] else {
            completion(false)
            return
        }
        database.collection("Post").document(post.postId).setData(data) { error in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    func getAllPost(completion: @escaping(Result<[Post],DataError>)->Void) {
        var posts = [Post]()
        
        database.collection("Post").order(by: "created", descending: true).getDocuments { querySnapshot, error in
            guard error == nil,
                  let documents = querySnapshot?.documents else {
                completion(.failure(.fetchPostError))
                return
            }
        
            for document in documents {
                guard let postId = document["postId"] as? String,
                      let postedBy = document["postedBy"] as? String,
                      let question = document["question"] as? String,
                      let answer = document["answer"] as? String,
                      let lesson = document["lesson"] as? String,
                      let imgUrl = document["imgUrl"] as? String,
                      let created = document["created"] as? TimeInterval
                else {
                    print("Invalid fetch posts")
                    return
                }
                let post = Post(postedBy: postedBy, postId: postId, question: question, lesson: lesson, answer: answer, imgUrl: URL(string: imgUrl),timestamp: created)
                posts.append(post)
            }
            completion(.success(posts))
        }
    }
    
    
}
