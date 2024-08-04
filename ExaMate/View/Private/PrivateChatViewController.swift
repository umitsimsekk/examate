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
    var avatar : Avatar?{get set}
    func setCollectionViewDelegates()
    func createMessageId() -> String?
    func listenForMessage()
    var messages: [Message] {get set}
    func reloadData()
}
class PrivateChatViewController: MessagesViewController {

    var avatar : Avatar?
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
    }
}

extension PrivateChatViewController: PrivateChatViewControllerInterface {
    func getImageURL(url: URL?) -> URL? {
        return url
    }
    
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
        setupInputButton()
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
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let message = messages[indexPath.section]
        self.viewModel.getUserProfilePic(with: message.sender.senderId)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            guard let avt = self.avatar else { return}
            avatarView.set(avatar: avt)
        })
    
    }
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        guard let message = message as? Message else {
            return
        }
        
        switch message.kind {
        case .photo(let media):
            guard let mediaUrl = media.url else {
                return
            }
            imageView.sd_setImage(with: mediaUrl)
        default:
            break
        }
    }
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 35
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
extension PrivateChatViewController {
    func setupInputButton() {
        let button =  InputBarButtonItem()
        button.setSize(CGSize(width: 35, height: 35), animated: false)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .label
        button.onTouchUpInside { [weak self] _ in
            self?.presentInputActionSheet()
        }
        messageInputBar.setLeftStackViewWidthConstant(to: 36, animated: false)
        messageInputBar.setStackViewItems([button], forStack: .left, animated: false)
    }
    func presentInputActionSheet() {
        let actionSheet = UIAlertController(title: "Attach media", message: "What would you like to attach?", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoActionSheet()
        }))
        actionSheet.addAction(UIAlertAction(title: "Video", style: .default, handler: {  _ in
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Audio", style: .default, handler: {  _ in
            
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true)
    }
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Attach photo", message: "Where would you like to attach a photo from", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { [weak self] _ in
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.allowsEditing = true
            picker.delegate = self
            self?.present(picker, animated: true)
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { [weak self] _ in
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            picker.delegate = self
            self?.present(picker, animated: true)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil ))
        self.present(actionSheet, animated: true)
    }
}
extension PrivateChatViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage,
              let imageData = image.pngData(), sender != nil,
              let selfSender = sender
        else {
            return
        }
        viewModel.sendMessage(sender: selfSender, senderEmail: selfSender.senderId, imageData: imageData, otherEmail: otherUserEmail)
        
        
    }
}
