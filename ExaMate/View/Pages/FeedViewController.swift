//
//  FeedViewController.swift
//  ExaMate
//
//  Created by Ümit Şimşek on 4.03.2024.
//
import UIKit

protocol FeedViewControllerInterface : AnyObject {
    func prepareButtonAction()
    func tableViewFrame()
    func prepareTableViewDelegates()
    var feedTableView : UITableView {get set}
}
class FeedViewController: UIViewController {
    lazy var viewModel = FeedViewModel()
    
    var feedTableView : UITableView = {
       let tableView = UITableView()
        tableView.register(FeedTableViewCell.self, forCellReuseIdentifier: FeedTableViewCell.identifier)
        return tableView
    }()
    
    private let chatGptImageView : UIImageView = {
        let imgView = UIImageView()
         let img = UIImage(named: "chatgpt")
         imgView.image = img
         
         imgView.layer.cornerRadius = 25
         imgView.contentMode = .scaleAspectFill
         imgView.clipsToBounds = true
       return imgView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableViewFrame()
        chatGptImageView.frame = CGRect(x: view.width-80,
                                        y: view.safeAreaInsets.top+600,
                                      width: 60,
                                      height: 60)
        
    }
}
extension FeedViewController {
    @objc func didTapImgView(){
        // Ai
    }
    @objc func didTapAddButton() {
        let vc = PostViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        self.present(nav, animated: true)
    }
    
}
extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        viewModel.cellForRow(tableView, cellForRowAt: indexPath)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberRowsInSection()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 500
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = viewModel.didSelectItem(at: indexPath)
        navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension FeedViewController : FeedViewControllerInterface {
   
    func prepareTableViewDelegates() {
        self.feedTableView.dataSource = self
        self.feedTableView.delegate = self
    }
    
    func tableViewFrame() {
        self.feedTableView.frame = view.bounds
        
    }
    
    func prepareButtonAction() {
        view.backgroundColor = .systemGray
        view.addSubview(chatGptImageView)
        view.addSubview(feedTableView)
        prepareTableViewDelegates()
        
        navigationItem.largeTitleDisplayMode = .always
        title = "Soru Odaları"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddButton))
        chatGptImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapImgView))
        chatGptImageView.addGestureRecognizer(gestureRecognizer)
        
        
    }

}
