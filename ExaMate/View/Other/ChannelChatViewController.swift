//
//  ChannelChatViewController.swift
//  ExaMate
//
//  Created by Ümit Şimşek on 30.04.2024.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import SDWebImage
protocol ChannelChatViewControllerInterface : AnyObject {
    var sender : Sender? {get set}
    var avatar : Avatar?{get set}
    func setCollectionViewDelegates()
    func showAlert(titleInput : String, messageInput : String)
    var messages: [Message]{get set}
    func getMessages(messages : [Message])
}

class ChannelChatViewController: MessagesViewController {
    var channelName = ""
    var avatar : Avatar?
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
extension ChannelChatViewController: MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, MessageCellDelegate {
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
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let message = messages[indexPath.section]
        self.viewModel.getUserProfilePic(with: message.sender.senderId)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
            guard let avt = self.avatar else { return}
            avatarView.set(avatar: avt)
        })
    }
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let email = messages[indexPath.section].sender.senderId
        return NSAttributedString(
          string: email,
          attributes: [
            .font: UIFont.preferredFont(forTextStyle: .caption1),
            .foregroundColor: UIColor(white: 0.3, alpha: 1)
          ]
        )
        
    }
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 35
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
    func didTapImage(in cell: MessageCollectionViewCell) {
        guard let indexPath = messagesCollectionView.indexPath(for:cell) else {
            return
        }
        let message = messages[indexPath.section]
        switch message.kind {
        case .photo(let media):
            guard let mediaUrl = media.url else {
                return
            }
            let vc = PhotoViewerViewController(url: mediaUrl)
            navigationController?.pushViewController(vc, animated: true)
        default:
            break
        }
    }
    func didTapMessage(in cell: MessageCollectionViewCell) {
        guard let indexPath = self.messagesCollectionView.indexPath(for:cell) else {
            return
        }
        let message = self.messages[indexPath.section]
        
        let actionSheet = UIAlertController(title: "İşlemler", message: "Bir seçeneği seçiniz...", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Profili Görüntüle", style: .default, handler: { [weak self] _ in
           
            switch message.kind {
            case .text(let str):
                guard let txt = str as? String else {
                    return
                }
                let vc = ProfileViewController(message: message )
                self?.navigationController?.pushViewController(vc, animated: true)
            default:
                break
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Chat GPT'ye Sor", style: .default, handler: { [weak self] _ in
            switch message.kind {
            case .text(let str):
                print("txt : \(str)")
                //self?.fetchChatGPTResponseFor(prompt: str)
            default:
                break
            }
        }))
        actionSheet.addAction(UIAlertAction(title:"Cancel", style: .cancel, handler: nil ))
        self.present(actionSheet, animated: true)
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
        messagesCollectionView.messageCellDelegate = self
        setupInputButton()
        messageInputBar.delegate = self
    }
    func showAlert(titleInput : String, messageInput : String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK!", style: .cancel)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
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
extension ChannelChatViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        guard let image = info[.editedImage] as? UIImage,
              let imageData = image.pngData(), let selfSender =  sender else {
            return
        }
        viewModel.sendMessage(channelName: channelName, sender: selfSender, imageData: imageData)
    }
    
    
}
