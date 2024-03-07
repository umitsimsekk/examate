//
//  FeedTableViewCell.swift
//  ExamMate1
//
//  Created by Ümit Şimşek on 26.11.2023.
//

import UIKit
import SDWebImage
class FeedTableViewCell: UITableViewCell {
    static let identifier = "FeedTableViewCell"
    var db = DatabaseManager()
    private let profileImgView : UIImageView = {
       let imgView = UIImageView()
        let img = UIImage(systemName: "person.circle")
        imgView.image = img
        
        imgView.layer.cornerRadius = 25
        imgView.contentMode = .scaleAspectFill
        imgView.clipsToBounds = true
      return imgView
    }()
    
    private let usernameLabel : UILabel = {
       let lbl = UILabel()
        lbl.clipsToBounds = true
        lbl.text = "Username"
        return lbl
    }()
    
    private let lessonNameLabel : UILabel  = {
        let lbl = UILabel()
         lbl.clipsToBounds = true
        lbl.textAlignment = .right
         lbl.text = "TYT Matematik"
         return lbl
    }()
    private let questionTextLabel : UILabel  = {
        let lbl = UILabel()
         lbl.clipsToBounds = true
         lbl.text = "Soru böyle gözükecekSoru böyle gözükecekSoru böyle gözükecekSoru böyle gözükecekSoru böyle gözükecekSoru böyle gözükecekSoru böyle gözükecekSoru böyle gözükecekSoru böyle gözükecekSoru böyle gözükecekSoru böyle gözükecekSoru böyle gözükecekSoru böyle gözükecekSoru böyle gözükecek"
        lbl.numberOfLines = 0
         return lbl
    }()
    
    private let postImgView : UIImageView = {
        let imgView = UIImageView()
         let img = UIImage(systemName: "photo")
         imgView.image = img
         imgView.clipsToBounds = true
         imgView.contentMode = .scaleAspectFill
         return imgView
    }()
    
    private let answerLabel : UILabel  = {
        let lbl = UILabel()
         lbl.clipsToBounds = true
         lbl.text = "12 Yanıt"
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
                                      y: contentView.safeAreaInsets.top+20,
                                      width: 50,
                                      height: 50)
        usernameLabel.frame = CGRect(x: profileImgView.right+10,
                                      y: contentView.safeAreaInsets.top+20,
                                      width: 100,
                                      height: 50)
        lessonNameLabel.frame = CGRect(x: (contentView.width-150),
                                       y: contentView.safeAreaInsets.top+20,
                                       width: 150,
                                       height: 50)
        questionTextLabel.frame = CGRect(x: 10,
                                         y: profileImgView.bottom,
                                         width: contentView.width-20,
                                         height: 70)
        postImgView.frame = CGRect(x: 10,
                                   y:questionTextLabel.bottom+10,
                                         width: contentView.width-20,
                                         height: 300)
        answerLabel.frame = CGRect(x: 10,
                                   y:postImgView.bottom+10,
                                         width: contentView.width-20,
                                         height: 50)
    }
}
extension FeedTableViewCell {
    func configViews() {
        contentView.addSubview(profileImgView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(lessonNameLabel)
        contentView.addSubview(questionTextLabel)
        contentView.addSubview(postImgView)
        contentView.addSubview(answerLabel)
    }
    
    public func configure(with model : Post) {
        
        self.questionTextLabel.text = model.question
        self.lessonNameLabel.text = model.lesson        
        guard let url = model.imgUrl else { return }
        
        self.postImgView.sd_setImage(with: url)
        db.getUsername(email: model.postedBy) { usern in
            self.usernameLabel.text = usern
        }
        db.getCommentsCount(postId: model.postId) { count in
            if count == 0 {
                self.answerLabel.text = "Henüz yanıt yok"
            } else {
                self.answerLabel.text = "\(count) yanıt"
            }
        }
        
        db.getUserProfilePhoto(email: model.postedBy) { url in
            guard let imgUrl = url else {return }
            self.profileImgView.sd_setImage(with: url)
        }
        
    }
    
}
