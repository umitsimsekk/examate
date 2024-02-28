//
//  LoginViewController.swift
//  ExaMate
//
//  Created by Ümit Şimşek on 25.02.2024.
//

import UIKit

import FirebaseAuth
protocol LoginViewControllerInterface : AnyObject {
    func didTapSignUpButton()
    func didTapLoginButton()
    func configViews()
    func addTarget()
    func setFrames()
}
class LoginViewController: UIViewController{
    var user: User?
    
   lazy var viewModel = LoginViewModel()
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
        lbl.text = "Log In"
        lbl.textColor = .label
        lbl.textAlignment = .center
        lbl.font = .systemFont(ofSize: 20, weight: .medium)
        return lbl
    }()
    private let secondaryLoginLabel : UILabel = {
       let lbl = UILabel()
        lbl.text = "Fill in your information to log in.."
        lbl.textAlignment = .center
        lbl.textColor = .secondaryLabel
        return lbl
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
    private let passwordLabel : UILabel = {
       let lbl = UILabel()
        lbl.text = "Forgot password?"
        lbl.textColor = .secondaryLabel
        lbl.textAlignment = .right
        lbl.font = .systemFont(ofSize: 16)
        return lbl
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
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground

        viewModel.view = self
        viewModel.viewDidLoad()
        
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        viewModel.viewDidLayoutSubviews()
    }
}
extension LoginViewController {
    
    func showAlert(title : String, message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK!", style: .cancel)
        alert.addAction(action)
        present(alert, animated: true)
        
    }
    
}
extension LoginViewController : LoginViewControllerInterface {
    func setFrames(){
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
        emailTextField.frame = CGRect(x: 30,
                                      y: secondaryLoginLabel.bottom+20,
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
        passwordLabel.frame = CGRect(x: 30,
                                     y: passwordTextField.bottom+10,
                                     width: view.width-60,
                                     height: 40)
        
        signUpButton.frame = CGRect(x: 30,
                                    y: passwordLabel.bottom+10,
                                    width: (view.width-60)/2-3,
                                    height: 50)
        loginButton.frame = CGRect(x: signUpButton.right+7,
                                    y: passwordLabel.bottom+10,
                                    width: (view.width-60)/2-3,
                                    height: 50)
    }
    func configViews(){
        view.addSubview(logoImgView)
        view.addSubview(loginLabel)
        view.addSubview(secondaryLoginLabel)
        
        emailTextField.addSubview(emailTextFieldImgView)
        view.addSubview(emailTextField)
        
        passwordTextField.addSubview(passwordTextFieldKeyImgView)
        passwordTextField.addSubview(passwordTextFieldEyeImgView)
        view.addSubview(passwordTextField)
        
        view.addSubview(passwordLabel)
        view.addSubview(loginButton)
        view.addSubview(signUpButton)


    }
    func addTarget() {
        signUpButton.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
    }
    @objc func didTapSignUpButton() {
       
    }
    @objc func didTapLoginButton() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            self.showAlert(title: "Error!", message: "Fill in your information to sign in")
            return
        }
        user = User(username: "", email: email, password: password)
        viewModel.login(user: user!)
    }
    
}
