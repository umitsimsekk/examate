//
//  ChatTableViewCell.swift
//  ExamMate1
//
//
//

import UIKit
struct ChatCellModel {
    let logo : String
    let channelName : String
    let senderUsername : String
    let content : String
}
protocol ChatTableViewCellInterface : AnyObject {
    func setLayoutSubviews()
    func configView()
    func fetchInfoToChannel(latestMessage: String)
}
class ChatTableViewCell: UITableViewCell {
    lazy var viewModel = ChatTableViewViewModel()

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
        viewModel.view = self
        viewModel.viewDidLoad()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super .layoutSubviews()
        viewModel.viewDidLayoutSubviews()
        
    }
    
    public func configure(photo : String, name : String) {
        self.channelLogo.image = UIImage(named: photo)
        self.channelName.text = name
        viewModel.fetchInfoToChannel(channelName: name)

    }
}
extension ChatTableViewCell : ChatTableViewCellInterface {
    func fetchInfoToChannel(latestMessage: String) {
        self.contentLabel.text = latestMessage
    }
    
    func configView(){
        containerView.addSubview(channelLogo)
        containerView.addSubview(channelName)
        containerView.addSubview(contentLabel)
        contentView.addSubview(containerView)
    }
    func setLayoutSubviews() {
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
    
}
