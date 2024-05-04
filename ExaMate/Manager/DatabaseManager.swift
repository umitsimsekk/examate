//
//  DatabaseManager.swift
//  ExamMate
//
//  Created by Ümit Şimşek on 23.11.2023.
//

import Foundation
import FirebaseFirestore
import MessageKit
enum DataError : Error {
    case fetchPostError
    case fetchCommentError
    case fetchChatError
    case fetchUserError
}
protocol DatabaseManagerProtocol {
    
    //User
    func insertUser(model user : User, completion: @escaping(Bool)->Void)
    func getUsername(email : String, completion:@escaping(String)->Void)
    func getUserInfo(email: String, completion: @escaping(Result<User,DataError>)->Void)
    
    
    //Post
    func insertPost(model post : Post,completion: @escaping(Bool)->Void)
    func getAllPost(completion: @escaping(Result<[Post],DataError>)->Void)
    
    
    
    //Profile
    func getUserProfilePhoto(email: String ,completion : @escaping(URL?)->Void)
    func getUserProfileInfo(email: String ,completion : @escaping(Result<Profile,DataError>)->Void)
    func insertProfileInfo(profile : Profile, completion: @escaping(Bool)->Void)

    
    //Comment
    func getCommentsCount(postId : String, completion: @escaping(Int)->Void)
    func getCommentByPostId(postId: String,completion:@escaping(Result<[Comment], DataError>)->Void)
    func insertComment(model comment : Comment, completion: @escaping(Bool) -> Void)
    
    //Other
    func getFeedCell(model post: Post, completion: @escaping(FeedCell) -> Void)
    
    
    //Chat
    func sendMessage(to chatChannel: String,username : String, model chat : Message, completion : @escaping(Bool) -> Void)
    func getAllMessagesByChannelName(channelName : String, completion: @escaping(Result<[Message],DataError>)->Void)
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
    func getUsername(email : String, completion:@escaping(String)->Void) {
        database.collection("User").document(email).getDocument { documentSnapshot, error in
            guard error == nil, let username = documentSnapshot?.get("username") as? String else {
                return
            }
            completion(username)
        }
    }
    func getUserInfo(email: String, completion: @escaping(Result<User,DataError>)->Void) {
        database.collection("User").document(email).getDocument { documentsnaps, error in
            guard error == nil,
                  let username = documentsnaps?.get("username") as? String,
                  let email = documentsnaps?.get("email") as? String,
                  let password = documentsnaps?.get("password") as? String else {
                print("document error")
                completion(.failure(.fetchUserError))
                return
            }
            completion(.success(User(username: username, email: email, password: password)))
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
    
    func getUserProfilePhoto(email: String ,completion : @escaping(URL?)->Void) {
        database.collection("Profile").document(email).getDocument { documentsnaps, error in
            guard error == nil,
                  let profileImgUrl = documentsnaps?.get("profileImgUrl") as? String,
                  let url = URL(string: profileImgUrl) else {
                completion(nil)
                return
            }
            completion(url)
        }
    }
    func insertProfileInfo(profile : Profile, completion: @escaping(Bool)->Void) {
       guard let data = [
        "profileImgUrl" : profile.profileImgUrl.absoluteString,
            "username": profile.username,
            "email" : profile.email,
            "password": profile.password,
            "lessons" : profile.lessons,
            "grade" : profile.grade

       ] as? [String : Any] else {return }
        database.collection("Profile").document("\(profile.email)").setData(data) { error in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    func getUserProfileInfo(email: String ,completion : @escaping(Result<Profile,DataError>)->Void) {
        database.collection("Profile").document(email).getDocument { documentsnaps, error in
            guard error == nil,
                  let email = documentsnaps?.get("email") as? String,
                  let grade = documentsnaps?.get("grade") as? String,
                  let lessons = documentsnaps?.get("lessons") as? [String],
                  let password = documentsnaps?.get("password") as? String,
                  let profileImgUrl = documentsnaps?.get("profileImgUrl") as? String,
                  let url = URL(string: profileImgUrl),
                  let username = documentsnaps?.get("username") as? String else {
                completion(.failure(.fetchChatError))
                return
            }
            let profile = Profile(profileImgUrl: url, username: username, email: email, password: password, lessons: lessons, grade: grade)
            completion(.success(profile))
        }
    }
    
    func getCommentsCount(postId : String, completion: @escaping(Int)->Void) {
        var output = 0
        database.collection("Comment").getDocuments { querySnapshot, error in
            guard error == nil, let documents = querySnapshot?.documents else {
                completion(0)
                return
            }
            for document in documents {
                guard let commentPostId = document.get("postId") as? String else {return }
                
                if commentPostId == postId {
                    output += 1
                }
            }
            completion(output)
        }
    }
    func getCommentByPostId(postId: String,completion:@escaping(Result<[Comment], DataError>)->Void) {
        var comments = [Comment]()
        database.collection("Comment").order(by: "created").getDocuments { querySnapshot, error in
            guard error == nil, let documents = querySnapshot?.documents else {
                completion(.failure(.fetchCommentError))
                return
            }
            for document in documents {
                guard let commentBy = document["commentBy"] as? String,
                      let commentId = document["commentId"] as? String,
                      let commentText = document["commentText"] as? String,
                      let postId = document["postId"] as? String,
                      let created = document["created"] as? TimeInterval
                else {
                    print("Invalid fetch comments")
                    return
                }
                let comment = Comment(postId: postId, commentId: commentId, commentBy: commentBy, commentText: commentText, timestamp: created)
                comments.append(comment)
            }
            let newComs = comments.filter { comment in
                return comment.postId == postId
            }
            print(newComs.count)
            completion(.success(newComs))
        }
        

    }
    func insertComment(model comment : Comment, completion: @escaping(Bool) -> Void) {
        guard let data = [
            "commentBy" : comment.commentBy,
            "postId" : comment.postId,
            "commentId" : comment.commentId,
            "commentText" : comment.commentText,
            "created" : comment.timestamp
        ] as? [String : Any] else {
            completion(false)
            return
        }
        database.collection("Comment").document(comment.commentId).setData(data) { error in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    func getFeedCell(model post: Post, completion: @escaping(FeedCell) -> Void) {
        var count = 0
        database.collection("Profile").document(post.postedBy).getDocument { documentsnaps, error in
            guard error == nil,
                  let profileImgUrl = documentsnaps?.get("profileImgUrl") as? String,
                  let url = URL(string: profileImgUrl) else {
                return
            }
            self.database.collection("Comment").getDocuments { querySnapshot, error in
                guard error == nil, let documents = querySnapshot?.documents else {
                    return
                }
                for document in documents {
                    guard let commentPostId = document.get("postId") as? String else {return }
                    
                    if commentPostId == post.postId {
                        count += 1
                    }
                }
                self.database.collection("User").document(post.postedBy).getDocument { documentSnapshot, error in
                    guard error == nil, let username = documentSnapshot?.get("username") as? String else {
                        return
                    }
                    let feedCell = FeedCell(post: post, profilePhoto: url, commentCount: count, username: username)
                    completion(feedCell)
                    print(feedCell)
                }
                
            }
            
        }
    }
    //Chat
    
    func sendMessage(to chatChannel: String,username : String, model chat : Message, completion : @escaping(Bool) -> Void) {
        guard let currentUserEmail = AuthManager().getCurrentUserEmail() as? String else {
            completion(false)
            return
        }
        let channelName = setChannelName(channelName: chatChannel)

        var message = ""
        
        switch chat.kind {
           
        case .text(let messageText):
            message = messageText
        case .attributedText(_):
            break
        case .photo(let mediaItem):
            if let urlString = mediaItem.url?.absoluteString {
                message = urlString
            }
            break
        case .video(_):
            break
        case .location(_):
            break
        case .emoji(_):
            break
        case .audio(_):
            break
        case .contact(_):
            break
        case .linkPreview(_):
            break
        case .custom(_):
            break
        }
        let data : [ String : Any ] = [
            "id" : chat.messageId,
            "type" : chat.kind.messsageKindString,
            "content" : message,
            "date" : chat.sentDate,
            "sender_email" : currentUserEmail,
            "channel" : channelName,
            "username" : username,
            "is_read" : false
        ]
        database.collection("Chat").addDocument(data: data) { error in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    func setChannelName(channelName : String) -> String {
        var name = channelName
        if channelName == "TYT Kanalı" {
            name = "tytkanali"
        } else if channelName == "AYT Kanalı" {
            name = "aytkanali"
        } else {
            name = "ydskanali"
        }
        return name
    }
    func getAllMessagesByChannelName(channelName : String, completion: @escaping(Result<[Message],DataError>)->Void) {
      var messages = [Message]()
      let name = setChannelName(channelName: channelName)
        
        database.collection("Chat").order(by: "date", descending: false).getDocuments { snapshot, error in
            guard error == nil,let docs = snapshot?.documents else {
                completion(.failure(.fetchChatError))
                return
            }
            for doc in docs {
                guard let content =  doc["content"] as? String,
                      let id = doc["id"]  as? String,
                      let type =  doc["type"]  as? String,
                      let date = doc["date"] as? Timestamp,
                      let sender_email = doc["sender_email"] as? String,
                      let channel = doc["channel"] as? String,
                      let username = doc["username"] as? String,
                      let datee = date.dateValue() as? Date,
                      let isRead = doc["is_read"]  as? Bool
                else {
                    completion(.failure(.fetchChatError))
                    return
                }
                if channel == name {
                    var kind : MessageKind?
                    if type == "photo" {
                        guard let url = URL(string: content) as? URL,
                        let placeHolder = UIImage(systemName: "plus") else {
                            return
                        }
                        let media = Media(url:url,placeholderImage: placeHolder, size: CGSize(width: 300, height: 300))
                        
                        kind = .photo(media)
                    } else {
                        kind = .text(content)
                    }
                    guard let finalKind = kind else {
                        return
                    }
                    let sender = Sender(senderId: sender_email, displayName: username)
                    let message = Message(sender: sender, messageId: id, sentDate: datee, kind: finalKind)
                    messages.append(message)
                }
            }
            completion(.success(messages))
        }
       
    }
}
