//
//  PopupViewManager.swift
//  TestPopViewManager
//
//  Created by Ma on 2024/1/8.
//

import UIKit
import Foundation

enum PopTypeLevel: Int {
    case highest = 0
    case normal
    case lower
}

enum PopTypeStatus: Int {
    case show = 0
    case over
}

struct PopViewModel {
    
    var child: PopViewBaseController?
    var parent: UIViewController?
    var level: PopTypeLevel = .normal
    var dateInsert: TimeInterval = Date().timeIntervalSince1970
    var className: String?
}

extension PopViewModel {
    
    init(child: PopViewBaseController, level: PopTypeLevel = .normal, tapDismiss: Bool = true) {
        child.bgTapDismiss = tapDismiss
        let kWindow = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.flatMap { $0.windows }.last { $0.isKeyWindow }
        self.init(child: child, parent: kWindow?.rootViewController, level: level)
        className = NSStringFromClass(child.classForCoder)
    }
}

class PopBaseNavigationController: UINavigationController {
    
    var viewDidDisappearClosure:(()->Void)?
    
    override func viewDidDisappear(_ animated: Bool) {
        viewDidDisappearClosure?()
    }
}

class PopupViewManager: NSObject {
    
    public static let shared = PopupViewManager()
    var popViewList: [PopViewModel] = []
    var status: PopTypeStatus = .over
    
    func getNext() -> PopViewModel? {
        return popViewList.popLast()
    }
    
    func insert(model: PopViewModel, excute: Bool = true) {
        objc_sync_enter(popViewList)
         
        popViewList.append(model)
        print("弹窗入队时间:\(model.dateInsert)")
        
        popViewList.sort { item1, item2 in
            if item1.level.rawValue > item2.level.rawValue {
                return true
            } else {
                return item1.dateInsert > item2.dateInsert
            }
        }
       
        objc_sync_exit(popViewList)
        
        if excute, self.status != .show {
            show()
        }
    }

    func show() {
        if let model = getNext() {
            guard let childVc = model.child else {
                return show()
            }
            
            self.status = .show
            
            let naviVc = PopBaseNavigationController(rootViewController: childVc)
            naviVc.modalPresentationStyle = .overCurrentContext
            naviVc.viewDidDisappearClosure = { [weak self] in
                self?.show()
            }
            model.parent?.present(naviVc, animated: false, completion: nil)
        } else {
            self.status = .over
        }
    }
    
    // 清空弹窗队列
    func empty() {
        objc_sync_enter(popViewList)
        popViewList.removeAll()
        objc_sync_exit(popViewList)
    }
    
}
