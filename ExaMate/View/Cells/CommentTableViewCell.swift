//
//  CommentTableViewCell.swift
//  ExamMate1
//
//  Created by Ümit Şimşek on 3.12.2023.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    static let identifier = "CommentTableViewCell"
    var db = DatabaseManager()

    private let profileImgView : UIImageView = {
       let imgView = UIImageView()
        let img = UIImage(systemName: "person.circle")
        imgView.image = img
        
        imgView.layer.cornerRadius = 30
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
      return imgView
    }()
    
    private let usernameLabel : UILabel = {
       let lbl = UILabel()
        lbl.clipsToBounds = true
        lbl.text = "Username"
        lbl.font = .systemFont(ofSize: 15, weight: .bold)
        return lbl
    }()
    
    private let commentTextLabel : UILabel  = {
        let lbl = UILabel()
         lbl.clipsToBounds = true
         lbl.text = "Soru böyle gözükecekSoru böyle gözükecekSoru böyle gözükecekSoru böyle gözükecekSoru böyle gözükecekSoru böyle gözükecekSoru böyle gözükecekSoru böyle gözükecekSoru böyle gözükecekSoru böyle gözükecekSoru böyle gözükecekSoru böyle gözükecekSoru böyle gözükecekSoru böyle gözükecek"
        lbl.numberOfLines = 0
        lbl.font = .systemFont(ofSize: 12)

         return lbl
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configViews()
     
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImgView.frame = CGRect(x: 10,
                                      y: contentView.top+10,
                                      width: 60,
                                      height: 60)
        usernameLabel.frame = CGRect(x: profileImgView.right+10,
                                      y: contentView.top,
                                     width: 100,
                                      height: 15)
        commentTextLabel.frame = CGRect(x: profileImgView.right+10,
                                      y: usernameLabel.bottom,
                                        width: contentView.width-90,
                                      height: 60)
    }
}
extension CommentTableViewCell {
    func configViews() {
        contentView.addSubview(profileImgView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(commentTextLabel)

       
    }
    
    public func configure(with model : Comment) {
        self.commentTextLabel.text = model.commentText
        db.getUsername(email: model.commentBy) { usern in
            self.usernameLabel.text = usern
        }
        db.getUserProfilePhoto(email: model.commentBy) { url in
            guard let imgUrl = url else {return }
            self.profileImgView.sd_setImage(with: imgUrl)
        }
    }
    
}
