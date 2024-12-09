//
//  LikesPageViewController.swift
//  Instagram
//
//  Created by irakli kharshiladze on 22.11.24.
//
 
import UIKit
 
final class LikesPageViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let tableView = UITableView()
    private let viewModel = LikesPageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        scrollView.frame = view.bounds
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.contentSize = CGSize(width: view.bounds.width, height: view.bounds.height + 100)
        view.addSubview(scrollView)
        
        contentView.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
        scrollView.addSubview(contentView)
        
        tableView.frame = contentView.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "HeaderView")
        contentView.addSubview(tableView)
    }
} 
extension LikesPageViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int { return viewModel.sections.count }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return viewModel.sections[section].1.count }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 70 }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderView")
        header?.textLabel?.text = viewModel.sections[section].0
        header?.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        header?.textLabel?.textColor = .black
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "LikesCell")
        let item = viewModel.sections[indexPath.section].1[indexPath.row]
        let profileImageView = UIImageView(frame: CGRect(x: 16, y: 8, width: 44, height: 44))
        profileImageView.layer.cornerRadius = 22
        profileImageView.clipsToBounds = true
        profileImageView.image = UIImage(named: item.profileImageName)
        cell.contentView.addSubview(profileImageView)
        
        let messageLabel = UILabel(frame: CGRect(x: 72, y: 22, width: 230, height: 16))
        messageLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        messageLabel.numberOfLines = 2
        messageLabel.text = item.message
        cell.contentView.addSubview(messageLabel)
        
        if let postImageName = item.postImageName {
            let postImageView = UIImageView(frame: CGRect(x: 315, y: 8, width: 44, height: 44))
            postImageView.image = UIImage(named: postImageName)
            postImageView.clipsToBounds = true
            cell.contentView.addSubview(postImageView)
        } else {
            let followButton = FollowButton()
            followButton.translatesAutoresizingMaskIntoConstraints = false
            cell.contentView.addSubview(followButton)
            NSLayoutConstraint.activate([
                followButton.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 20),
                followButton.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -10),
                followButton.widthAnchor.constraint(equalToConstant: 90),
                followButton.heightAnchor.constraint(equalToConstant: 28)
            ])
        }
        return cell
    }
}
