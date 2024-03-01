//
//  SignupViewController.swift
//  ExamMate
//
//  Created by Ümit Şimşek on 16.09.2023.
//

import UIKit

protocol SignupViewControllerInterface : AnyObject {
    func setFrames()
    func configViews()
    func showAlert(title : String, message : String)
    func didTapLoginButton()
    func didTapSignUpButton()
    func addTarget()

}

class SignupViewController: UIViewController {
    var user: User?

    let viewModel = SignupViewModel()
   
    private let logoImgView : UIImageView = {
       let imgView = UIImageView()
        let img = UIImage(named: "logo")
        imgView.backgroundColor = .blue
        imgView.image = img
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        return imgView
    }()
    
    private let loginLabel : UILabel = {
       let lbl = UILabel()
        lbl.text = "Sign Up"
        lbl.textColor = .label
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 20, weight: .medium)
        return lbl
    }()
    private let secondaryLoginLabel : UILabel = {
       let lbl = UILabel()
        lbl.text = "Fill in your information to sign up.."
        lbl.textAlignment = .center
        lbl.textColor = .secondaryLabel
        return lbl
    }()
    private let usernameTextFieldImgView : UIImageView = {
        let imgView = UIImageView()
         let img = UIImage(systemName: "person")
         imgView.tintColor = .systemGray4
         imgView.image = img
         imgView.clipsToBounds = true
         imgView.contentMode = .scaleToFill
         return imgView
    }()
    
    private let usernameTextField : UITextField = {
        let txtField = UITextField()
         txtField.placeholder = "Username"
         txtField.clipsToBounds = true
         txtField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 50))
         txtField.leftViewMode = .always
         
         txtField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
         txtField.rightViewMode = .always
         
         txtField.layer.cornerRadius = 4
         txtField.backgroundColor = .systemGray6
         
         txtField.autocorrectionType = .no
         txtField.autocapitalizationType = .none
         
         txtField.textContentType = .emailAddress
         return txtField
    }()
    private let emailTextFieldImgView : UIImageView = {
       let imgView = UIImageView()
        let img = UIImage(systemName: "envelope")
        imgView.tintColor = .systemGray4
        imgView.image = img
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleToFill
        return imgView
    }()
    private let emailTextField : UITextField = {
       let txtField = UITextField()
        txtField.placeholder = "Email address"
        txtField.clipsToBounds = true
        txtField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 50))
        txtField.leftViewMode = .always
        
        txtField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        txtField.rightViewMode = .always
        
        txtField.layer.cornerRadius = 4
        txtField.backgroundColor = .systemGray6
        
        txtField.autocorrectionType = .no
        txtField.autocapitalizationType = .none
        
        txtField.textContentType = .emailAddress
        return txtField
    }()
    private let passwordTextFieldKeyImgView : UIImageView = {
       let imgView = UIImageView()
        let img = UIImage(systemName: "lock")
        imgView.tintColor = .systemGray4
        imgView.image = img
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleToFill
        return imgView
    }()
    private let passwordTextFieldEyeImgView : UIImageView = {
       let imgView = UIImageView()
        let img = UIImage(systemName: "eye")
        imgView.tintColor = .systemGray4
        imgView.image = img
        imgView.clipsToBounds = true
        imgView.contentMode = .scaleToFill
        return imgView
    }()
    private let passwordTextField : UITextField = {
       let txtField = UITextField()
        txtField.placeholder = "Password"
        txtField.clipsToBounds = true
        txtField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 50))
        txtField.leftViewMode = .always
        
        txtField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        txtField.rightViewMode = .always
        
        txtField.layer.cornerRadius = 4
        txtField.backgroundColor = .systemGray6
        
        txtField.autocorrectionType = .no
        txtField.autocapitalizationType = .none
        
        txtField.isSecureTextEntry = true
        txtField.textContentType = .password
        
        return txtField
    }()
    private let signUpButton : UIButton = {
        let btn = UIButton()
        btn.setTitle("Sign Up", for: .normal)
        btn.backgroundColor = .systemPink
        btn.layer.cornerRadius = 4
        btn.setTitleColor(.label, for: .normal)
        return btn
    }()
    private let loginButton : UIButton = {
        let btn = UIButton()
        btn.setTitle("Log In", for: .normal)
        btn.backgroundColor = .systemPink
        btn.layer.cornerRadius = 4
        btn.setTitleColor(.label, for: .normal)
        return btn
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

extension SignupViewController : SignupViewControllerInterface{
    func addTarget() {
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
    }
    @objc func didTapSignUpButton() {
        guard let username = usernameTextField.text, !username.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty, password.count >= 6 
        
        else {
            self.showAlert(title: "Error!", message: "Fill in your information to sign up")
            return
        }
        user = User(username: username, email: email, password: password)
        viewModel.signup(user: user!)
    }
    @objc func didTapLoginButton() {
        dismiss(animated: true)
        
    }
    func showAlert(title : String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK!", style: .cancel)
        alert.addAction(action)
        present(alert, animated: true)
        
    }
    func configViews(){
        view.addSubview(logoImgView)
        view.addSubview(loginLabel)
        view.addSubview(secondaryLoginLabel)
        
        usernameTextField.addSubview(usernameTextFieldImgView)
        view.addSubview(usernameTextField)
        
        emailTextField.addSubview(emailTextFieldImgView)
        view.addSubview(emailTextField)
        
        passwordTextField.addSubview(passwordTextFieldKeyImgView)
        passwordTextField.addSubview(passwordTextFieldEyeImgView)
        view.addSubview(passwordTextField)
        
        view.addSubview(loginButton)
        view.addSubview(signUpButton)

    }
    
    func setFrames() {
        
        let logoWidth : CGFloat = 200
        logoImgView.frame = CGRect(x: 10,
                                   y: view.safeAreaInsets.top+20,
                                   width: view.width-20,
                                   height: logoWidth)
        loginLabel.frame = CGRect(x: 0,
                                 y: logoImgView.bottom+50,
                                 width: view.width,
                                   height: 35)
        secondaryLoginLabel.frame = CGRect(x: 0,
                                 y: loginLabel.bottom,
                                 width: view.width,
                                   height: 40)
        usernameTextField.frame = CGRect(x: 30,
                                      y: secondaryLoginLabel.bottom+20,
                                      width: view.width-60,
                                      height: 50)
        usernameTextFieldImgView.frame = CGRect(x: 10,
                                             y: 10,
                                             width: 35,
                                             height: 30)
        emailTextField.frame = CGRect(x: 30,
                                      y: usernameTextField.bottom+20,
                                      width: view.width-60,
                                      height: 50)
        emailTextFieldImgView.frame = CGRect(x: 10,
                                             y: 10,
                                             width: 35,
                                             height: 30)
        passwordTextField.frame = CGRect(x: 30,
                                      y: emailTextField.bottom+15,
                                      width: view.width-60,
                                      height: 50)
        passwordTextFieldKeyImgView.frame = CGRect(x: 10,
                                             y: 10,
                                             width: 30,
                                             height: 30)
        passwordTextFieldEyeImgView.frame = CGRect(x: passwordTextField.width - 45,
                                                   y: 18,
                                                   width: 28,
                                                   height: 18)
       
        
        signUpButton.frame = CGRect(x: 30,
                                    y: passwordTextField.bottom+20,
                                    width: (view.width-60)/2-3,
                                    height: 50)
        loginButton.frame = CGRect(x: signUpButton.right+7,
                                    y: passwordTextField.bottom+20,
                                    width: (view.width-60)/2-3,
                                    height: 50)
    }

}


