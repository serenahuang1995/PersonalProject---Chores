//
//  InvitationViewController.swift
//  Chores
//
//  Created by 黃瀞萱 on 2021/6/1.
//

import UIKit
import MIBlurPopup

class InvitationViewController: UIViewController {

    @IBOutlet weak var invitationView: CardView!
    
    @IBOutlet weak var invitationLabel: UILabel!
    
    var invitation: Invitation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let invitation = invitation {
            
            invitationLabel.text = "\(invitation.name) 邀請你加入小屋"
        }
    }

    @IBAction func acceptInvitation(_ sender: Any) {
        
        acceptInvitation()
    }

    @IBAction func rejectInvitation(_ sender: Any) {
        
        deleteInvitation(isAccept: false)
    }
    
    // 接受完邀請要delete invitation 拒絕邀請也要delete
    func deleteInvitation(isAccept: Bool) {
        
        if let invitation = invitation {
            
            UserProvider.shared.deleteInvitation(invitation: invitation) { [weak self] result in
                
                switch result {
                
                case .success(let message):
                    
                    print(message)
                    
                    // 如果是按接受就 performSegue
                    if isAccept {
                        
                        self?.performSegue(withIdentifier: Segue.main, sender: nil)
                        
                    } else {
                        
                        self?.dismiss(animated: true, completion: nil)
                    }
                                        
                case .failure(let error):
                    
                    print(error)
                }
            }
        }
    }

    func acceptInvitation() {
        
        if let invitation = invitation {
            
            UserProvider.shared.updateGroupId(invitation: invitation) { [weak self] result in
                
                switch result {
                 
                case .success(let message):
                    
                    print(message)
                    
                    self?.deleteInvitation(isAccept: true)
                    
                case .failure(let error):
                    
                    print(error)
                }
            }
        }
    }
    
}

extension InvitationViewController: MIBlurPopupDelegate {
    
    var popupView: UIView {
        
        invitationView
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
