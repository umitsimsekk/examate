//
//  LessonsTableViewCell.swift
//  ExamMate1
//
// 
//

import UIKit

class LessonsTableViewCell: UITableViewCell {

    static let identifier = "LessonsTableViewCell"

    private let containerView : UIView = {
       let vieww = UIView()
        vieww.layer.cornerRadius = 12
        vieww.backgroundColor = .systemGray6
        return vieww
    }()
    private let imgViewContainer : UIView = {
       let vieww = UIView()
        vieww.layer.cornerRadius = 4
        return vieww
    }()
    private let imgView : UIImageView = {
       let imgView = UIImageView()
        let img = UIImage(systemName: "envelope")
        imgView.image = img
        imgView.contentMode = .scaleToFill
        imgView.clipsToBounds = true
        return imgView
    }()
    private let label : UILabel = {
       let lbl = UILabel()
        lbl.text = "Mesaj gönder"
        lbl.font = .systemFont(ofSize: 18, weight: .semibold)
        lbl.textAlignment = .left
        return lbl
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        imgViewContainer.addSubview(imgView)
        containerView.addSubview(imgViewContainer)
        containerView.addSubview(label)
        contentView.addSubview(containerView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.frame = CGRect(x: 5,
                                     y: 5,
                                     width: contentView.width-10,
                                     height: 50)
        imgViewContainer.frame = CGRect(x: 5,
                                     y: 5,
                                     width: 40,
                                     height: 40)
        imgView.frame = CGRect(x: 5,
                                     y: 5,
                                     width: 30,
                                     height: 30)
        label.frame = CGRect(x: imgViewContainer.right + 5,
                             y: 0,
                             width: containerView.width-60,
                             height: 50)
        
    }
}
extension LessonsTableViewCell {
    public func configure(with lesson : String, color : UIColor) {
        self.label.text = lesson
        self.imgViewContainer.backgroundColor = color
    }
}
