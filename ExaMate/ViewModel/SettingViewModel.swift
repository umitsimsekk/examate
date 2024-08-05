//
//  SettingViewModel.swift
//  ExaMate
//
//  Created by Ümit Şimşek on 2.04.2024.
//

import UIKit
import SDWebImage
struct ProfileInfo {
    var email: String
    var password: String
    var username: String
    var profilePhoto: UIImage?
    var grade: String?
    var lesson: [String]?
    
}
protocol SettingViewModelInterface{
    var view : SettingViewControllerInterface?{get set}
    var database : DatabaseManagerProtocol{get}
    var auth : AuthManagerProtocol{get}
    var storage : StorageManagerProtocol{get}
    func viewDidLoad()
    func viewDidLayoutSubviews()
    func insertProfileInfo(profile: Profile, data: Data)
    func signOut()
}

class SettingViewModel {
    weak var view: SettingViewControllerInterface?
    var database: DatabaseManagerProtocol = DatabaseManager()
    var auth: AuthManagerProtocol = AuthManager()
    var storage: StorageManagerProtocol = StorageManager()
    
}

extension SettingViewModel : SettingViewModelInterface {
    func signOut(){
        auth.logOut()
    }
    func insertProfileInfo(profile: Profile, data: Data) {
        storage.uploadSettingsProfileImage(sender_email: profile.email, imageData: data) { uploaded in
            if uploaded {
                self.storage.downloadSettingsProfileImageUrl(sender_email: profile.email) { url in
                    guard let imgUrl = url else {
                        print("download error")
                        return
                    }
                    var profilee = profile
                    profilee.profileImgUrl = imgUrl
                    self.database.insertProfileInfo(profile: profilee) { success in
                        if success {
                            self.view?.showAlert(title: "Success", message: "profile info successfuly inserted")
                        } else {
                            self.view?.showAlert(title: "Success", message: "profile info error!")
                        }
                    }
                }
            }
        }
    }
    
    func getUserInfo() {
        guard let email = auth.getCurrentUserEmail() as? String else {
            return
        }
        var profile = ProfileInfo(email: "", password: "", username: "", profilePhoto: nil, grade: nil, lesson: nil)
        database.getUserInfo(email: email) { result in
            switch result {
            case .success(let user):
                profile.email = user.email
                profile.password = user.password
                profile.username = user.username
                self.view?.configure(profileInfo: profile)
                self.database.getUserProfileInfo(email: email) { result in
                    switch result {
                    case .success(let profileInfo):
                        self.view?.profileImgView.sd_setImage(with: profileInfo.profileImgUrl)
                        profile.grade = profileInfo.grade
                        profile.lesson = profileInfo.lessons
                        self.view?.configure(profileInfo: profile)
                    case.failure(let error):
                        print(error)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    func viewDidLoad() {
        view?.addButton()
        view?.configView()
        view?.fetchUserInfo()
        view?.listenForNofications()
    }
    
    func viewDidLayoutSubviews() {
        view?.setFrames()
    }
    
    
}
