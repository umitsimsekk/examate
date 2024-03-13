//
//  FeedViewModel.swift
//  ExamMate1
//
//  
//

import UIKit
struct FeedCell {
    var post : Post
    var profilePhoto : URL?
    var commentCount : Int
    var username : String
}
protocol FeedViewModelInterface {
    var view : FeedViewControllerInterface?{ get set}
    var database : DatabaseManagerProtocol { get}
    func viewDidLoad()
    func viewDidLayoutSubviews()
    func viewWillAppear()
    func didSelectItem(at indexPath : IndexPath) -> UIViewController 
    func numberRowsInSection() -> Int
    func cellForRow(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell

}

class FeedViewModel {
   weak var view: FeedViewControllerInterface?
    var database : DatabaseManagerProtocol = DatabaseManager()
    var posts: [Post]?
    var url : URL?
    var count : Int?
    var username : String?
}

extension FeedViewModel : FeedViewModelInterface {
   
    func fetchData() {
        database.getAllPost(completion: { results in
            switch results {
            case .success(let post):
                self.posts = post
                DispatchQueue.main.async {
                    self.view?.feedTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        })
    }
    func getProfilePhotoUrl(email : String) {
        database.getUserProfilePhoto(email: email) { url in
            guard let urlString = url else {return }
            self.url = urlString
            
        }
    }
    func getUsername(email: String) {
        database.getUsername(email: email) { username in
            self.username = username
        }
    }
    
    func getCommentsCount(postId: String) {
        database.getCommentsCount(postId: postId) { count in
            self.count = count
        }
    }
   
    func viewDidLoad() {
        view?.prepareButtonAction()
        fetchData()
    }
    func viewWillAppear() {
        fetchData()

    }
    func viewDidLayoutSubviews() {
        view?.tableViewFrame()
    }
    func cellForRow(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.identifier, for: indexPath) as? FeedTableViewCell else {
            return UITableViewCell()
        }
        guard let psts = posts else {
            return UITableViewCell()
        }

        let post = psts[indexPath.row]
        var feedCell = FeedCell(post: post, profilePhoto: nil, commentCount: 0, username: "")
        database.getUserProfilePhoto(email: post.postedBy) { [weak self] url in
            if let urlString = url {
                feedCell.profilePhoto = urlString
            }
            self?.database.getCommentsCount(postId: post.postId) { count in
                feedCell.commentCount = count
                
                self?.database.getUsername(email: post.postedBy) { username in
                    feedCell.username = username
                    cell.configure(with: feedCell)
                }
            }
            
        }
        return cell
    }
    func numberRowsInSection() -> Int {
        self.posts?.count ?? 0
    }
    
    func didSelectItem(at indexPath: IndexPath) -> UIViewController {
      UIViewController()
    }
    
    
}
