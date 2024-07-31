//
//  PrivateChatTableViewCell.swift
//  ExaMate
//
//  Created by Ümit Şimşek on 30.07.2024.
//

import UIKit
import SDWebImage
protocol PrivateChatTableViewCellInterface : AnyObject {
    func layoutSubview()
    func configViews()
    func setProfilePhoto(url: URL)
}
class PrivateChatTableViewCell: UITableViewCell {
    static let identifier = "PrivateChatTableViewCell"
    
    private var viewModel = PrivateChatTableViewCellViewModel()
    
    private let containerView : UIView = {
       let vieww = UIView()
        vieww.layer.cornerRadius = 8
        vieww.backgroundColor = .systemGray6
        return vieww
    }()
    private let userPhotoView : UIImageView = {
       let imgView = UIImageView()
        let img = UIImage(systemName: "person")
        imgView.image = img
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 35
        return imgView
    }()
    
    private let usernameLabel : UILabel = {
       let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 18, weight: .medium)
        lbl.text = "Name"
        lbl.textAlignment = .left
        return lbl
    }()
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
        super.layoutSubviews()
        viewModel.layoutSubviews()
        
    }
}
extension PrivateChatTableViewCell {
    func configure(username : String, content : String,email : String) {
        usernameLabel.text = username
        contentLabel.text = content
        viewModel.getUserProfilePhoto(email: email)
        
    }
}
extension PrivateChatTableViewCell: PrivateChatTableViewCellInterface {
    func setProfilePhoto(url: URL) {
        self.userPhotoView.sd_setImage(with: url)
    }
    
    func configViews() {
        containerView.addSubview(userPhotoView)
        containerView.addSubview(usernameLabel)
        containerView.addSubview(contentLabel)

        contentView.addSubview(containerView)
    }
    
    func layoutSubview() {
        self.containerView.frame = CGRect(x: 5,
                                          y: 3,
                                          width: contentView.width-10,
                                          height: contentView.height-6)
        self.userPhotoView.frame = CGRect(x: containerView.left + 5,
                                        y: containerView.top + 10,
                                          width: 75,
                                          height: 75)
        self.usernameLabel.frame = CGRect(x: userPhotoView.right + 10,
                                          y: containerView.top,
                                          width: containerView.width-100,
                                          height: 30)
        self.contentLabel.frame = CGRect(x: userPhotoView.right + 10,
                                        y: usernameLabel.bottom,
                                        width: containerView.width-100,
                                        height: 50)

    }
}
