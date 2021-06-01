//
//  InvitedCollectionViewCell.swift
//  Chores
//
//  Created by 黃瀞萱 on 2021/5/27.
//

import UIKit

private enum QRCode: String {
    
    case qrcodeCIFilter = "CIQRCodeGenerator"
    
    case qrcodeValue = "inputMessage"
}

class InvitedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var userIdLabel: UILabel!
    
    @IBOutlet weak var qrcodeImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func getUserQRCode(from string: String) -> UIImage? {
        
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: QRCode.qrcodeCIFilter.rawValue) {
            
            filter.setValue(data, forKey: QRCode.qrcodeValue.rawValue)
            
//            let scaleX = contentView.frame.size.width / qrcodeImage.size.width
//            let scaleY = contentView.frame.size.height / qrcodeImage.extent.size.height
            
            let transform = CGAffineTransform(scaleX: 8, y: 8)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
    
    func layoutCell() {
        
        userIdLabel.text = "使用者ID：\(UserProvider.shared.uid)"
        
        qrcodeImage.image = getUserQRCode(from: UserProvider.shared.uid)
    }
    
}
