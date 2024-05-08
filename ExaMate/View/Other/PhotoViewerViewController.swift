//
//  PhotoViewerViewController.swift
//  ExaMate
//
//  Created by Ümit Şimşek on 8.05.2024.
//

import UIKit
import SDWebImage
class PhotoViewerViewController: UIViewController {

    private let url : URL
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let imageView : UIImageView = {
       let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Photo"
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        imageView.sd_setImage(with: url)
    }
   
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imageView.frame = view.bounds
    }
}
