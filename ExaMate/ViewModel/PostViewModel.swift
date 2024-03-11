//
//  PostViewModel.swift
//  ExaMate
//
//  Created by Ümit Şimşek on 6.03.2024.
//

import Foundation
import UIKit
protocol PostViewModelInterface {
    var view : PostViewControllerInterface?{ get set}
    var database : DatabaseManagerProtocol { get}
    var auth : AuthManagerProtocol { get}
    var storage : StorageManagerProtocol{ get}

    func viewDidLoad()
    func viewDidLayoutSubviews()
    func viewWillAppear()
    
}
class PostViewModel{
    weak var view: PostViewControllerInterface?
    var database : DatabaseManagerProtocol = DatabaseManager()
    var auth: AuthManagerProtocol = AuthManager()
    var storage: StorageManagerProtocol = StorageManager()
    
    func sharePost(post: Post, img : UIImage) {
        print("share post called")
        let postedBy = auth.getCurrentUserEmail()
        storage.uploadPostImage(email: postedBy, postId: post.postId, image: img) { upload in
            if upload {
                print("success upload")
                self.storage.downloadPostImageUrl(email: postedBy, postId: post.postId) { url in
                    guard let postUrl = url else { 
                        print("error download")
                        return
                    }
                    print("success download")
                    let newPost = Post(postedBy: postedBy,
                                       postId: post.postId,
                                       question: post.question,
                                       lesson: post.lesson,
                                       answer: post.answer,
                                       imgUrl: postUrl,
                                       timestamp: post.timestamp)
                    self.database.insertPost(model: newPost) { success in
                        
                        if success {
                            print("success insert")
                            self.view?.showAlert(title: "Success", message: "Post successfuly shared",action: true)
                        } else {
                            self.view?.showAlert(title: "Fail", message: "An error occurred while sharing post",action: false)
                            print("error insert")
                        }
                    }
                }
            } else {
                print("error upload")
            }
        }

    }
    
}
extension PostViewModel : PostViewModelInterface {
    func viewWillAppear() {
        view?.handleOutputs()
    }
    
   
    func viewDidLoad() {
        view?.barButtons()
        view?.configureViews()
        view?.addTargets()
    }
    
    func viewDidLayoutSubviews() {
        view?.setFrame()
    }
    
    
}
