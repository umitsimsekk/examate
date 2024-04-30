//
//  ChatTableViewCell.swift
//  ExamMate1
//
//  Created by Ümit Şimşek on 29.12.2023.
//

import UIKit
struct ChatCellModel {
    let logo : String
    let channelName : String
    let senderUsername : String
    let content : String
}
class ChatTableViewCell: UITableViewCell {

    static let identifier = "ChatTableViewCell"
    private let containerView : UIView = {
       let vieww = UIView()
        vieww.layer.cornerRadius = 8
        vieww.backgroundColor = .systemGray6
        return vieww
    }()
    private let channelLogo : UIImageView = {
       let imgView = UIImageView()
        let img = UIImage(systemName: "person")
        imgView.image = img
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 35
        return imgView
    }()
    
    private let channelName : UILabel = {
       let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 18, weight: .medium)
        lbl.text = "Name"
        lbl.textAlignment = .left
        return lbl
    }()
    
    private var senderUsername = ""
    private var content = ""
    
    private var contentLabel : UILabel = {
       let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 14, weight: .regular)
        lbl.text = "No conversation"
        lbl.numberOfLines = 0
        lbl.textAlignment = .left
        return lbl
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super .init(style: style, reuseIdentifier: reuseIdentifier)
        configView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super .layoutSubviews()
        self.containerView.frame = CGRect(x: 5,
                                          y: 3,
                                          width: contentView.width-10,
                                          height: contentView.height-6)
        self.channelLogo.frame = CGRect(x: containerView.left + 5,
                                        y: containerView.top + 5,
                                          width: 75,
                                          height: 75)
        self.channelName.frame = CGRect(x: channelLogo.right + 10,
                                          y: containerView.top,
                                        width: 100,
                                          height: 30)
        self.contentLabel.frame = CGRect(x: channelLogo.right + 10,
                                        y: channelName.bottom,
                                        width: containerView.width-100,
                                        height: 50)
        
    }
    func configView(){
        containerView.addSubview(channelLogo)
        containerView.addSubview(channelName)
        containerView.addSubview(contentLabel)
        contentView.addSubview(containerView)
    }
    public func configure(photo : String, name : String) {
        self.channelLogo.image = UIImage(named: photo)
        self.channelName.text = name
        fetchInfoToChannel(channelName: name)

    }
    
    func fetchInfoToChannel(channelName : String) {
        var message : Message?
        DatabaseManager().getAllMessagesByChannelName(channelName: channelName) { result in
            switch result {
            case .success(let messages):
                message = messages.last
                guard message != nil  else {return }
                DatabaseManager().getUsername(email: message!.sender.senderId) { username in
                    var messg = ""
                    
                    switch message!.kind {
                       
                    case .text(let messageText):
                        messg = messageText
                    case .attributedText(_):
                        break
                    case .photo(_):
                        break
                    case .video(_):
                        break
                    case .location(_):
                        break
                    case .emoji(_):
                        break
                    case .audio(_):
                        break
                    case .contact(_):
                        break
                    case .linkPreview(_):
                        break
                    case .custom(_):
                        break
                    }
                    self.content = messg
                    self.senderUsername = username
                    self.contentLabel.text = "\(self.senderUsername): \(self.content)"

                }
            case .failure(let error):
                print(error)
            }
        }
        
    }
}
