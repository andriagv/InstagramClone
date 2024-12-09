//
//  MainPageCollectionViewCell.swift
//  Insatgram
//
//  Created by Mac User on 23.11.24.
//

import UIKit

final class MainPageCollectionViewCell: UICollectionViewCell {
    
    let postPhoto: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(postPhoto)
        postPhoto.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            postPhoto.topAnchor.constraint(equalTo: contentView.topAnchor),
            postPhoto.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postPhoto.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            postPhoto.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}



