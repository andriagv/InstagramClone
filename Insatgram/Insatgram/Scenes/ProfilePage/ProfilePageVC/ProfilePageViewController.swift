//
//  ProfilePageViewController.swift
//  Insatgram
//
//  Created by irakli kharshiladze on 22.11.24.
//

import UIKit

final class ProfilePageViewController: UIViewController {
    
    private let infoViewModel = UserInfoViewModel()
    private let collectionViewModel = CollectionViewModel()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let userInfoViewController: UserInfoView = {
        let viewController = UserInfoView()
        return viewController
    }()
    
    private let userFotoCollectionView: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical
        
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = (screenWidth - 20) / 3
        collectionLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collection.backgroundColor = .clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUi()
    }
    
    private func setupUi() {
        setupScrollView()
        setupUserInfoView()
        setupCollectionView()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor , constant: -10),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupUserInfoView() {
        addChild(userInfoViewController)
        contentView.addSubview(userInfoViewController.view)
        userInfoViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            userInfoViewController.view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -50),
            userInfoViewController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            userInfoViewController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            userInfoViewController.view.heightAnchor.constraint(equalToConstant: 380)
        ])
        userInfoViewController.didMove(toParent: self)
    }
    
    private func setupCollectionView() {
        
        contentView.addSubview(userFotoCollectionView)
        
        userFotoCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ImageViewCell")
        userFotoCollectionView.dataSource = self
        
        NSLayoutConstraint.activate([
            userFotoCollectionView.topAnchor.constraint(equalTo: userInfoViewController.view.bottomAnchor, constant: 10),
            userFotoCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            userFotoCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            userFotoCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            userFotoCollectionView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
}

extension ProfilePageViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionViewModel.imageArrayCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageViewCell", for: indexPath)
        let currentImageUrl = collectionViewModel.getImage(at: indexPath.row)
        let imageView = UIImageView()
        if let URL = URL(string: currentImageUrl) {
            imageView.imageFrom(url: URL)
        }
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.frame = cell.bounds
        cell.contentView.addSubview(imageView)
        return cell
    }
}

