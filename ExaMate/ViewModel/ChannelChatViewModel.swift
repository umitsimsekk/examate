//
//  ChannelChatViewModel.swift
//  ExaMate
//
//  Created by Ümit Şimşek on 1.05.2024.
//

import Foundation
import MessageKit
extension MessageKind {
    var messsageKindString : String {
        switch self {
            
        case .text(_):
            return "text"
        case .attributedText(_):
            return "attributed_text"
        case .photo(_):
            return "photo"
        case .video(_):
            return "video"
        case .location(_):
            return "location"
        case .emoji(_):
            return "emoji"
        case .audio(_):
            return "audio"
        case .contact(_):
            return "contact"
        case .linkPreview(_):
            return "link_preview"
        case .custom(_):
            return "custom"
        }
    }
}
struct Message : MessageType {
    var sender: MessageKit.SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKit.MessageKind
}
struct Sender : SenderType {
    var senderId: String
    var displayName: String
}
struct Media: MediaItem {
    var url: URL?
    var image: UIImage?
    var placeholderImage: UIImage
    var size: CGSize
}
protocol ChannelChatViewModelInterface{
    var view : ChannelChatViewControllerInterface? {get set}
    var database : DatabaseManagerProtocol{get}
    var auth : AuthManagerProtocol{get}
    func viewDidLoad()
    func viewDidLayoutSubviews()
    func viewWillAppear()
    func sendMessage(to channelName : String, model : Message)
    func fetchChannelMessage(channelName: String)
    func getUserProfilePic(with email : String)
}

class ChannelChatViewModel {
    weak var view: ChannelChatViewControllerInterface?
    var auth: AuthManagerProtocol = AuthManager()
    var database: DatabaseManagerProtocol = DatabaseManager()
}


extension ChannelChatViewModel : ChannelChatViewModelInterface {
    func getUserProfilePic(with email: String){
        database.getUserProfilePhoto(email: email) { [weak self] url in
            let imgView = UIImageView()
            guard let imgUrl = url else { return}
            imgView.sd_setImage(with: imgUrl)
            guard let avatar = Avatar(image: imgView.image) as? Avatar else {return }
            self?.view?.avatar = avatar
        }
    }
    
 
    func fetchChannelMessage(channelName: String) {
        database.getAllMessagesByChannelName(channelName: channelName) {[weak self] result in
            switch result {
            case .success(let messages):
                self?.view?.getMessages(messages: messages)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func sendMessage(to channelName : String, model : Message) {
        guard let email = auth.getCurrentUserEmail() as? String else {
            return
        }
        database.getUsername(email: email) { [weak self] username in
            if let username = username as? String {
                self?.database.sendMessage(to: channelName, username:username, model: model) {  success in
                    if success {
                        self?.view?.showAlert(titleInput: "Sucess!" , messageInput: "Message successfuly sended")
                    } else {
                        self?.view?.showAlert(titleInput: "Error!", messageInput: "Message not sended")
                    }
                }
            }
        }
        
    }
    
   
    func createSender() {
        if let email = auth.getCurrentUserEmail() as? String {
            let sender = Sender(senderId: email, displayName: "Me")
            view?.sender = sender
        }
    }

    func viewDidLoad() {
        view?.setCollectionViewDelegates()
        createSender()
    }
    
    func viewDidLayoutSubviews() {
        
    }
    
    func viewWillAppear() {
        
    }
    
    
}
