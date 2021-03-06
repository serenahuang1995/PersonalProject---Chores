//
//  DetailRecordsViewController.swift
//  Chores
//
//  Created by 黃瀞萱 on 2021/6/14.
//

import UIKit
import MIBlurPopup

class DetailRecordsViewController: UIViewController {

    @IBOutlet weak var cardView: CardView!
    
    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            setUpTableView()
        }
    }
    
    var chores: [Chore] = []
    
    let blackView = BlackView(frame: UIScreen.main.bounds)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presentingViewController?.view.addSubview(blackView)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        blackView.removeFromSuperview()

        dismiss(animated: false, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch: UITouch? = touches.first
        
        if touch?.view != cardView {
            
            blackView.removeFromSuperview()
            
            dismiss(animated: true, completion: nil)
        }
    }
        
    private func setUpTableView() {
        
        tableView.registerCellWithNib(
            identifier: String(describing: DetailTableViewCell.self), bundle: nil)
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        
        tableView.layer.cornerRadius = 20
    }
}

extension DetailRecordsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 85
    }
}

extension DetailRecordsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return chores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = indexPath.row
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: DetailTableViewCell.self),
            for: indexPath)
        
        guard let detailCell = cell as? DetailTableViewCell else { return cell }
        
        detailCell.selectionStyle = .none
        
        detailCell.layoutCell(chore: chores[index])
        
        return detailCell
    }
}
