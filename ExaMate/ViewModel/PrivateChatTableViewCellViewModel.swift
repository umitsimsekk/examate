//
//  PrivateChatTableViewCellViewModel.swift
//  ExaMate
//
//  Created by Ümit Şimşek on 30.07.2024.
//

import Foundation
import UIKit

protocol PrivateChatTableViewCellViewModelInterface {
    var view : PrivateChatTableViewCell?{ get set}
    var database : DatabaseManagerProtocol{get}
    
    func getUserProfilePhoto(email: String)

    
    func viewDidLoad()
    func layoutSubviews()
    
}

class PrivateChatTableViewCellViewModel {
    weak var view : PrivateChatTableViewCell?
    var database : DatabaseManagerProtocol = DatabaseManager()
}

extension PrivateChatTableViewCellViewModel : PrivateChatTableViewCellViewModelInterface {
    func viewDidLoad() {
        view?.configViews()
    }
    
    func layoutSubviews() {
        view?.layoutSubview()
    }
    
    
    func getUserProfilePhoto(email: String) {
        database.getUserProfilePhoto(email: email) { url in
            guard let imgUrl = url else {return}
            self.view?.setProfilePhoto(url: imgUrl)
        }
    }

}
