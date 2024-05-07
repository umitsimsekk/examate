//
//  StorageManager.swift
//  ExamMate1
//
//  Created by Ümit Şimşek on 06.03.2024.
//

import FirebaseStorage
protocol StorageManagerProtocol : AnyObject {
    // Post
    func uploadPostImage(email: String, postId : String ,image : UIImage, completion : @escaping(Bool)->Void)
    func downloadPostImageUrl(email : String, postId : String , completion : @escaping(URL?) -> Void)
    
    // Setting
    func uploadSettingsProfileImage(sender_email: String ,imageData : Data, completion : @escaping(Bool)->Void)
    func downloadSettingsProfileImageUrl(sender_email : String,completion : @escaping(URL?) -> Void)
    
    //Message
    func uploadMessageImage(sender_email: String, messageId : String ,imageData : Data, completion : @escaping(Bool)->Void)
    func downloadMessageImageUrl(sender_email : String, messageId : String , completion : @escaping(URL?) -> Void)
}

class StorageManager : StorageManagerProtocol {
    let storage = Storage.storage()
    
    // Post
    func uploadPostImage(email: String, postId : String ,image : UIImage, completion : @escaping(Bool)->Void){
        guard let pngData = image.pngData() else {
            return
        }
        let path = "post_headers/\(email)/\(postId).png"
        storage.reference(withPath: path).putData(pngData) { metadata, error in
            guard metadata != nil, error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    func downloadPostImageUrl(email : String, postId : String , completion : @escaping(URL?) -> Void){
        let path = "post_headers/\(email)/\(postId).png"
        storage.reference(withPath: path).downloadURL { url, error in
            guard url != nil , error == nil else {
                return
            }
            completion(url)
        }
    }
    //Settings
    
    func uploadSettingsProfileImage(sender_email: String ,imageData : Data, completion : @escaping(Bool)->Void){
        let path = "settings/\(sender_email)/\(sender_email).png"
        storage.reference(withPath: path).putData(imageData) { metadata, error in
            guard metadata != nil, error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    func downloadSettingsProfileImageUrl(sender_email : String,completion : @escaping(URL?) -> Void){
        let path = "settings/\(sender_email)/\(sender_email).png"
        storage.reference(withPath: path).downloadURL { url, error in
            guard url != nil , error == nil else {
                return
            }
            completion(url)
        }
    }
    
    //Message
    func uploadMessageImage(sender_email: String, messageId : String ,imageData : Data, completion : @escaping(Bool)->Void){
        let path = "message/\(sender_email)/\(messageId).png"
        storage.reference(withPath: path).putData(imageData) { metadata, error in
            guard metadata != nil, error == nil else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    func downloadMessageImageUrl(sender_email : String, messageId : String , completion : @escaping(URL?) -> Void){
        let path = "message/\(sender_email)/\(messageId).png"
        storage.reference(withPath: path).downloadURL { url, error in
            guard url != nil , error == nil else {
                return
            }
            completion(url)
        }
    }
}
