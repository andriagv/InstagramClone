//
//  FollowButton.swift
//  Insatgram
//
//  Created by Levan Gorjeladze on 22.11.24.
//

import UIKit

class FollowButton: UIButton {
    
    var isFollowing = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        self.frame = CGRect(x: (UIScreen.main.bounds.width - 90) / 2, y: 200, width: 90, height: 28)
        self.layer.cornerRadius = 4
        self.backgroundColor = UIColor(red: 55/255, green: 151/255, blue: 239/255, alpha: 1)
        self.setTitle("Follow", for: .normal)
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        self.titleLabel?.textAlignment = .center
        addTarget(self, action: #selector(toggleFollow), for: .touchUpInside)
    }
    
    @objc private func toggleFollow() {
        isFollowing.toggle()
        updateButtonState()
    }
    
    private func updateButtonState() {
        if isFollowing {
            self.setTitle("Unfollow", for: .normal)
            self.backgroundColor = UIColor(red: 55/255, green: 151/255, blue: 239/255, alpha: 0.5)
        } else {
            self.setTitle("Follow", for: .normal)
            self.backgroundColor = UIColor(red: 55/255, green: 151/255, blue: 239/255, alpha: 1)
        }
    }
}
