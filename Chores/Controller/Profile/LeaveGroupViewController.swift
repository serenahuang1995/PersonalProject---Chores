//
//  LeaveGroupViewController.swift
//  Chores
//
//  Created by 黃瀞萱 on 2021/6/11.
//

import UIKit
import MIBlurPopup

class LeaveGroupViewController: UIViewController {

    @IBOutlet weak var cardView: CardView!

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func leaveGroup(_ sender: Any) {
        
        leaveGroup()
    }
    
    @IBAction func cancel(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func leaveGroup() {
        
        UserProvider.shared.leaveGroup { [weak self] result in
            
            switch result {
            
            case .success(let success):
                
                print("leave group\(success)")
                
                let userDefault = UserDefaults()
                
                userDefault.setValue(nil, forKey: "GroupID")
                
                self?.performSegue(withIdentifier: Segue.initial, sender: nil)

            case .failure(let error):
                
                print(error)
            }
        }
    }
}

extension LeaveGroupViewController: MIBlurPopupDelegate {
    
    var popupView: UIView { cardView }
    
    var blurEffectStyle: UIBlurEffect.Style? { .dark }
    
    var initialScaleAmmount: CGFloat { 0.0 }
    
    var animationDuration: TimeInterval { 0.2 }
}
