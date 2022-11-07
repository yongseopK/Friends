//
//  FriendTableViewCell.swift
//  Friends
//
//  Created by yongseopKim on 2022/11/07.
//

import UIKit

// MARK: - Delegate
protocol FriendTableViewCellDelegate {
    func friendCellStarredStateChanged(_ sender: FriendTableViewCell)
}

class FriendTableViewCell: UITableViewCell {

    //두 개의 테이블 뷰에서 공통으로 사용할 셀 클래스
    //MARK: - Properties
    var delegate: FriendTableViewCellDelegate?
    
    //MARK: - IBOulets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nationalityLabel: UILabel!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var starButton: UIButton!
    
    //MARK: - Methods
    @IBAction func touchUpStarButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if let delegate = self.delegate {
            delegate.friendCellStarredStateChanged(self)
        }
    }
}

extension FriendTableViewCell {
    func configure(friend: Person, tableView: UITableView, indexPath: IndexPath) {
        
        self.nameLabel.text = friend.name.full
        self.nationalityLabel.text = friend.nationality
        self.cellLabel.text = friend.cell
        self.starButton.isSelected = Person.bestFriends.contains(friend)
        
        self.profileImageView.image = placeHolderImage
        
        Request.image(friend.pictureURL.thumbnail, completion: { ( image: UIImage?) in
            DispatchQueue.main.async {
                guard let cell: FriendTableViewCell = tableView.cellForRow(at: indexPath) as? FriendTableViewCell else {
                    return
                }
                cell.profileImageView.image = image
            }
        })
    }
}
