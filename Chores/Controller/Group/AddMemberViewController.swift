//
//  AddMemberViewController.swift
//  Chores
//
//  Created by 黃瀞萱 on 2021/5/24.
//

import UIKit
import MIBlurPopup
import KRProgressHUD

class AddMemberViewController: UIViewController {
    
    @IBOutlet weak var popView: UIView!
    
    @IBOutlet weak var addMemberTextField: UITextField!
    
//    var invitation: Invitation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func addMember(_ sender: Any) {
        
        guard let userId = addMemberTextField.text else { return }
        
        if userId.isEmpty {
            
            KRProgressHUD.showError(withMessage: "ID 不能是空白的哦！")
            
            return
        }
        
        fetchUser(userId: userId)
    }
    
    @IBAction func backToGroupPage(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func fetchUser(userId: String) {
        
        UserProvider.shared.fetchOwner(userId: userId) { [weak self] result in
            
            switch result {
            
            case .success(let user):
                
                print(user)
                    
                self?.sendInvitation(userId: user.id)

            case .failure(let error):
                
                print(error)
                
                switch error {
                
                case .userNotExist:
                    
                    KRProgressHUD.showError(withMessage: "找不到使用者 ID")
                    
                default:
                    
                    print(error)
                }
            }
        }
    }
    
    func sendInvitation(userId: String) {
        
        let invitation = Invitation(
            group: UserProvider.shared.user.groupId ?? "",
            name: UserProvider.shared.user.name,
            id: "")
        
        UserProvider.shared.sendInviation(invitation: invitation, userId: userId) { result in
            
            switch result {
            
            case .success(let message):
                
                print(message)
                
            case .failure(let error):
                
                print(error)
            }
        }
    }
    
}

extension AddMemberViewController: MIBlurPopupDelegate {
    
    var popupView: UIView {
        
        popView
    }
    
    var blurEffectStyle: UIBlurEffect.Style? {
        
        .dark
    }
    
    var initialScaleAmmount: CGFloat {
        
        0.0
    }
    
    var animationDuration: TimeInterval {
        
        0.2
    }
    
}
