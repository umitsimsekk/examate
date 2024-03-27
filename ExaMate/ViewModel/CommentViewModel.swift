//
//  CommentViewModel.swift
//  ExaMate
//
//  Created by Ümit Şimşek on 14.03.2024.
//

import UIKit
protocol CommentViewModelInterface {
    var view : CommentViewControllerInterface?{ get set}
    var database : DatabaseManagerProtocol { get}
    var auth : AuthManagerProtocol {get}
    
    
    func viewDidLoad()
    func viewDidLayoutSubviews()
    func viewWillAppear()
    func numberRowsInSection() -> Int
    func cellForRow(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    func getFeedCell(post: Post)

}
struct CommentCell {
    var text : String
    var username : String
    var profilePhoto : URL?

}

class CommentViewModel {
    weak var view: CommentViewControllerInterface?
    var database: DatabaseManagerProtocol = DatabaseManager()
    var auth: AuthManagerProtocol = AuthManager()
    var comments: [Comment]?
    
    func getCommentsByPostId(postId: String) {
        database.getCommentByPostId(postId: postId) { results in
            print("vm postId:\(postId)")
            switch results {
            case .success(let comments):
                self.comments = comments
                print(comments)
                DispatchQueue.main.async {
                    self.view?.commentsTableView.reloadData()
                }
            case .failure(let error):
                print(error)

            }
        }
    }
   
    func insertComment(comment: Comment) {
        let commentId = UUID().uuidString
        let commentBy = auth.getCurrentUserEmail()
        let comment = Comment(postId: comment.postId,
                              commentId: commentId,
                              commentBy: commentBy,
                              commentText: comment.commentText,
                              timestamp: comment.timestamp)
        database.insertComment(model: comment) { success in
            if success {
                self.view?.showAlert(title: "Success", message: "Comment maked")
            } else {
                self.view?.showAlert(title: "Error", message: "Comment error")

            }
        }
    }
}

extension CommentViewModel : CommentViewModelInterface {
    func getFeedCell(post: Post) {
        var feedCell = FeedCell(post: post, profilePhoto: nil, commentCount: 0, username: "")
        database.getUserProfilePhoto(email: post.postedBy) { [weak self] url in
            if let urlString = url {
                feedCell.profilePhoto = urlString
            }
            self?.database.getCommentsCount(postId: post.postId) { count in
                feedCell.commentCount = count
                
                self?.database.getUsername(email: post.postedBy) { username in
                    feedCell.username = username
                    self?.view?.configure(with: feedCell)
                }
            }
            
        }
    }
    
    func cellForRow(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as? CommentTableViewCell else {
            return UITableViewCell()
        }
        let comment = self.comments![indexPath.row]
        var commentCell = CommentCell(text: comment.commentText, username: "", profilePhoto: nil)
        database.getUserProfilePhoto(email: comment.commentBy) {[weak self] url in
            if let urlString = url {
                commentCell.profilePhoto = urlString
            }
            self?.database.getUsername(email: comment.commentBy) { username in
                commentCell.username = username
                cell.configure(comment: commentCell)
            }
        }
        return cell
    }
    
    func viewDidLoad() {
        view?.configViews()
        view?.setTableViewDelegates()
        view?.addTarget()
    }
    
    func viewDidLayoutSubviews() {
        view?.setFrames()
    }
    
    func viewWillAppear() {
    }
    
    func numberRowsInSection() -> Int {
        comments?.count ?? 0
    }
    
    
}
