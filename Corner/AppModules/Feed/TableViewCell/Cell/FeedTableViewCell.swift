//
//  FeedTableViewCell.swift
//  Corner
//
//  Created by manish singh on 02/10/24.
//

import Foundation
import UIKit

protocol FeedTableViewCellDelegate: AnyObject {
    func feedTableViewCell(
        _ cell: FeedTableViewCell,
        didSelect tye: ReactionType,
        reaction: String,
        at indexPath: IndexPath
    )
    
    func feedTableViewCell(
        _ cell: FeedTableViewCell,
        didScrollReactionView position: CGPoint,
        at indexPath: IndexPath
    )
    
    func feedTableViewCell(
        _ cell: FeedTableViewCell,
        didChangedCurrentImage index: Int,
        at indexPath: IndexPath
    )
}

class FeedTableViewCell: UITableViewCell {
    
    static let identifier = FeedTableViewCell.getClassName()
    
    weak var delegate: FeedTableViewCellDelegate?
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var feedImageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var reactionHolderView: UIView!
    @IBOutlet private weak var floatingEvaporatorView: UIView!
    @IBOutlet private weak var imageIndicatorView: UIView!
    @IBOutlet private weak var imagePositionIndicatorStackView: UIStackView!
    
    private lazy var reactionView = ReactionView.loadFromNib()
    
    private var currentImageIndex: Int = .zero
    private var indexPath: IndexPath!
    private var dataSource: FeedTableViewCellModel?
    private var reactions: [ReactionViewModel.Data] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupReactionsView()
        containerView.layer.cornerRadius = 12
        containerView.addShadow()
        feedImageView.layer.cornerRadius = 12
        feedImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        feedImageView.layer.masksToBounds = true

        registerUITapGestureRecognizer()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        feedImageView.cancelImageLoad()
    }
    
    func setup(_ model: FeedTableViewCellModel, at indexPath: IndexPath) {
        self.dataSource = model
        self.indexPath = indexPath
        currentImageIndex = dataSource?.currentImageIndex ?? .zero
        setFeedImage(model.getImageURL(at: currentImageIndex))
        ImageCacheManager.cache(images: model.images, from: currentImageIndex)
        descriptionLabel.text = model.description
        showReactions()
        if model.images.count >= 2 {
            setupImageIndicatorStackView()
            updateIndicatorViews()
        } else {
            imageIndicatorView.isHidden = true
        }

    }
    
    func updateReactions(with model: FeedTableViewCellModel) {
        dataSource = model
        showReactions()
    }
}

private extension FeedTableViewCell {
    func registerUITapGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        feedImageView.isUserInteractionEnabled = true
        feedImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func imageTapped(_ sender: UITapGestureRecognizer) {
        let touchPoint = sender.location(in: feedImageView)
        let imageWidth = feedImageView.frame.size.width
        if touchPoint.x < imageWidth / 2 {
            showPreviousImage()
        } else {
            showNextImage()
        }
    }
}

private extension FeedTableViewCell {
    func showPreviousImage() {
        guard let images = dataSource?.images else {return}
        guard currentImageIndex > 0 else {return}
        currentImageIndex -= 1
        dataSource?.currentImageIndex = currentImageIndex
        setFeedImage(images[currentImageIndex])
        updateIndicatorViews()
        delegate?.feedTableViewCell(
            self,
            didChangedCurrentImage: currentImageIndex,
            at: indexPath
        )
        
        ImageCacheManager.cache(
            images: dataSource?.images ?? [],
            from: currentImageIndex
        )
    }
    
    func showNextImage() {
        guard let images = dataSource?.images else {return}
        guard currentImageIndex < images.count - 1 else {return}
        currentImageIndex += 1
        dataSource?.currentImageIndex = currentImageIndex
        setFeedImage(images[currentImageIndex])
        updateIndicatorViews()
        delegate?.feedTableViewCell(
            self,
            didChangedCurrentImage: currentImageIndex,
            at: indexPath
        )
        ImageCacheManager.cache(
            images: dataSource?.images ?? [],
            from: currentImageIndex
        )
    }
    
    func setFeedImage(_ image: String) {
        feedImageView.setImage(
            url: URL(
                string: image
            ),
            placeholder: nil
        )
    }
}

private extension FeedTableViewCell {
    func setupReactionsView() {
        reactionHolderView.addFullSizeSubview(reactionView)
        reactionView.delegate = self
    }
    
    func showReactions() {
        let saveCount = String(dataSource?.bookmarkCount ?? .zero)
        let commentCount = String(dataSource?.commentCount ?? .zero)
        let staticReactions: [ReactionViewModel.Data] = [.init(id: UUID().uuidString,
                                                         reaction: "",
                                                         title: saveCount,
                                                         isCurrentUserReaction: false,
                                                         reactionType: .bookmark),
                                                   .init(id: UUID().uuidString,
                                                         reaction: "",
                                                         title: commentCount, isCurrentUserReaction: false,
                                                         reactionType: .comment)]
        
        self.reactions.removeAll()
        self.reactions.append(contentsOf: staticReactions + generateAllReaction())
        reactionView.showReactions(
            reactions: .init(reactions: reactions),
            position: dataSource?.reactionScrollPosition ?? .zero
        )
    }
    
    func generateAllReaction() -> [ReactionViewModel.Data] {
        let currentUserReactions = dataSource?.currentUserReactions
        let suggestedReactions = dataSource?.suggestedReactions
        let reactionCount = dataSource?.reaction
        
        let reactions = suggestedReactions?.compactMap({
            reaction in
            let isCurrentUserUsedReaction = currentUserReactions?.contains(reaction) ?? false
            var impressionOnReaction: String {
                if let value = reactionCount?[reaction] {
                    return reaction + String(value)
                } else {
                    return reaction
                }
            }
            return ReactionViewModel.Data(
                id: UUID().uuidString,
                reaction: reaction,
                title: impressionOnReaction,
                isCurrentUserReaction: isCurrentUserUsedReaction,
                reactionType: .reaction
            )
        })
        
        return reactions ?? []
    }
}

//MARK: - ReactionViewDelegate
extension FeedTableViewCell: ReactionViewDelegate {
    func reactionView(_ view: ReactionView, didScrollTo position: CGPoint) {
        dataSource?.reactionScrollPosition = position
        delegate?.feedTableViewCell(self, didScrollReactionView: position, at: indexPath)
    }
    
    func reactionView(_ view: ReactionView, didSelectItem id: String) {
        guard let index = reactions.firstIndex(where: {$0.id == id}) else {return}
        delegate?.feedTableViewCell(
            self,
            didSelect: reactions[index].reactionType,
            reaction: reactions[index].reaction,
            at: indexPath
        )
        
        if let image = reactions[index].reaction.getImageForEmoji() {
            startFloatingImagesAnimation(image: image)
        }
    }
    
    func startFloatingImagesAnimation(image: UIImage) {
        for _ in 0..<50 {
            let imageView = UIImageView(image: image)
            let startX = CGFloat(arc4random_uniform(UInt32(self.floatingEvaporatorView.frame.width)))
            let startY = CGFloat(arc4random_uniform(UInt32(self.floatingEvaporatorView.frame.height)))
            
            imageView.frame = CGRect(x: startX, y: startY, width: 40, height: 40)
            self.floatingEvaporatorView.addSubview(imageView)
            
            let endX = CGFloat(arc4random_uniform(UInt32(self.floatingEvaporatorView.frame.width)))
            let endY = CGFloat(arc4random_uniform(100) + 100)
            
            UIView.animate(withDuration: 3.0, delay: 0.0, options: .curveEaseOut, animations: {
                imageView.frame = CGRect(x: endX, y: -endY, width: 20, height: 20)
                imageView.alpha = 0
            }) { _ in
                imageView.removeFromSuperview()
            }
        }
    }
}

//MARK: - SetupImageIndicatorStackView
private extension FeedTableViewCell {
    func setupImageIndicatorStackView() {
        guard let images = dataSource?.images else {return}
        imagePositionIndicatorStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for i in 0..<images.count {
            let indicatorView = UIView()
            indicatorView.layer.cornerRadius = 5
            indicatorView.backgroundColor = (i == currentImageIndex) ? .white : .clear
            indicatorView.translatesAutoresizingMaskIntoConstraints = false
            indicatorView.heightAnchor.constraint(equalToConstant: 4).isActive = true
            imagePositionIndicatorStackView.addArrangedSubview(indicatorView)
        }
    }
    
    func updateIndicatorViews() {
        for (index, view) in imagePositionIndicatorStackView.arrangedSubviews.enumerated() {
            view.backgroundColor = (index == currentImageIndex) ? .white : .clear
        }
    }
}
