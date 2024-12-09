//
//  MainPageTableViewCell.swift
//  Insatgram
//
//  Created by Mac User on 23.11.24.
//

import UIKit

final class NewsFeedTableViewCell: UITableViewCell {
    
    private let mainViewModel = MainPageViewModel()
    private let instagramLogoImage = UIImageView()
    private let postAutorPhoto = UIImageView()
    private let postAutorName = UILabel()
    private let postLocation = UILabel()
    private let postAutorOfficialIcon = UIImageView()
    private let likeButton = UIButton(type: .custom)
    private let commentButton = UIButton(type: .custom)
    private let forwardButton = UIButton(type: .custom)
    private let postDetailsPhoto = UIImageView()
    private let postDetailsLikelabel = UILabel()
    private let postTextLabelUserName = UILabel()
    private let postText = UILabel()
    private let postDetailsDateLabel = UILabel()
    
    var post: Post?
    weak var parentViewController: UIViewController?
    
    private lazy var newsFeedPhotosCollectionView: UICollectionView = {
        
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .horizontal
        let screenWidth = UIScreen.main.bounds.width
        let itemWidth = screenWidth
        collectionLayout.itemSize = CGSize(width: itemWidth, height: 407)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collection.backgroundColor = .clear
        collection.isPagingEnabled = true
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private let postAutorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let viewForButtons: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.hidesForSinglePage = true
        return pageControl
    }()
    
    private let viewForPostDetails: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .white
        return stackView
    }()
    
    private let currentPageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        label.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        label.layer.cornerRadius = 15
        label.textAlignment = .center
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupPostAutorView()
        setupMainCollectionView()
        setupViewForButtons()
        setupViewForPostDetails()
    }
    
    private func setupPostAutorView() {
        contentView.addSubview(postAutorView)
        postAutorView.translatesAutoresizingMaskIntoConstraints = false
        
        postAutorView.addSubview(postAutorPhoto)
        postAutorPhoto.translatesAutoresizingMaskIntoConstraints = false
        postAutorPhoto.clipsToBounds = true
        
        postAutorView.addSubview(postAutorName)
        postAutorName.translatesAutoresizingMaskIntoConstraints = false
        postAutorName.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        postAutorName.textColor = .black
        
        postAutorView.addSubview(postLocation)
        postLocation.translatesAutoresizingMaskIntoConstraints = false
        postLocation.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        postLocation.textColor = .black
        
        postAutorView.addSubview(postAutorOfficialIcon)
        postAutorOfficialIcon.translatesAutoresizingMaskIntoConstraints = false
        postAutorOfficialIcon.image = UIImage(named: "OfficialIcon")
        
        NSLayoutConstraint.activate([
            
            postAutorView.topAnchor.constraint(equalTo: contentView.topAnchor),
            postAutorView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            postAutorView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            postAutorView.heightAnchor.constraint(equalToConstant: 60),
            
            postAutorPhoto.centerYAnchor.constraint(equalTo: postAutorView.centerYAnchor),
            postAutorPhoto.leftAnchor.constraint(equalTo: postAutorView.leftAnchor, constant: 10),
            postAutorPhoto.heightAnchor.constraint(equalToConstant: 35),
            postAutorPhoto.widthAnchor.constraint(equalToConstant: 32),
            
            postAutorName.topAnchor.constraint(equalTo: postAutorPhoto.topAnchor),
            postAutorName.leftAnchor.constraint(equalTo: postAutorPhoto.rightAnchor, constant: 10),
            
            postLocation.bottomAnchor.constraint(equalTo: postAutorPhoto.bottomAnchor),
            postLocation.leftAnchor.constraint(equalTo: postAutorName.leftAnchor),
            
            postAutorOfficialIcon.centerYAnchor.constraint(equalTo: postAutorName.centerYAnchor),
            postAutorOfficialIcon.leftAnchor.constraint(equalTo: postAutorName.rightAnchor, constant: 3),
            postAutorOfficialIcon.heightAnchor.constraint(equalToConstant: 10),
            postAutorOfficialIcon.widthAnchor.constraint(equalToConstant: 10),
        ])
    }
    
    private func setupMainCollectionView() {
        contentView.addSubview(newsFeedPhotosCollectionView)
        newsFeedPhotosCollectionView.register(MainPageCollectionViewCell.self, forCellWithReuseIdentifier: "MainPageCollectionViewCell")
        newsFeedPhotosCollectionView.delegate = self
        newsFeedPhotosCollectionView.dataSource = self
        contentView.addSubview(currentPageLabel)
        
        NSLayoutConstraint.activate([
            
            newsFeedPhotosCollectionView.topAnchor.constraint(equalTo: postAutorView.bottomAnchor),
            newsFeedPhotosCollectionView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            newsFeedPhotosCollectionView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            newsFeedPhotosCollectionView.heightAnchor.constraint(equalToConstant: 407),
            
            currentPageLabel.topAnchor.constraint(equalTo: newsFeedPhotosCollectionView.topAnchor, constant: 15),
            currentPageLabel.rightAnchor.constraint(equalTo: newsFeedPhotosCollectionView.rightAnchor, constant: -14),
            currentPageLabel.widthAnchor.constraint(equalToConstant: 34),
            currentPageLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    private func updateButton() {
        let imageName = post?.userHasLiked == true ? "HeartFill" : "Heart"
        likeButton.setImage(UIImage(named: imageName), for: .normal)
    }
    
    private func setupViewForButtons() {
        contentView.addSubview(viewForButtons)
        viewForButtons.translatesAutoresizingMaskIntoConstraints = false
        
        viewForButtons.addSubview(likeButton)
        likeButton.backgroundColor = .none
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.setImage(UIImage(named: "Heart"), for: .normal)
        likeButton.tintColor = .black
        
        viewForButtons.addSubview(commentButton)
        commentButton.backgroundColor = .none
        commentButton.translatesAutoresizingMaskIntoConstraints = false
        commentButton.setImage(UIImage(named: "CommentIcon"), for: .normal)
        commentButton.tintColor = .black
        
        viewForButtons.addSubview(forwardButton)
        forwardButton.backgroundColor = .none
        forwardButton.translatesAutoresizingMaskIntoConstraints = false
        forwardButton.setImage(UIImage(named: "ForwardIcon"), for: .normal)
        forwardButton.tintColor = .black
        
        pageControl.currentPage = 0
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        viewForButtons.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            
            viewForButtons.topAnchor.constraint(equalTo: newsFeedPhotosCollectionView.bottomAnchor),
            viewForButtons.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            viewForButtons.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            viewForButtons.heightAnchor.constraint(equalToConstant: 53),
            
            likeButton.leftAnchor.constraint(equalTo: viewForButtons.leftAnchor, constant: 14),
            likeButton.centerYAnchor.constraint(equalTo: viewForButtons.centerYAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 23),
            likeButton.heightAnchor.constraint(equalToConstant: 23),
            
            commentButton.leftAnchor.constraint(equalTo: likeButton.rightAnchor, constant: 17.5),
            commentButton.centerYAnchor.constraint(equalTo: viewForButtons.centerYAnchor),
            commentButton.widthAnchor.constraint(equalToConstant: 23),
            commentButton.heightAnchor.constraint(equalToConstant: 23),
            
            forwardButton.leftAnchor.constraint(equalTo: commentButton.rightAnchor, constant: 17.5),
            forwardButton.centerYAnchor.constraint(equalTo: viewForButtons.centerYAnchor),
            forwardButton.widthAnchor.constraint(equalToConstant: 23),
            forwardButton.heightAnchor.constraint(equalToConstant: 23),
            
            pageControl.centerYAnchor.constraint(equalTo: viewForButtons.safeAreaLayoutGuide.centerYAnchor),
            pageControl.centerXAnchor.constraint(equalTo: viewForButtons.centerXAnchor)
        ])
        
        likeButton.addAction(UIAction(handler: { [weak self] action in
            guard let self = self else { return }
            self.post?.userHasLiked.toggle()
            self.updateButton()
        }), for: .touchUpInside)
        
        forwardButton.accessibilityLabel = "Share this content"
        forwardButton.addAction(UIAction(handler: { [weak self] action in
            guard let self = self else { return }
            self.shareContent()
        }), for: .touchUpInside)
    }
    
    private func setupViewForPostDetails() {
        contentView.addSubview(viewForPostDetails)
        viewForPostDetails.translatesAutoresizingMaskIntoConstraints = false
        
        viewForPostDetails.addSubview(postDetailsPhoto)
        postDetailsPhoto.translatesAutoresizingMaskIntoConstraints = false
        postDetailsPhoto.clipsToBounds = true
        
        viewForPostDetails.addSubview(postDetailsLikelabel)
        postDetailsLikelabel.translatesAutoresizingMaskIntoConstraints = false
        postDetailsLikelabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        postDetailsLikelabel.textColor = .black
        
        viewForPostDetails.addSubview(postTextLabelUserName)
        postTextLabelUserName.translatesAutoresizingMaskIntoConstraints = false
        postTextLabelUserName.font = UIFont.systemFont(ofSize: 13, weight: .bold)
        postTextLabelUserName.numberOfLines = 0
        postTextLabelUserName.sizeToFit()
        postTextLabelUserName.textColor = .black
        
        viewForPostDetails.addSubview(postText)
        postText.translatesAutoresizingMaskIntoConstraints = false
        postText.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        postText.numberOfLines = 0
        postText.sizeToFit()
        postText.textColor = .black
        
        viewForPostDetails.addSubview(postDetailsDateLabel)
        postDetailsDateLabel.translatesAutoresizingMaskIntoConstraints = false
        postDetailsDateLabel.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        postDetailsDateLabel.textColor = .gray
        
        NSLayoutConstraint.activate([
            
            viewForPostDetails.topAnchor.constraint(equalTo: viewForButtons.bottomAnchor),
            viewForPostDetails.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            viewForPostDetails.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            viewForPostDetails.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            postDetailsPhoto.topAnchor.constraint(equalTo: viewForPostDetails.topAnchor),
            postDetailsPhoto.leftAnchor.constraint(equalTo: likeButton.leftAnchor),
            postDetailsPhoto.heightAnchor.constraint(equalToConstant: 18.5),
            postDetailsPhoto.widthAnchor.constraint(equalToConstant: 17),
            
            postDetailsLikelabel.topAnchor.constraint(equalTo: postDetailsPhoto.topAnchor),
            postDetailsLikelabel.leftAnchor.constraint(equalTo: postDetailsPhoto.rightAnchor, constant: 6.5),
            
            postTextLabelUserName.topAnchor.constraint(equalTo: postDetailsPhoto.bottomAnchor, constant: 5),
            postTextLabelUserName.leftAnchor.constraint(equalTo: postDetailsPhoto.leftAnchor),
            
            postText.centerYAnchor.constraint(equalTo: postTextLabelUserName.centerYAnchor),
            postText.leftAnchor.constraint(equalTo: postTextLabelUserName.rightAnchor, constant: 5),
            
            postDetailsDateLabel.topAnchor.constraint(equalTo: postTextLabelUserName.bottomAnchor, constant: 13),
            postDetailsDateLabel.leftAnchor.constraint(equalTo: postDetailsPhoto.leftAnchor),
        ])
    }
    
    func configureCell(post: Post) {
        
        postAutorPhoto.imageFrom(url: URL(string: (post.caption?.from.profilePicture)!)!)
        postDetailsPhoto.imageFrom(url: URL(string: (post.likes.data[0].profilePicture))!)
        postAutorName.text = post.caption?.from.username
        postLocation.text = post.location?.name
        postDetailsLikelabel.text = "Liked by \(post.likes.data[0].username) and \(post.likes.count) others"
        postTextLabelUserName.text = post.caption?.from.username ?? ""
        postText.text = post.caption?.text ?? ""
        postDetailsDateLabel.text = mainViewModel.dataFormat(with: post.caption?.createdTime ?? "")
        currentPageLabel.text = post.images.count > 1 ? "1 \(post.images.count)" : ""
        if  post.images.count > 1 {
            currentPageLabel.text = "1/\(post.images.count)"
        } else {
            currentPageLabel.isHidden = true
        }
        pageControl.numberOfPages = post.images.count
        updateButton()
    }
    
    func shareContent() {
        let textToShare = "https://instagram.com/\(post?.caption?.from.username ?? "")"
        let imageToShare = UIImage(named: "exampleImage")
        let urlToShare = URL(string: "https://instagram.com/\(post?.caption?.from.username ?? "")")
        let items: [Any] = [textToShare, imageToShare as Any, urlToShare as Any].compactMap { $0 }
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [.addToReadingList, .assignToContact]
        parentViewController?.present(activityViewController, animated: true)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        postAutorPhoto.layer.cornerRadius = postAutorPhoto.frame.size.width / 2
        postDetailsPhoto.layer.cornerRadius = postDetailsPhoto.frame.size.width / 2
    }
}

extension NewsFeedTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        post?.images.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainPageCollectionViewCell", for: indexPath) as! MainPageCollectionViewCell
        let currentPage = Int(round(collectionView.contentOffset.x / collectionView.bounds.width))
        pageControl.currentPage = currentPage
        if let imageURLString = post?.images[indexPath.row].imageURL,
           let imageURL = URL(string: imageURLString) {
            cell.postPhoto.imageFrom(url: imageURL)
        } else {
            print("Invalid image URL")
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
        currentPageLabel.text = "\(currentPage + 1)/\(pageControl.numberOfPages)"
        pageControl.currentPage = currentPage
    }
    
}
