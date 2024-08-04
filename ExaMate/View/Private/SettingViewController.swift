//
//  SettingViewController.swift
//  ExaMate
//
//  Created by Ümit Şimşek on 2.04.2024.
//

import UIKit
protocol SettingViewControllerInterface : AnyObject {
    var profileImgView : UIImageView{get set}
    func setFrames()
    func addButton()
    func configView()
    func listenForNofications()
    func fetchUserInfo()
    func configure(profileInfo profile: ProfileInfo)
    func showAlert(title: String, message: String)
}
class SettingViewController: UIViewController {
    lazy var viewModel = SettingViewModel()
    private var userEmail : String
    private var favoriteLessons = [String]()
    init(userEmail: String) {
        self.userEmail = userEmail
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var profileImgView : UIImageView = {
       let imgView = UIImageView()
        let img = UIImage(named: "logo")
        imgView.image = img
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 100
        return imgView
    }()
    private let userEmailLabel : UILabel = {
       let lbl = UILabel()
        lbl.text = "abc@gmail.com"
        lbl.font = .systemFont(ofSize: 22, weight: .medium)
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
    
    //password
    private let passwordContainerView : UIView = {
       let vieww = UIView()
        vieww.backgroundColor = .systemGray6
        vieww.layer.cornerRadius = 12
        return vieww
    }()
    private let passwordImageContainerView : UIView = {
       let vieww = UIView()
        vieww.backgroundColor = .systemMint
        vieww.layer.cornerRadius = 12
        return vieww
    }()
    private let passwordTextFieldImgView : UIImageView = {
       let imgView = UIImageView()
        let img = UIImage(systemName: "lock.fill")
        imgView.image = img
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleToFill
        return imgView
    }()
    private let passwordTextField : UITextField = {
       let txtField = UITextField()
        txtField.isEnabled = false
        txtField.placeholder = "Password"
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
    
    private let signOutButton : UIButton = {
        let button = UIButton()
        button.setTitle("Çıkış", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .red
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 12
        return button
    }()
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
extension SettingViewController {
    func configure(profileInfo profile: ProfileInfo) {
        self.usernameTextField.text = profile.username
        self.passwordTextField.text = profile.password
        self.emailTextField.text    = profile.email
        self.userEmailLabel.text    = profile.email
        self.classTextField.text    = profile.grade
        guard let lesson = profile.lesson, let str = lesson.joined(separator: ",") as? String else {
            return 
        }
        self.lessonTextField.text = str
    }
    
   
    func listenForNofications() {
        NotificationCenter.default.addObserver(self, selector: #selector(lessonNotifHandler(_:)), name: NSNotification.Name("notificationLesson"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(classNotifHandler(_:)), name: NSNotification.Name("notificationClass"), object: nil)
    }
    @objc func lessonNotifHandler(_ notification : NSNotification) {
        if let dict = notification.userInfo as? NSDictionary {
            if let lessons = dict["lessons"] as? [String] {
                let str = lessons.joined(separator: ",")
                lessonTextField.text = str
                self.favoriteLessons = lessons
            }
        }
    }
    
    @objc func classNotifHandler(_ notification : NSNotification) {
        if let dict = notification.userInfo as? NSDictionary {
            if let classs = dict["class"] as? String {
                self.classTextField.text = classs
            }
        }
    }
    @objc func didTapClass(){
        let vc = SettingClassViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func didTapLesson(){
        let vc = SettingLessonViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    @objc func didTapSignOut(){
        
    }
    @objc func didTapProfilePhoto(){
        let actionSheet = UIAlertController(title: "Attach photo", message: "Where would you like to attach a photo from", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.allowsEditing = true
            picker.delegate = self
            self?.present(picker, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] _ in
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            picker.delegate = self
            self?.present(picker, animated: true)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil ))
        self.present(actionSheet, animated: true)
    }
    @objc func didTapUpdateButton(){
        guard let profileImage = profileImgView.image,
              let imageData = profileImage.pngData(),
              let username = usernameTextField.text, !username.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            self.showAlert(title: "Error!", message: "Please fill all boxes to update profile info..")
            return
        }
        guard let lessons = favoriteLessons as? [String], !lessons.isEmpty,
              let grade = classTextField.text, !grade.isEmpty else {
            self.showAlert(title: "Error!", message: "Nothing changed")
            return
        }
        let profile = Profile(profileImgUrl: URL(filePath: ""), username: username, email: email, password: password, lessons: lessons, grade: grade)
        self.viewModel.insertProfileInfo(profile: profile, data: imageData)
        
    }
}
extension SettingViewController : SettingViewControllerInterface {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let act = UIAlertAction(title: "OK!", style: .cancel)
        alert.addAction(act)
        present(alert, animated: true)
    }
    func fetchUserInfo() {
        viewModel.getUserInfo()
    }
    
    func configView(){
        view.addSubview(profileImgView)
        view.addSubview(userEmailLabel)
        
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

        //password
        passwordImageContainerView.addSubview(passwordTextFieldImgView)
        passwordContainerView.addSubview(passwordImageContainerView)
        passwordContainerView.addSubview(passwordTextField)
        view.addSubview(passwordContainerView)
        
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
        
        // signOut
        
        view.addSubview(signOutButton)
    }
    func addButton() {
        lessonTextField.addTarget(self, action: #selector(didTapLesson), for: .touchDown)
        classTextField.addTarget(self, action: #selector(didTapClass), for: .touchDown)
        signOutButton.addTarget(self, action: #selector(didTapSignOut), for: .allTouchEvents)
        
        profileImgView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapProfilePhoto))
        profileImgView.addGestureRecognizer(gestureRecognizer)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Güncelle", style: .done, target: self, action: #selector(didTapUpdateButton))
    }
    
    func setFrames() {
        profileImgView.frame = CGRect(x: (view.width/2) - 100,
                                      y: view.safeAreaInsets.top + 20,
                                      width: 200,
                                      height: 200)
        userEmailLabel.frame = CGRect(x: 0,
                                     y: profileImgView.bottom+10,
                                     width: view.width,
                                      height: 30)
        //username
        usernameContainerView.frame = CGRect(x: 10,
                                          y: userEmailLabel.bottom + 10,
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
        
        //password
        passwordContainerView.frame = CGRect(x: 10,
                                          y: emailContainerView.bottom + 5,
                                          width: view.width-20,
                                          height: 60)
        passwordImageContainerView.frame = CGRect(x: 5,
                                          y: 5,
                                          width: 50,
                                          height: 50)
        passwordTextFieldImgView.frame = CGRect(x: 10,
                                          y: 10,
                                          width: 30,
                                          height: 30)
        passwordTextField.frame = CGRect(x: passwordImageContainerView.right + 5,
                                          y: 5,
                                      width: passwordContainerView.width-70,
                                          height: 40)
        
        //lesson
        lessonContainerView.frame = CGRect(x: 10,
                                          y: passwordContainerView.bottom + 5,
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
        
        //Sign Out
        
        signOutButton.frame = CGRect(x: 10,
                                     y: classContainerView.bottom+5,
                                     width: view.width-20,
                                     height: 60)
    }
}
extension SettingViewController : UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        self.profileImgView.image = image
        dismiss(animated: true)
    }
}
