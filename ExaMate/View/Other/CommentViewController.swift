//
//  CommentViewController.swift
//  ExamMate1
//
//  Created by Ümit Şimşek on 2.12.2023.
//

import UIKit
import SDWebImage
protocol CommentViewControllerInterface : AnyObject {
    func setTableViewDelegates()
    func configViews()
    func configure(with model : FeedCell)
    func setFrames()
    func showAlert(title: String, message: String)
    func fetchComments()
    var commentsTableView : UITableView { get set}
    func addTarget()
}
class CommentViewController: UIViewController {
    var postId = ""
    var post : Post
    lazy var viewModel = CommentViewModel()
    private let scrollView : UIScrollView = {
       let vieww = UIScrollView()
        vieww.backgroundColor = .green
        return vieww
    }()
    private let profileImgView : UIImageView = {
       let imgView = UIImageView()
        let img = UIImage(systemName: "person.circle")
        imgView.image = img
        
        imgView.layer.cornerRadius = 25
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
      return imgView
    }()
    
    private let usernameLabel : UILabel = {
       let lbl = UILabel()
        lbl.clipsToBounds = true
        lbl.text = "Username"
        lbl.textColor = .label
        return lbl
    }()
    
    private let lessonNameLabel : UILabel  = {
        let lbl = UILabel()
         lbl.clipsToBounds = true
         lbl.textAlignment = .right
         lbl.textColor = .label
         lbl.text = "TYT Matematik"
         return lbl
    }()
    private let questionTextLabel : UILabel  = {
        let lbl = UILabel()
         lbl.clipsToBounds = true
         lbl.text = "Soru böyle gözükecekSoru böyle gözükecekSoru böyle gözükecekSoru böyle gözükecekSoru böyle gözükecekSoru böyle gözükecekSoru böyle gözükecekSoru böyle gözükecekSoru böyle gözükecekSoru böyle gözükecekSoru böyle gözükecekSoru böyle gözükecekSoru böyle gözükecekSoru böyle gözükecek"
        lbl.numberOfLines = 0
         return lbl
    }()
    
    private let postImgView : UIImageView = {
        let imgView = UIImageView()
         let img = UIImage(systemName: "photo")
         imgView.image = img
         imgView.clipsToBounds = true
         imgView.contentMode = .scaleAspectFill
         return imgView
    }()
    
    private let answerLabel : UILabel  = {
        let lbl = UILabel()
         lbl.clipsToBounds = true
         lbl.text = "12 Yanıt"
         return lbl
    }()
    
     var commentsTableView : UITableView = {
        let tableView = UITableView()
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
         return tableView
    }()
    
    private let commentUIView : UIView = {
       let vieww = UIView()
        vieww.backgroundColor = .systemGray3
        vieww.layer.cornerRadius = 12
        
        return vieww
        
    }()
    
    private let messageTextField : UITextField = {
       let txtField = UITextField()
        txtField.placeholder = "Enter message..."
        txtField.clipsToBounds = true
        txtField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        txtField.leftViewMode = .always
        
        txtField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        txtField.rightViewMode = .always
        
        txtField.layer.cornerRadius = 4
        txtField.backgroundColor = .systemGray6
        
        txtField.autocorrectionType = .no
        txtField.autocapitalizationType = .none
        return txtField
    }()

    private let sendUIView : UIView = {
       let vieww = UIView()
        vieww.backgroundColor = .systemGray6
        vieww.layer.cornerRadius = 12
        return vieww
        
    }()
    
    private let sendButtonImgView : UIImageView = {
        let imgView = UIImageView()
        let img = UIImage(systemName: "paperplane.fill")
        imgView.image = img
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()
    init(post: Post) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
        self.viewModel.getFeedCell(post: post)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        viewModel.view = self
        viewModel.viewDidLoad()
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewModel.viewDidLayoutSubviews()
    }
 
}
extension CommentViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //viewModel.numberRowsInSection()
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //viewModel.cellForRow(tableView, cellForRowAt: indexPath)
        let cell = UITableViewCell()
        cell.textLabel?.text = "TEXT"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
}

extension CommentViewController : CommentViewControllerInterface {
    
    func addTarget() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapSendButton))
        self.sendButtonImgView.isUserInteractionEnabled = true
        self.sendButtonImgView.addGestureRecognizer(gestureRecognizer)
    }
    func fetchComments() {
        viewModel.getCommentsByPostId(postId: postId)
    }
    
    func showAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK!", style: .cancel)
            alert.addAction(action)
            present(alert, animated: true)
        self.messageTextField.text = ""
        
    }
    
    @objc func didTapSendButton() {
        guard let message = messageTextField.text, !message.isEmpty,
              self.postId != ""
        else {
            return
        }
        let comment = Comment(postId: postId,
                              commentId: "",
                              commentBy: "",
                              commentText: message,
                              timestamp: Date().timeIntervalSince1970)
        self.viewModel.insertComment(comment: comment)
    }
    func setTableViewDelegates() {
        self.commentsTableView.dataSource = self
        self.commentsTableView.delegate = self
    }
    func configViews() {
        scrollView.addSubview(profileImgView)
        scrollView.addSubview(usernameLabel)
        scrollView.addSubview(lessonNameLabel)
        scrollView.addSubview(questionTextLabel)
        scrollView.addSubview(postImgView)
        scrollView.addSubview(answerLabel)
        scrollView.addSubview(commentsTableView)
        
        commentUIView.addSubview(messageTextField)
        sendUIView.addSubview(sendButtonImgView)
        commentUIView.addSubview(sendUIView)
        scrollView.addSubview(commentUIView)
        
        view.addSubview(scrollView)
    }
    func configure(with model : FeedCell) {
        self.questionTextLabel.text = model.post.question
        self.lessonNameLabel.text = model.post.lesson
        self.answerLabel.text = model.post.answer
        guard let url = model.post.imgUrl else { return }
        
        self.postImgView.sd_setImage(with: url)
       
        self.postId = model.post.postId
        
        self.usernameLabel.text = model.username
        
        
    }
    
    func setFrames(){
        scrollView.contentSize = CGSize(width: view.width, height: 2000)
        scrollView.frame = CGRect(x: 0,
                                  y: 0,
                                  width: view.width,
                                  height: view.height)
        
        profileImgView.frame = CGRect(x: 10,
                                      y: scrollView.top+10,
                                      width: 50,
                                      height: 50)
        usernameLabel.frame = CGRect(x: profileImgView.right+10,
                                      y: scrollView.top+10,
                                      width: 100,
                                      height: 50)
        lessonNameLabel.frame = CGRect(x: (view.width-150),
                                       y: scrollView.top+10,
                                       width: 150,
                                       height: 50)
        questionTextLabel.frame = CGRect(x: 10,
                                         y: profileImgView.bottom,
                                         width: view.width-20,
                                         height: 70)
        postImgView.frame = CGRect(x: 10,
                                   y:questionTextLabel.bottom+10,
                                         width: view.width-20,
                                         height: 200)
        answerLabel.frame = CGRect(x: 10,
                                   y:postImgView.bottom+10,
                                         width: view.width-20,
                                         height: 20)
        commentsTableView.frame = CGRect(x: 10,
                                        y:answerLabel.bottom+10,
                                              width: view.width-20,
                                         height: scrollView.height-20)
        commentUIView.frame = CGRect(x: 0,
                                     y:view.bottom-150,
                                              width: view.width,
                                              height: 70)
        messageTextField.frame = CGRect(x: 10,
                                        y:10,
                                        width: commentUIView.width-80,
                                              height: 50)
        sendUIView.frame = CGRect(x: commentUIView.right-60,
                                     y:10,
                                              width: 50,
                                              height: 50)
        sendButtonImgView.frame = CGRect(x: 10,
                                     y:10,
                                              width: 30,
                                              height: 30)
    }
    
}
