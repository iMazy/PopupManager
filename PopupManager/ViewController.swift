//
//  ViewController.swift
//  PopupManager
//
//  Created by Ma on 2024/1/8.
//

import UIKit

class ViewController: UIViewController {

    let button = UIButton(type: .contactAdd)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        button.center = self.view.center
        view.addSubview(button)
        button.addTarget(self, action: #selector(showVc), for: .touchUpInside)
    }

    @objc func showVc() {
        let popVC = TestPopViewController()
        
        let popVM1 = PopViewModel(child: popVC)
        PopupViewManager.shared.insert(model: popVM1)
        
        // 最高优先级展示
        let popVM2 = PopViewModel(child: popVC, level: .highest)
        PopupViewManager.shared.insert(model: popVM2)
        
        // 点击背景不消失
//        let popVM3 = PopViewModel(child: popVC, level: .highest, tapDismiss: false)
//        PopupViewManager.shared.insert(model: popVM3)
    }

}

