//
//  SettingViewController.swift
//  Chores
//
//  Created by 黃瀞萱 on 2021/5/26.
//

import UIKit

class SettingViewController: UIViewController {
  
  @IBOutlet weak var popView: CardView!
  
  @IBOutlet weak var changeNameButton: UIButton! {
    
    didSet {
      
      setUpButtonStyle(changeNameButton)
    }
    
  }
  
  @IBOutlet weak var changePictureButton: UIButton! {
    
    didSet {
      
      setUpButtonStyle(changePictureButton)
      
    }

  }

  @IBOutlet weak var leaveGroupButton: UIButton! {
    
    didSet {
      
      setUpButtonStyle(leaveGroupButton)

    }
    
  }
  
  let blackView = UIView(frame: UIScreen.main.bounds)
  
//  var blurEffectStyle: UIBlurEffect.Style?
//  
//  var visualEffectBlurView = UIVisualEffectView()


  override func viewDidLoad() {
    super.viewDidLoad()
    
    showBlackView()
    
  }
  
  
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    
    let touch: UITouch? = touches.first
    
    if touch?.view != popView {
        
      dismiss(animated: true, completion: nil)
      
      blackView.removeFromSuperview()
      
    }

  }

  private func showBlackView() {
    
    blackView.backgroundColor = .black
    
    blackView.alpha = 0.7
    
    presentingViewController?.view.addSubview(blackView)
    
  }
  
  private func setUpButtonStyle(_ button: UIButton) {
    
    button.layer.borderColor = UIColor.black252525.cgColor
    
    button.layer.borderWidth = 2
    
    button.layer.cornerRadius = 10
    
  }

}