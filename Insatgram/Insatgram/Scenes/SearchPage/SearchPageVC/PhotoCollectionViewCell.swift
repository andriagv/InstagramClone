//
//  PhotoCollectionViewCell.swift
//  Instagram
//
//  Created by Elene on 24.11.24.
//
import Foundation
import UIKit

final class PhotoCollectionViewCell: UICollectionViewCell {
    static let identifier = "PhotoCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let overlayIcon: UIImageView = {
        let icon = UIImageView(image: UIImage(systemName: "square.fill.on.square.fill"))
        icon.contentMode = .scaleAspectFit
        icon.tintColor = .white
        icon.isHidden = true
        return icon
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(overlayIcon)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
        
        let iconSize: CGFloat = 25
        overlayIcon.frame = CGRect(
            x: contentView.frame.width - iconSize - 8,
            y: 8,
            width: iconSize,
            height: iconSize
        )
    }
    
    func configure(with media: MediaModel, showOverlay: Bool = false) {
        guard let url = URL(string: media.imageUrl) else { return }
        
        imageView.imageFrom(url: url)
        
        if showOverlay {
            overlayIcon.isHidden = false
            overlayIcon.transform = CGAffineTransform(scaleX: -1.1, y: -1.1)
            
        } else {
            overlayIcon.isHidden = true
            overlayIcon.transform = .identity
        }
    }
}
