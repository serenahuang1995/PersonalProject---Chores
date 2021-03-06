//
//  ChoresRecordsViewController.swift
//  Chores
//
//  Created by 黃瀞萱 on 2021/5/17.
//

import UIKit

class ChoresRecordsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView! {
        
        didSet {
            
            setUpTableView()
        }
    }
    
    var finishedChoresList: [[Chore]] = []
    
    var selectedIndex: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpRecordsListener()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let destination = segue.destination as? DetailRecordsViewController else { return }
        
        destination.chores = finishedChoresList[selectedIndex]
    }
    
    private func setUpTableView() {
                
        tableView.registerCellWithNib(
            identifier: String(describing: RecordsTableViewCell.self), bundle: nil)
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
    }
    
    func setUpRecordsListener() {
        
        FirebaseProvider.shared.fetchDifferentChoreType { [weak self] result in
            
            switch result {
            
            case .success(let choresList):
                
                self?.finishedChoresList = choresList

                self?.tableView.reloadData()
            
            case .failure(let error):
                
                print(error)
            }
        }
    }
}

extension ChoresRecordsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedIndex = indexPath.row
        
        performSegue(withIdentifier: Segue.detail, sender: nil)
    }
}

extension ChoresRecordsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return finishedChoresList.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let index = indexPath.row
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: RecordsTableViewCell.self),
            for: indexPath)
        
        guard let recordsCell = cell as? RecordsTableViewCell else { return cell }
        
        recordsCell.layoutCell(chores: finishedChoresList[index])
        
        recordsCell.selectionStyle = .none

        return recordsCell
    }
}
