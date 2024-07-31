//
//  PrivateChatViewModel.swift
//  ExaMate
//
//  Created by Ümit Şimşek on 28.07.2024.
//

import Foundation
import MessageKit
protocol PrivateChatViewModelInterface {
    var view : PrivateChatViewControllerInterface?{ get set}
    var database : DatabaseManagerProtocol{get}
    var auth : AuthManagerProtocol{get}
    var storage: StorageManagerProtocol{ get}
    
    func sender() -> Sender?
    func viewDidLayoutSubviews()
    func viewDidLoad()
    
    func createNewConversation(with email: String, message: Message, senderUsername: String )
    func listenForMessage(senderEmail: String, otherEmail: String)
    func sendMessage(sender: Sender,senderEmail: String,imageData: Data,otherEmail:String)
}
class PrivateChatViewModel {
    weak var view : PrivateChatViewControllerInterface?
    var database : DatabaseManagerProtocol = DatabaseManager()
    var auth: AuthManagerProtocol = AuthManager()
    var storage: StorageManagerProtocol = StorageManager()
}

extension PrivateChatViewModel : PrivateChatViewModelInterface {

    func sendMessage(sender: Sender,senderEmail: String,imageData: Data,otherEmail:String){
        let uuid = UUID().uuidString
        storage.uploadPrivateMessageImage(sender_email: senderEmail, messageId: uuid, imageData: imageData) { [weak self] uploaded in
            if uploaded {
                self?.storage.downloadPrivateMessageImageUrl(sender_email: senderEmail, messageId: uuid) { url in
                    guard url != nil else {
                        return
                    }
                    self?.database.getUsername(email: otherEmail) { username in
                        let placeHolder = UIImage(systemName: "plus")
                        let media = Media(url: url,placeholderImage: placeHolder!, size: CGSize(width: 36, height: 36))
                        let message = Message(sender:sender, messageId: uuid, sentDate: Date(), kind: .photo(media))
                        self?.database.createNewConversation(with: otherEmail, firstMessage: message, username: username, completion: { success in
                            if success {
                                print("pic successfuly arrived")
                            } else {
                                print("pic error")

                            }
                        })
                    }
                }
            }
            
        }
        
    }
    func listenForMessage(senderEmail: String, otherEmail: String) {
        database.getAllMessagesForConversation(sender_email: senderEmail, other_email: otherEmail) { [weak self] result in
            switch result {
            case .success(let message):
                guard !message.isEmpty else {
                    return
                }
                print(message)
                self?.view?.messages = message
                self?.view?.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func createNewConversation(with email: String, message: Message, senderUsername: String) {
        database.createNewConversation(with: email, firstMessage: message, username: senderUsername) { [weak self] success in
            if success {
                print("message successfuly sended")
            } else {
                print("message error")
            }
        }
        
    }
    
    func sender() -> Sender? {
        guard let email = AuthManager().getCurrentUserEmail() as? String  else {
            return nil
        }
      return Sender(senderId: email, displayName: "Me")
    }
    
    func viewDidLayoutSubviews() {
        
    }
    
    func viewDidLoad() {
        view?.setCollectionViewDelegates()
    }
    
}
