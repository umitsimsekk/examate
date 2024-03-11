//
//  PostViewController.swift
//  ExaMate
//
//  Created by Ümit Şimşek on 6.04.2024.
//

import UIKit

protocol PostViewControllerInterface : AnyObject {
    var img : UIImage? {get set }
    func showAlert(title: String, message: String, action: Bool)
    func setFrame()
    
   func barButtons()
   func configureViews()
   func addTargets()
   func handleOutputs()

}
class PostViewController: UIViewController {
    var img: UIImage?
    
    private lazy var viewModel = PostViewModel()
    private let containerView : UIView = {
       let vieww = UIView()
        vieww.layer.cornerRadius = 12
        vieww.backgroundColor = .systemGray6
        
        return vieww
    }()
    private let questionTextView : UITextView = {
       let textView = UITextView()
        textView.text = "Sorunuz"
        textView.clipsToBounds = true
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
        textView.layer.cornerRadius = 12
        textView.backgroundColor = .systemGray4
        textView.font = .systemFont(ofSize: 16)

        return textView
    }()
    private let lessonTextField : UITextField = {
       let txtField = UITextField()
        txtField.placeholder = "Ders Seçiniz"
        txtField.clipsToBounds = true
        txtField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        txtField.leftViewMode = .always
        txtField.backgroundColor = .systemGray4
        txtField.layer.cornerRadius = 12
        txtField.autocorrectionType = .no
        txtField.autocapitalizationType = .none
        
        return txtField
    }()
    private let answerTextField : UITextField = {
       let txtField = UITextField()
        txtField.placeholder = "Doğru Şıkkı Seçiniz"
        txtField.clipsToBounds = true
        txtField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        txtField.leftViewMode = .always
        txtField.backgroundColor = .systemGray4
        txtField.layer.cornerRadius = 12
        txtField.autocorrectionType = .no
        txtField.autocapitalizationType = .none

        return txtField
    }()
    private let pictureTextField : UITextField = {
       let txtField = UITextField()
        txtField.placeholder = "Fotoğraf Seçiniz"
        txtField.clipsToBounds = true
        txtField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        txtField.leftViewMode = .always
        txtField.backgroundColor = .systemGray4
        txtField.layer.cornerRadius = 12
        txtField.autocorrectionType = .no
        txtField.autocapitalizationType = .none

        return txtField
    }()
 
    private let pictureView : UIView = {
       let vieww = UIView()
        vieww.layer.cornerRadius = 12
        vieww.backgroundColor = .systemGray4
        vieww.isHidden = true
        return vieww
    }()
    private let pictureImgView : UIImageView = {
       let imgView = UIImageView()
        let img = UIImage(systemName: "photo")
        imgView.image = img
        imgView.clipsToBounds = true
        imgView.isHidden = true
        imgView.contentMode = .scaleAspectFill
        imgView.layer.cornerRadius = 12
        return imgView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        // Do any additional setup after loading the view.
        
        navigationItem.largeTitleDisplayMode = .always
        title = "Soru Paylaş"
        viewModel.view = self
        viewModel.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewModel.viewDidLayoutSubviews()
    }
    
}
extension PostViewController {
    @objc func didTapLesson(){
        let vc = LessonViewController()
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.present(vc, animated: true)
    }
    @objc func didTapAnswer(){
        let vc = AnswerViewController()
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.present(vc, animated: true)
    }
    @objc func didTapPicture(){
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    @objc func didTapBackButton(){
        dismiss(animated: true)
    }
    @objc func didTapSaveButton(){
        guard let question  = questionTextView.text, !question.isEmpty,
              let lesson = lessonTextField.text, !lesson.isEmpty,
              let answer = answerTextField.text, !answer.isEmpty,
              let img = pictureImgView.image else {
            self.showAlert(title: "Error!", message: "Fill in all information to share post",action: false)
            return
        }
        let postId = UUID().uuidString
        let post = Post(postedBy: "", postId: postId, question: question, lesson: lesson, answer: answer,imgUrl: nil,timestamp: Date().timeIntervalSince1970)
        viewModel.sharePost(post: post, img: img)
    }
    func barButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: self, action: #selector(didTapBackButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapSaveButton))
        navigationController?.navigationBar.tintColor = .label
    }
    @objc func answerNotifHandler(_ notification : NSNotification) {
        if let dict = notification.userInfo as? NSDictionary {
            if let answer = dict["answer"] as? String {
                self.answerTextField.text = answer
            }
        }
    }
    @objc func lessonNotifHandler(_ notification : NSNotification) {
        if let dict = notification.userInfo as? NSDictionary {
            if let lesson = dict["lesson"] as? String {
                self.lessonTextField.text = lesson
            }
        }
    }
    }
extension PostViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        self.pictureImgView.image = image
        self.pictureImgView.isHidden = false
        self.pictureView.isHidden = false
        self.pictureTextField.text = "Soru başarılı bir şekilde yüklendi"
        self.pictureTextField.textColor = .systemGreen
        dismiss(animated: true)
    }
}

extension PostViewController : PostViewControllerInterface {
    func setFrame() {
        containerView.frame = CGRect(x: 10,
                                     y: view.safeAreaInsets.top+20,
                                     width: view.width-20,
                                     height: 350)
        questionTextView.frame = CGRect(x: 10,
                                        y: 10,
                                     width: containerView.width-20,
                                     height: 70)
        lessonTextField.frame = CGRect(x: 10,
                                       y:questionTextView.bottom+10,
                                     width: containerView.width-20,
                                     height: 50)
        answerTextField.frame = CGRect(x: 10,
                                       y:lessonTextField.bottom+10,
                                     width: containerView.width-20,
                                     height: 50)
        pictureTextField.frame = CGRect(x: 10,
                                       y:answerTextField.bottom+10,
                                     width: containerView.width-20,
                                     height: 50)
        
        pictureView.frame = CGRect(x: 40,
                                   y: view.height/2-20,
                                   width: view.width-80,
                                   height: 200)
        pictureImgView.frame = CGRect(x: 10,
                                   y: 10,
                                      width: pictureView.width-20,
                                   height: 180)
    }
    
    func showAlert(title: String, message: String, action: Bool) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let act : UIAlertAction
        if action {
            act = UIAlertAction(title: "Main page", style: .cancel, handler: { _ in
                self.dismiss(animated: true)
            })
        } else {
           act = UIAlertAction(title: "OK!", style: .cancel)

        }
        alert.addAction(act)
        present(alert, animated: true)
    }
    func configureViews(){
        containerView.addSubview(questionTextView)
        containerView.addSubview(lessonTextField)
        containerView.addSubview(answerTextField)
        containerView.addSubview(pictureTextField)

        view.addSubview(containerView)
        
        pictureView.addSubview(pictureImgView)
        view.addSubview(pictureView)
    }
    func addTargets() {
        self.lessonTextField.addTarget(self, action: #selector(didTapLesson), for: .touchDown)
        self.answerTextField.addTarget(self, action: #selector(didTapAnswer), for: .touchDown)
        self.pictureTextField.addTarget(self, action: #selector(didTapPicture), for: .touchDown)
    }
    func handleOutputs() {
        NotificationCenter.default.addObserver(self, selector: #selector(answerNotifHandler(_:)), name: NSNotification.Name("notificationAnswer"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(lessonNotifHandler(_:)), name: NSNotification.Name("notificationLesson"), object: nil)
    }

}
