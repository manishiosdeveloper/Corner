//
//  ReactionCollectionViewCell.swift
//  Corner
//
//  Created by manish singh on 02/10/24.
//

import UIKit

enum ReactionType {
    case reaction
    case bookmark
    case comment
}

struct ReactionCollectionViewCellModel {
    let title: String
    var shouldHighlight: Bool
    let type: ReactionType
}

protocol ReactionCollectionViewCellDelegate: AnyObject {
    func reactionCollectionViewCell(
        _ cell: ReactionCollectionViewCell,
        didSelect reaction: ReactionType
    )
}

class ReactionCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ReactionCollectionViewCell"
    
    weak var delegate: ReactionCollectionViewCellDelegate?
    
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

extension ReactionCollectionViewCell {
    func configure(with model: ReactionCollectionViewCellModel) {
        self.dataSource = model
        reactionButton.setTitle(model.title, for: .normal)
        switch model.type {
        case .reaction:
            reactionButton.setImage(nil, for: .normal)
        case .bookmark, .comment:
            assertionFailure("should not be possible case")
        }
        shouldMarkHighlight(model.shouldHighlight)
    }
}

private extension ReactionCollectionViewCell {
    func shouldMarkHighlight(_ shouldHighlight: Bool) {
        let color = shouldHighlight ? UIColor.black : UIColor.lightGray
        reactionButton.setTitleColor(color, for: .normal)
    }
}
