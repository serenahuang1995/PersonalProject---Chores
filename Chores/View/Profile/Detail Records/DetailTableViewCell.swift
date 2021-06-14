//
//  DetailTableViewCell.swift
//  Chores
//
//  Created by 黃瀞萱 on 2021/6/14.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var detailView: CardView!
    
    @IBOutlet weak var choreImage: UIImageView!
    
    @IBOutlet weak var choreItem: UILabel!
    
    @IBOutlet weak var completedTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        detailView.backgroundColor = .beigeFFF1E6
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func layoutCell(chore: Chore) {
        
        choreItem.text = chore.item
        
        if let imageName = ChoreImages.imageNames[chore.item] {
            
            choreImage.image = UIImage(named: imageName)
            
        } else {
            
            choreImage.image = UIImage.asset(.CustomChore)
        }
        
        completedTime.text = "完成時間：\(chore.completedDate)"
        
        print("TimeStamp: \(chore.completedDate)")
    }
    
}
