//
//  PopViewBaseController.swift
//  TestPopViewManager
//
//  Created by Ma on 2024/1/8.
//

import UIKit

class PopViewBaseController: UIViewController {
    
    var viewDidExitClosure: (() -> Void)?
    var viewDidDisappearClosure: (() -> Void)?
    
    var bgTapDismiss: Bool = true
    var enableAnimate: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if bgTapDismiss {
            let tapGesture = UITapGestureRecognizer(target:self, action:#selector(handleTap(sender:)))
            tapGesture.delegate = self
            self.view.addGestureRecognizer(tapGesture)
        }
        
        for sub in self.view.subviews {
            sub.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
        }
        self.view.backgroundColor = .clear
        
        self.modalPresentationStyle = .overCurrentContext
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewDidDisappearClosure?()
    }
    
    func startAnimation() {
        
        if enableAnimate {
            UIView.animate(withDuration: 0.25) {
                for sub in self.view.subviews {
                    sub.transform = .identity
                }
                self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            }
        } else {
            for sub in self.view.subviews {
                sub.transform = .identity
            }
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        }
    }
    
    func dismissView() {
        
        if enableAnimate {
            UIView.animate(withDuration: 0.3, animations: {
                for sub in self.view.subviews {
                    sub.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
                }
                self.view.backgroundColor = UIColor.clear
            }) { (result) in
                self.dismiss(animated: false, completion: {
                    self.quitView()
                })
            }
        } else {
            for sub in self.view.subviews {
                sub.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
            }
            self.view.backgroundColor = UIColor.clear
            self.dismiss(animated: false, completion: {
                self.quitView()
            })
        }
    }
    
    func quitView() {
        viewDidExitClosure?()
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            if bgTapDismiss {
                dismissView()
            }
        }
        sender.cancelsTouchesInView = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.startAnimation()
    }
}


extension PopViewBaseController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view == self.view
    }
}

