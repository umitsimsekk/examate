//
//  ProfileViewController.swift
//  ExaMate
//
//  Created by Ümit Şimşek on 8.05.2024.
//

import UIKit
import SDWebImage
protocol ProfileViewControllerInterface : AnyObject {
    var profileInfo : profileInfo?{get set}
    var counts: [String]?{get set}
    func setFrames()
    func configViews()
    func getUserInfo()
    func setInfo()
    func getCounts()
    func setCounts()
    
}
class ProfileViewController: UIViewController {
    lazy var viewModel = ProfileViewModel()
    public var message : Message
    var profileInfo: profileInfo?
    var counts: [String]?
    
    init(message: Message) {
        self.message = message
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private let profileImgView : UIImageView = {
       let imgView = UIImageView()
        let img = UIImage(named: "logo")
        imgView.image = img
        
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 100
        return imgView
    }()
    private let usernameLabel : UILabel = {
       let lbl = UILabel()
        lbl.text = "abc"
        lbl.font = .systemFont(ofSize: 22, weight: .medium)
        lbl.textAlignment = .center
        return lbl
    }()
    private let userEmailLabel : UILabel = {
       let lbl = UILabel()
        lbl.text = "abc@gmail.com"
        lbl.font = .systemFont(ofSize: 17, weight: .regular)
        lbl.textAlignment = .center
        return lbl
    }()
    private let sendMessageView : UIView = {
       let vieww = UIView()
        vieww.backgroundColor = .systemGreen
        vieww.layer.cornerRadius = 12
        return vieww
    }()
    private let sendMessageImgView : UIImageView = {
       let imgView = UIImageView()
        let img = UIImage(systemName: "ellipsis.message.fill")
        imgView.image = img
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    private let sendMessageLabel : UILabel = {
       let lbl = UILabel()
        lbl.text = "Mesaj gönder"
        lbl.font = .systemFont(ofSize: 18, weight: .semibold)
        lbl.textAlignment = .center
        return lbl
    }()
    //username
    private let usernameContainerView : UIView = {
       let vieww = UIView()
        vieww.backgroundColor = .systemGray6
        vieww.layer.cornerRadius = 12
        return vieww
    }()
    private let usernameImageContainerView : UIView = {
       let vieww = UIView()
        vieww.backgroundColor = .systemOrange
        vieww.layer.cornerRadius = 12
        return vieww
    }()
    private let usernameTextFieldImgView : UIImageView = {
       let imgView = UIImageView()
        let img = UIImage(systemName: "person.fill")
        imgView.image = img
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleToFill
        return imgView
    }()
    private let usernameTextField : UITextField = {
       let txtField = UITextField()
        txtField.isEnabled = false
        txtField.placeholder = "Username"
        txtField.clipsToBounds = true
        txtField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        txtField.leftViewMode = .always
        
        txtField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        txtField.rightViewMode = .always
        
        txtField.layer.cornerRadius = 4
        
        txtField.autocorrectionType = .no
        txtField.autocapitalizationType = .none
        
        txtField.textContentType = .emailAddress
        return txtField
    }()
    //emaail
    private let emailContainerView : UIView = {
       let vieww = UIView()
        vieww.backgroundColor = .systemGray6
        vieww.layer.cornerRadius = 12
        return vieww
    }()
    private let emailImageContainerView : UIView = {
       let vieww = UIView()
        vieww.backgroundColor = .systemGreen
        vieww.layer.cornerRadius = 12
        return vieww
    }()
    private let emailTextFieldImgView : UIImageView = {
       let imgView = UIImageView()
        let img = UIImage(systemName: "envelope")
        imgView.image = img
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleToFill
        return imgView
    }()
    private let emailTextField : UITextField = {
       let txtField = UITextField()
        txtField.isEnabled = false
        txtField.placeholder = "Email address"
        txtField.clipsToBounds = true
        txtField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        txtField.leftViewMode = .always
        
        txtField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        txtField.rightViewMode = .always
        
        txtField.layer.cornerRadius = 4
        
        txtField.autocorrectionType = .no
        txtField.autocapitalizationType = .none
        
        txtField.textContentType = .emailAddress
        return txtField
    }()
    
    //lesson
    private let lessonContainerView : UIView = {
       let vieww = UIView()
        vieww.backgroundColor = .systemGray6
        vieww.layer.cornerRadius = 12
        return vieww
    }()
    private let lessonImageContainerView : UIView = {
       let vieww = UIView()
        vieww.backgroundColor = .systemYellow
        vieww.layer.cornerRadius = 12
        return vieww
    }()
    private let lessonTextFieldImgView : UIImageView = {
       let imgView = UIImageView()
        let img = UIImage(systemName: "book.fill")
        imgView.image = img
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleToFill
        return imgView
    }()
    private let lessonTextField : UITextField = {
       let txtField = UITextField()
        txtField.placeholder = "Favorite lessons"
        txtField.clipsToBounds = true
        txtField.isEnabled = false
        txtField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        txtField.leftViewMode = .always
        
        txtField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        txtField.rightViewMode = .always
        
        txtField.layer.cornerRadius = 4
        
        txtField.autocorrectionType = .no
        txtField.autocapitalizationType = .none
        
        txtField.textContentType = .emailAddress
        return txtField
    }()
    
    //class
    private let classContainerView : UIView = {
       let vieww = UIView()
        vieww.backgroundColor = .systemGray6
        vieww.layer.cornerRadius = 12
        return vieww
    }()
    private let classImageContainerView : UIView = {
       let vieww = UIView()
        vieww.backgroundColor = .systemRed
        vieww.layer.cornerRadius = 12
        return vieww
    }()
    private let classTextFieldImgView : UIImageView = {
       let imgView = UIImageView()
        let img = UIImage(systemName: "graduationcap.fill")
        imgView.image = img
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleToFill
        return imgView
    }()
    private let classTextField : UITextField = {
       let txtField = UITextField()
        txtField.placeholder = "Grade"
        txtField.clipsToBounds = true
        txtField.isEnabled = false
        txtField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        txtField.leftViewMode = .always
        
        txtField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        txtField.rightViewMode = .always
        
        txtField.layer.cornerRadius = 4
        
        txtField.autocorrectionType = .no
        txtField.autocapitalizationType = .none
        
        txtField.textContentType = .emailAddress
        return txtField
    }()
   //post
    private let postContainerView : UIView = {
       let vieww = UIView()
        vieww.backgroundColor = .blue
        vieww.layer.cornerRadius = 12
        return vieww
    }()
    private let postImgView : UIImageView = {
       let imgView = UIImageView()
        let img = UIImage(systemName: "square.and.arrow.up.fill")
        imgView.image = img
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleToFill
        return imgView
    }()
    private let postLabel : UILabel = {
       let lbl = UILabel()
        lbl.text = "17"
        lbl.font = .systemFont(ofSize: 17, weight: .regular)
        lbl.textAlignment = .center
        return lbl
    }()
    //comment
    private let commentContainerView : UIView = {
        let vieww = UIView()
        vieww.backgroundColor = .systemPink
        vieww.layer.cornerRadius = 12
        return vieww
    }()
    private let commentImgView : UIImageView = {
        let imgView = UIImageView()
        let img = UIImage(systemName: "message.fill")
        imgView.image = img
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleToFill
        return imgView
    }()
    private let commentLabel : UILabel = {
        let lbl = UILabel()
        lbl.text = "17"
        lbl.font = .systemFont(ofSize: 17, weight: .regular)
        lbl.textAlignment = .center
        return lbl
    }()
    //channel
    private let channelContainerView : UIView = {
        let vieww = UIView()
        vieww.backgroundColor = .lightGray
        vieww.layer.cornerRadius = 12
        return vieww
    }()
    private let channelImgView : UIImageView = {
        let imgView = UIImageView()
        let img = UIImage(systemName: "person.3.fill")
        imgView.image = img
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleToFill
        return imgView
    }()
    private let channelLabel : UILabel = {
        let lbl = UILabel()
        lbl.text = "17"
        lbl.font = .systemFont(ofSize: 17, weight: .regular)
        lbl.textAlignment = .center
        return lbl
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
        viewModel.view = self
        viewModel.viewDidLoad()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewModel.viewDidLayoutSubviews()
    }

}

extension ProfileViewController : ProfileViewControllerInterface {
    func setCounts() {
        guard let counts = counts else { return}
        self.postLabel.text = counts[0]
        self.commentLabel.text = counts[1]
        self.channelLabel.text = counts[2]
    }
    
    func getCounts() {
        viewModel.getCounts(email: message.sender.senderId)
    }
    
    func setInfo() {
        guard let profileInfo = profileInfo else { return}
        self.usernameLabel.text = profileInfo.username
        self.usernameTextField.text = profileInfo.username
        self.emailTextField.text = profileInfo.email
        self.userEmailLabel.text = profileInfo.email
        self.profileImgView.sd_setImage(with: profileInfo.profileImgUrl)
        self.classTextField.text = profileInfo.grade
        let str = profileInfo.lessons!.joined(separator: ",")
        self.lessonTextField.text = str
    }
    
    func getUserInfo() {
        viewModel.getUserInfos(email: message.sender.senderId)
    }
    
    func configViews() {
        view.addSubview(profileImgView)
        view.addSubview(usernameLabel)
        view.addSubview(userEmailLabel)
        
        sendMessageView.addSubview(sendMessageImgView)
        sendMessageView.addSubview(sendMessageLabel)
        view.addSubview(sendMessageView)
        //post
        postContainerView.addSubview(postImgView)
        postContainerView.addSubview(postLabel)
        view.addSubview(postContainerView)
        //comment
        commentContainerView.addSubview(commentImgView)
        commentContainerView.addSubview(commentLabel)
        view.addSubview(commentContainerView)
        //channel
        channelContainerView.addSubview(channelImgView)
        channelContainerView.addSubview(channelLabel)
        view.addSubview(channelContainerView)
        //username
        usernameImageContainerView.addSubview(usernameTextFieldImgView)
        usernameContainerView.addSubview(usernameImageContainerView)
        usernameContainerView.addSubview(usernameTextField)
        view.addSubview(usernameContainerView)
        //email
        emailImageContainerView.addSubview(emailTextFieldImgView)
        emailContainerView.addSubview(emailImageContainerView)
        emailContainerView.addSubview(emailTextField)
        view.addSubview(emailContainerView)
        //lesson
        lessonImageContainerView.addSubview(lessonTextFieldImgView)
        lessonContainerView.addSubview(lessonImageContainerView)
        lessonContainerView.addSubview(lessonTextField)
        view.addSubview(lessonContainerView)
        
        //class
        classImageContainerView.addSubview(classTextFieldImgView)
        classContainerView.addSubview(classImageContainerView)
        classContainerView.addSubview(classTextField)
        view.addSubview(classContainerView)
    }
    
    func setFrames() {
        profileImgView.frame = CGRect(x: (view.width/2) - 100,
                                      y: view.safeAreaInsets.top + 20,
                                      width: 200,
                                      height: 200)
        usernameLabel.frame = CGRect(x: 0,
                                     y: profileImgView.bottom+10,
                                     width: view.width,
                                      height: 30)
        userEmailLabel.frame = CGRect(x: 0,
                                     y: usernameLabel.bottom,
                                     width: view.width,
                                      height: 30)
        sendMessageView.frame = CGRect(x: 10,
                                       y: userEmailLabel.bottom + 10,
                                       width: view.width-20,
                                      height: 50)
        sendMessageImgView.frame = CGRect(x: 10,
                                      y: 5,
                                      width: 40,
                                      height: 40)
        sendMessageLabel.frame = CGRect(x: sendMessageImgView.right + 5,
                                     y: 0,
                                      width: sendMessageView.width-50,
                                      height: 50)
        //post
        postContainerView.frame =  CGRect(x: 10,
                                          y: sendMessageView.bottom + 10,
                                          width: 50,
                                          height: 50)
        postImgView.frame = CGRect(x: 10,
                                          y: 0,
                                          width: 30,
                                          height: 30)
        postLabel.frame = CGRect(x: 0,
                                 y: postImgView.bottom,
                                 width: 50,
                                 height: 20)
        //comment
        commentContainerView.frame =  CGRect(x: postContainerView.right + 5,
                                          y: sendMessageView.bottom + 10,
                                          width: 50,
                                          height: 50)
        commentImgView.frame = CGRect(x: 10,
                                          y: 0,
                                          width: 30,
                                          height: 30)
        commentLabel.frame = CGRect(x: 0,
                                 y: commentImgView.bottom,
                                 width: 50,
                                 height: 20)
        //channel
        channelContainerView.frame =  CGRect(x: commentContainerView.right + 5,
                                          y: sendMessageView.bottom + 10,
                                          width: 50,
                                          height: 50)
        channelImgView.frame = CGRect(x: 7,
                                          y: 0,
                                          width: 35,
                                          height: 30)
        channelLabel.frame = CGRect(x: 0,
                                 y: channelImgView.bottom,
                                 width: 50,
                                 height: 20)
        //username
        usernameContainerView.frame = CGRect(x: 10,
                                          y: postContainerView.bottom + 10,
                                          width: view.width-20,
                                          height: 60)
        usernameImageContainerView.frame = CGRect(x: 5,
                                          y: 5,
                                          width: 50,
                                          height: 50)
        usernameTextFieldImgView.frame = CGRect(x: 10,
                                          y: 10,
                                          width: 30,
                                          height: 30)
        usernameTextField.frame = CGRect(x: usernameImageContainerView.right + 5,
                                          y: 5,
                                      width: usernameContainerView.width-70,
                                          height: 40)
        //Email
        emailContainerView.frame = CGRect(x: 10,
                                          y: usernameContainerView.bottom + 5,
                                          width: view.width-20,
                                          height: 60)
        emailImageContainerView.frame = CGRect(x: 5,
                                          y: 5,
                                          width: 50,
                                          height: 50)
        emailTextFieldImgView.frame = CGRect(x: 10,
                                          y: 10,
                                          width: 30,
                                          height: 30)
        emailTextField.frame = CGRect(x: emailImageContainerView.right + 5,
                                          y: 5,
                                      width: emailContainerView.width-70,
                                          height: 40)
        
        
        //lesson
        lessonContainerView.frame = CGRect(x: 10,
                                          y: emailContainerView.bottom + 5,
                                          width: view.width-20,
                                          height: 60)
        lessonImageContainerView.frame = CGRect(x: 5,
                                          y: 5,
                                          width: 50,
                                          height: 50)
        lessonTextFieldImgView.frame = CGRect(x: 10,
                                          y: 10,
                                          width: 30,
                                          height: 30)
        lessonTextField.frame = CGRect(x: lessonImageContainerView.right + 5,
                                          y: 5,
                                      width: lessonContainerView.width-70,
                                          height: 40)
        
        //class
        classContainerView.frame = CGRect(x: 10,
                                          y: lessonContainerView.bottom + 5,
                                          width: view.width-20,
                                          height: 60)
        classImageContainerView.frame = CGRect(x: 5,
                                          y: 5,
                                          width: 50,
                                          height: 50)
        classTextFieldImgView.frame = CGRect(x: 10,
                                          y: 10,
                                          width: 30,
                                          height: 30)
        classTextField.frame = CGRect(x: classImageContainerView.right + 5,
                                          y: 5,
                                      width: classContainerView.width-70,
                                          height: 40)
    }
    
    
}
