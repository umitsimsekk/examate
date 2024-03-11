//
//  StorageManager.swift
//  ExamMate1
//
//  Created by Ümit Şimşek on 06.03.2024.
//

import FirebaseStorage
protocol StorageManagerProtocol : AnyObject {
    // post
    func uploadPostImage(email: String, postId : String ,image : UIImage, completion : @escaping(Bool)->Void)
    func downloadPostImageUrl(email : String, postId : String , completion : @escaping(URL?) -> Void)
    
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
    
}
