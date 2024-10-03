//
//  ReactionCollectionViewCell.swift
//  Corner
//
//  Created by manish singh on 02/10/24.
//

import UIKit

protocol UserMetaCollectionViewCellDelegate: AnyObject {
    func reactionCollectionViewCell(
        _ cell: UserMetaCollectionViewCell,
        didSelect reaction: ReactionType
    )
}

class UserMetaCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "UserMetaCollectionViewCell"
    
    weak var delegate: UserMetaCollectionViewCellDelegate?
    
    @IBOutlet private weak var reactionButton: UIButton!
    
    private var dataSource: ReactionCollectionViewCellModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        reactionButton.layer.cornerRadius = 20
        reactionButton.layer.borderWidth = 1
        reactionButton.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
        reactionButton.setTitleColor(UIColor.color_166_166_166, for: .normal)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        reactionButton.imageView?.image = nil
    }
    
    @IBAction func reactionButtonAction(_ sender: Any) {
        delegate?.reactionCollectionViewCell(self, didSelect: dataSource.type)
    }
}

extension UserMetaCollectionViewCell {
    func configure(with model: ReactionCollectionViewCellModel) {
        self.dataSource = model
        reactionButton.setTitle(model.title, for: .normal)
        switch model.type {
        case .reaction:
            assertionFailure("should not be possible case")
        case .bookmark:
            reactionButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
        case .comment:
            reactionButton.setImage(UIImage(systemName: "message"), for: .normal)
        }
        shouldMarkHighlight(model.shouldHighlight)
    }
}

private extension UserMetaCollectionViewCell {
    func shouldMarkHighlight(_ shouldHighlight: Bool) {
        let color = shouldHighlight ? UIColor.black : UIColor.lightGray
        reactionButton.setTitleColor(color, for: .normal)
    }
}
