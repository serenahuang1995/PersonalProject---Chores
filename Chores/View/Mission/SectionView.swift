//
//  SectionView.swift
//  Chores
//
//  Created by 黃瀞萱 on 2021/5/12.
//

import UIKit

protocol SectionViewDelegate: AnyObject {
    
    func showMoreItem(_ section: SectionView, _ didPressTag: Int, _ isExpand: Bool)
}

//private enum SectionTitle: String {
//    
//    case unclaimed = "任務認領區"
//    
//    case ongoing = "任務進行中"    
//}

class SectionView: UITableViewHeaderFooterView {
    
    var buttonTag: Int = -1 // 存放 Section 索引的 buttonTag
    
    var isExpand: Bool = false
    
    weak var delegate: SectionViewDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var expandButton: UIButton!
    
    @IBOutlet weak var cardView: CardView! {
        
        didSet {
            
            self.cardView.backgroundColor = .orangeFFDEB1
        }
    }
    
    @IBOutlet weak var cardViewTopConstraint: NSLayoutConstraint!
    
    @IBAction func expand(_ sender: Any) {
        
        self.delegate?.showMoreItem(self, buttonTag, self.isExpand)
    }
    
    func layoutSection(title: String, topConstraint: CGFloat) {
        
        titleLabel.text = title
        
        cardViewTopConstraint.constant = topConstraint
        
        if isExpand {
            
            // 按鈕鏡像翻轉
            expandButton.transform = CGAffineTransform(scaleX: 1, y: -1)
        }
    }
    
    func setExpandButtonVisible(isVisible: Bool) {
        
        expandButton.isHidden = !isVisible        
    }
}
