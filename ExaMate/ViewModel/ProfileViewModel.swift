//
//  ProfileViewModel.swift
//  ExaMate
//
//  Created by Ümit Şimşek on 8.05.2024.
//

import Foundation
struct profileInfo {
    var profileImgUrl : URL?
    var username : String
    var email : String
    var lessons : [String]?
    var grade : String?

}
protocol ProfileViewModelInterface {
    var view : ProfileViewControllerInterface? {get set}
    var database : DatabaseManagerProtocol{get}
    func viewDidLayoutSubviews()
    func viewDidLoad()
    func getUserInfos(email: String)
}


class ProfileViewModel {
    weak var view: ProfileViewControllerInterface?
    var database: DatabaseManagerProtocol = DatabaseManager()
}

extension ProfileViewModel : ProfileViewModelInterface {
    func getCounts(email: String){
        var counts = [String]()
        database.getUserPostCountForProfile(email: email) {[weak self] count in
            print(count)
            counts.append(String(count))
            self?.database.getUserCommentCountForProfile(email: email) { count in
                counts.append(String(count))
                self?.database.getUserChannelCountForProfile(email: email) { count in
                    counts.append(String(count))
                    self?.view?.counts = counts
                    self?.view?.setCounts()
                }

            }
        }
    }
    func getUserInfos(email: String) {
        database.getUserInfo(email: email) {[weak self] result in
            var profileInfo = profileInfo(profileImgUrl: nil, username: "", email: "", lessons: ["String"], grade: "")

            switch result {
            case .success(let user):
                profileInfo.username = user.username
                profileInfo.email = user.email
                self?.database.getUserProfileInfo(email: email) { results in
                    switch results {
                    case .success(let profile):
                        profileInfo.grade = profile.grade
                        profileInfo.profileImgUrl = profile.profileImgUrl
                        profileInfo.lessons = profile.lessons
                        self?.view?.profileInfo = profileInfo
                        self?.view?.setInfo()
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    func viewDidLoad() {
        view?.configViews()
        view?.getUserInfo()
        view?.getCounts()
    }
    
    func viewDidLayoutSubviews() {
        view?.setFrames()
    }
}
