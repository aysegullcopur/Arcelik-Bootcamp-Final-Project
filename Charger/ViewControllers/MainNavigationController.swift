//
//  MainNavigationController.swift
//  Charger
//
//  Created by Aysegul COPUR on 11.07.2022.
//

import UIKit

class MainNavigationController: UINavigationController {
    
    override var childForStatusBarHidden: UIViewController? {
        return topViewController
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
    
    private lazy var statusBarBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.2655122876, green: 0.2884307206, blue: 0.329084754, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(statusBarBackgroundView)
        
        NSLayoutConstraint.activate([
            statusBarBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            statusBarBackgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            statusBarBackgroundView.rightAnchor.constraint(equalTo: view.rightAnchor),
            statusBarBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor),
        ])
    }
    
    override func setNavigationBarHidden(_ hidden: Bool, animated: Bool) {
        super.setNavigationBarHidden(hidden, animated: animated)
        
        statusBarBackgroundView.isHidden = hidden
    }
    
}
