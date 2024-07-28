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
    
    func sender() -> Sender?
    func viewDidLayoutSubviews()
    func viewDidLoad()
    func createNewConversation(with email: String, message: Message, senderUsername: String )
    func listenForMessage(senderEmail: String, otherEmail: String)}
class PrivateChatViewModel {
    weak var view : PrivateChatViewControllerInterface?
    var database : DatabaseManagerProtocol = DatabaseManager()
    var auth: AuthManagerProtocol = AuthManager()
}

extension PrivateChatViewModel : PrivateChatViewModelInterface {
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
