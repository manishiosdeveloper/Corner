import UIKit

struct ReactionViewModel {
    let reactions: [Data]
    
    struct Data {
        let id: String
        let reaction: String
        let title: String
        let isCurrentUserReaction: Bool
        let reactionType: ReactionType
    }
}

protocol ReactionViewDelegate: AnyObject {
    func reactionView(_ view: ReactionView, didSelectItem id: String)
    func reactionView(_ view: ReactionView, didScrollTo position: CGPoint)
}

class ReactionView: UIView, NibLoadable {
    
    weak var delegate: ReactionViewDelegate?
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var datasource: ReactionViewModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        
        collectionView.register(cellType: ReactionCollectionViewCell.self)
        collectionView.register(cellType: UserMetaCollectionViewCell.self)
        
        collectionView.dataSource = self
        collectionView.delegate = self

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        
        collectionView.collectionViewLayout = flowLayout
    }
}

//MARK: -  UIScrollViewDelegate
extension ReactionView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.reactionView(
            self,
            didScrollTo: collectionView.contentOffset
        )
    }
}

extension ReactionView {
    func showReactions(reactions: ReactionViewModel, position: CGPoint) {
        self.datasource = reactions
        collectionView.reloadData()
        collectionView.setContentOffset(position, animated: false)
    }
}

// MARK: - UICollectionViewDataSource
extension ReactionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource?.reactions.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reaction = datasource.reactions[indexPath.item]
        
        var cell: UICollectionViewCell? {
            switch reaction.reactionType {
            case .bookmark,
                    .comment:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: UserMetaCollectionViewCell.identifier,
                    for: indexPath
                ) as? UserMetaCollectionViewCell
                cell?.configure(
                    with: .init(
                        title: reaction.title,
                        shouldHighlight: reaction.isCurrentUserReaction,
                        type: reaction.reactionType
                    )
                )
                return cell
            case .reaction:
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ReactionCollectionViewCell.identifier,
                    for: indexPath
                ) as? ReactionCollectionViewCell
                cell?.configure(
                    with: .init(
                        title: reaction.title,
                        shouldHighlight: reaction.isCurrentUserReaction,
                        type: reaction.reactionType
                    )
                )
                return cell
            }
        }
        
        return cell ?? UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegate
extension ReactionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.reactionView(
            self,
            didSelectItem: datasource.reactions[indexPath.item].id
        )
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ReactionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = datasource.reactions[indexPath.item].title.width(for: .systemFont(ofSize: 12))
        
        return CGSize(width: max((width + 50), 70), height: 40)
    }
}
