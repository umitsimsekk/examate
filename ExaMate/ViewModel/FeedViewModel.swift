//
//  FeedViewModel.swift
//  ExamMate1
//
//  
//

import UIKit

protocol FeedViewModelInterface {
    var view : FeedViewControllerInterface?{ get set}
    var database : DatabaseManagerProtocol { get}
    var posts : [Post]? { get set}
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
        cell.configure(with: self.posts![indexPath.row])

        return cell
    }
    func numberRowsInSection() -> Int {
        self.posts?.count ?? 0
    }
    
    func didSelectItem(at indexPath: IndexPath) -> UIViewController {
      UIViewController()
    }
    
    
}
