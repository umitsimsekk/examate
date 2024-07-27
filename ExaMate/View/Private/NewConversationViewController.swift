//
//  NewConversationViewController.swift
//  ExaMate
//
//  Created by Ümit Şimşek on 27.07.2024.
//

import UIKit
protocol NewConversationViewControllerInterface : AnyObject {
    func setUserResults(hasFetched: Bool, users : [User],query: String)
    func filterUser(with: String)
    func setTableViewDelegates()
    func didTapCancelButton()
    func setViewDidLoad()
    func configureLayout()
}
class NewConversationViewController: UIViewController {
    private var hasFetched = false
    private var results = [User]()
    private var users = [User]()
    public var completion : ((User) -> (Void))?

    
    lazy var viewModel = NewConversationViewModel()

    private let searchBar : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = " Search for users"
        return searchBar
    }()
    private let tableView : UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(UITableViewCell.self
                           , forCellReuseIdentifier: "cell")
        return tableView
    }()
    private let noResultsLabel : UILabel = {
       let lbl = UILabel()
        lbl.isHidden = true
        lbl.text = "No results"
        lbl.textAlignment = .center
        lbl.textColor = .green
        lbl.font = .systemFont(ofSize: 21,weight: .medium)
        
        return lbl
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewModel.viewDidLayoutSubviews()
    }
    
}

extension NewConversationViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        cell.textLabel?.text = results[indexPath.row].username
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let targetUserData = results[indexPath.row]
        dismiss(animated: true) { [weak self] in
            self?.completion?(targetUserData)
        }
        
        
    }
    
}
extension NewConversationViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return
        }
        results.removeAll()
        print("search button activated")
        viewModel.searchUser(hasFetched: hasFetched,text: text)
    }
}

extension NewConversationViewController: NewConversationViewControllerInterface {
    func configureLayout() {
        tableView.frame = view.bounds
        noResultsLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
    }
    
    func setViewDidLoad() {
        view.addSubview(noResultsLabel)
        view.addSubview(tableView)
        view.backgroundColor = .white
        searchBar.delegate = self
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(didTapCancelButton))
        searchBar.becomeFirstResponder()
    }
    
    func setUserResults(hasFetched: Bool, users: [User],query: String) {
        self.hasFetched = hasFetched
        self.users = users
        filterUser(with: query)
    }
    func filterUser(with term: String) {
        guard hasFetched else {
            return
        }
        var results : [User] = self.users.filter {
            guard let email = $0.email.lowercased() as? String else {
                return false
            }
            return email.hasPrefix(term.lowercased())
        }
        self.results = results
        updateUI()
    }
    
    func updateUI() {
        if results.isEmpty {
            self.tableView.isHidden = true
            self.noResultsLabel.isHidden = false
        } else {
            self.tableView.isHidden = false
            self.noResultsLabel.isHidden = true
            self.tableView.reloadData()
        }
    }
    func setTableViewDelegates(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    @objc func didTapCancelButton() {
        dismiss(animated: true)
    }
}
