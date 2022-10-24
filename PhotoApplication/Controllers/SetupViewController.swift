//
//  SetupViewController.swift
//  PhotoApplication
//
//  Created by Константин Малков on 24.10.2022.
//

//VIEW CONTROLLER IN DEVELOPMENT

import UIKit

class SetupViewController: UIViewController {
    
    private let closeButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        button.addTarget(SetupViewController.self, action: #selector(didTapClose), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        view.backgroundColor = .red
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        closeButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    @objc private func didTapClose(){
        
    }
    
    private func setupViewController(){
        view.addSubview(closeButton)
        
    }
    
}
