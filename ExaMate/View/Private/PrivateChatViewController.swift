//
//  PrivateChatViewController.swift
//  ExaMate
//
//  Created by Ümit Şimşek on 28.07.2024.
//

import UIKit
import MessageKit
import InputBarAccessoryView

protocol PrivateChatViewControllerInterface : AnyObject {
    func setCollectionViewDelegates()
    func createMessageId() -> String?
    func listenForMessage()
    var messages: [Message] {get set}
    func reloadData()
}
class PrivateChatViewController: MessagesViewController {

    
    private let otherUserEmail : String
    public var isNewConversation = false
    public var messages = [Message]()
    
    lazy var viewModel = PrivateChatViewModel()
    
    public static var dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        
        return formatter
    }()
    private var sender : Sender? {
        guard let sender = viewModel.sender() else {
            return nil
        }
        return sender
    }
    
    init(with otherUserEmail: String) {
        self.otherUserEmail = otherUserEmail
        super.init(nibName: nil, bundle: nil)
        listenForMessage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        viewModel.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
}

extension PrivateChatViewController: PrivateChatViewControllerInterface {
    func listenForMessage() {
        guard let selfSender = sender else {
            return
        }
        viewModel.listenForMessage(senderEmail: selfSender.senderId, otherEmail: otherUserEmail)
    }
    func reloadData(){
        DispatchQueue.main.async {
            self.messagesCollectionView.reloadDataAndKeepOffset()
        }
    }
    
    func setCollectionViewDelegates() {
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        //setupInputButton()
        messageInputBar.delegate = self
    }
    public func createMessageId() -> String? {
        guard let currentUserEmail = viewModel.sender()?.senderId
                 else {
            return nil
        }
        let dateString = Self.dateFormatter.string(from: Date())
        let newIdentifier = "\(otherUserEmail)_\(currentUserEmail)_\(dateString)"
        return newIdentifier
    }
}
extension PrivateChatViewController : MessagesDataSource,MessagesDisplayDelegate, MessageCellDelegate, MessagesLayoutDelegate {
    func currentSender() -> MessageKit.SenderType {
        if let sender = self.sender {
            return sender
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
extension PrivateChatViewController : InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        print("tapped")

        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
            let selfSender = sender,
              let messageId = createMessageId(),
              let senderUsername = title
        else {
            print("self sender error")
            return
        }
        let message = Message(sender: selfSender,
                              messageId: messageId,
                              sentDate: Date(),
                              kind: .text(text))
        viewModel.createNewConversation(with: self.otherUserEmail, message: message, senderUsername: senderUsername)
    }
}
