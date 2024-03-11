//
//  MainTabbarViewController.swift
//  ExaMate
//
//  Created by Ümit Şimşek on 4.03.2024.
//

import UIKit

class MainTabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let vc1 = UINavigationController(rootViewController: FeedViewController())
        let vc2 = UINavigationController(rootViewController: ChatViewController())
        let vc3 = UINavigationController(rootViewController: GroupsViewController())
        let vc4 = UINavigationController(rootViewController: PrivateViewController())
        
        vc1.title  = "Soru Odaları"
        vc2.title  = "Sohbet Odaları"
        vc3.title  = "Gruplar"
        vc4.title  = "Özel"
        
        vc1.tabBarItem.image = UIImage(systemName: "questionmark.app")
        vc2.tabBarItem.image = UIImage(systemName: "message")
        vc3.tabBarItem.image = UIImage(systemName: "person.3")
        vc4.tabBarItem.image = UIImage(systemName: "person")
        
        view.tintColor = .label
        
        setViewControllers([vc1,vc2,vc3,vc4], animated: true)
        
    }

}
