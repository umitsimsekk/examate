//
//  ChannelChatViewController.swift
//  ExaMate
//
//  Created by Ümit Şimşek on 30.04.2024.
//

import UIKit
import MessageKit
import InputBarAccessoryView

protocol ChannelChatViewControllerInterface : AnyObject {
    var sender : Sender? {get set}
    func setCollectionViewDelegates()
    func showAlert(titleInput : String, messageInput : String)
    var messages: [Message]{get set}
    func getMessages(messages : [Message])
}

class ChannelChatViewController: MessagesViewController {
    var channelName = ""
    var messages = [Message]()
    var sender: Sender?
    lazy var viewModel = ChannelChatViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad()
        // Do any additional setup after loading the view.
        title = channelName
        viewModel.fetchChannelMessage(channelName: channelName)
    }
}
extension ChannelChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    func currentSender() -> MessageKit.SenderType {
        if let selfSender = self.sender {
            return selfSender
        }
        fatalError("Self sender is nil, emaill should be cached")

    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessageKit.MessagesCollectionView) -> MessageKit.MessageType {
        messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessageKit.MessagesCollectionView) -> Int {
        messages.count
    }
    
    
}
extension ChannelChatViewController : ChannelChatViewControllerInterface {
    func getMessages(messages: [Message]) {
        self.messages = messages
        DispatchQueue.main.async {
            self.messagesCollectionView.reloadDataAndKeepOffset()
        }
    }
    
    func setCollectionViewDelegates() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        //messagesCollectionView.messageCellDelegate = self
        //setupInputButton()
        messageInputBar.delegate = self
    }
    func showAlert(titleInput : String, messageInput : String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK!", style: .cancel)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
}
extension ChannelChatViewController : InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
            let selfSender = sender
        else {
            return
        }
        let uuidString = UUID().uuidString
        let message = Message(sender: selfSender, messageId: uuidString, sentDate: Date(), kind: .text(text))
        viewModel.sendMessage(to: channelName, model: message)
        
    }
}
