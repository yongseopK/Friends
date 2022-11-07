//
//  FriendsViewController.swift
//  Friends
//
//  Created by yongseopKim on 2022/11/02.
//

import UIKit

class FriendViewController: UIViewController {
    
    // MARK: - Properties
    var thumbnailImage: UIImage?
    
    // MARK: -IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var nationalityLabel: UILabel!
    @IBOutlet var fullStarButton: UIBarButtonItem!
    @IBOutlet var emptyStarButton: UIBarButtonItem!
    
    // MARK: Stored Properties
    var friend: Person! {
        didSet {
            self.navigationItem.title = friend.name.first.uppercased()
            self.correctBarButtonState()
        }
    }
}

extension FriendViewController {
    private func correctBarButtonState() {
        self.navigationItem.rightBarButtonItem = nil
        
        let rightBarButtonItem: UIBarButtonItem
        
        if Person.bestFriends.contains(self.friend) {
            rightBarButtonItem = self.fullStarButton
        } else {
            rightBarButtonItem = self.emptyStarButton
        }
        self.navigationItem.rightBarButtonItems = [rightBarButtonItem]
    }
}

// MARK: - IBActions
extension FriendViewController {
    
    @IBAction func touchUpFullStarButton(_ sender: UIBarButtonItem) {
        Person.removeBestFriend(self.friend) { (isSuccess: Bool) in
            if isSuccess {
                self.correctBarButtonState()
            }
        }
    }

    @IBAction func touchUpEmptyStarButton(_ sender: UIBarButtonItem) {
        Person.addBestFriend(self.friend) { (isSuccess: Bool) in
            if isSuccess {
                self.correctBarButtonState()
            }
        }
    }
}

// MARK: - Life Cycle
extension FriendViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let friend: Person = self.friend else {
            return
        }
        
        self.correctBarButtonState()
        
        self.nameLabel.text = friend.name.full
        self.cellLabel.text = friend.cell
        self.nationalityLabel.text = friend.nationality
        self.imageView.image = self.thumbnailImage ?? placeHolderImage
        
        Request.image(friend.pictureURL.large) { (image: UIImage?) in
            self.imageView?.image = image
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if friend == nil {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
