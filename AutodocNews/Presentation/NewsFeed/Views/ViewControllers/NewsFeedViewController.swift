import UIKit
import Combine
import SafariServices

final class NewsFeedViewController: BaseViewController {
    // MARK: - Type Aliases
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, NewsItemViewModel>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, NewsItemViewModel>
    
    // MARK: - UI Components
    private lazy var collectionView: UICollectionView = {
        let layout = LayoutFactory.buildLayout(for: .news)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.registerAllCells()
        collection.register(SpinnerFooterView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                            withReuseIdentifier: SpinnerFooterView.reuseIdentifier)
        return collection
    }()
    
    private lazy var skeletonManager = SkeletonViewManager(collectionView: collectionView)
    
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.addTarget(self, action: #selector(didPullToRefresh), for: .valueChanged)
        return control
    }()
    
    // MARK: - Properties
    private var dataSource: DataSource?
    private var viewModel: NewsFeedViewModelProtocol
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init(viewModel: NewsFeedViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDataSource()
        bindViewModel()
        loadInitialContent()
    }
    
    override func setupViews() {
        setupCollectionView()
    }
    
    // MARK: - Actions
    @objc private func didPullToRefresh() {
        loadInitialContent()
    }
}

// MARK: - Setup & Configuration
private extension NewsFeedViewController {
    func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.refreshControl = refreshControl
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setCollectionViewScrolling(enabled: Bool) {
        collectionView.isScrollEnabled = enabled
    }
    
    func setupDataSource() {
        configureMainDataSource()
    }
    
    func configureMainDataSource() {
        dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(cellType: NewsCell.self, for: indexPath)
            cell.configure(with: item)
            return cell
        }
        
        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionFooter else { return nil }
            
            let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SpinnerFooterView.reuseIdentifier,
                for: indexPath
            ) as? SpinnerFooterView
            
            return footer
        }
    }
}

// MARK: - Data Management
private extension NewsFeedViewController {
    func loadInitialContent() {
        viewModel.loadInitial()
    }
    
    func applySnapshot(_ items: [NewsItemViewModel]) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        dataSource?.apply(snapshot, animatingDifferences: true)
    }
    
    func hideSkeleton() {
        guard let dataSource = dataSource else { return }
        skeletonManager.hideSkeleton(dataSource: dataSource)
    }
    
    func updateFooterSpinner(isLoading: Bool) {
        guard let footer = collectionView.visibleSupplementaryViews(
            ofKind: UICollectionView.elementKindSectionFooter).first as? SpinnerFooterView else { return }
        footer.configure(isLoading: isLoading)
    }
}

// MARK: - ViewModel Binding
private extension NewsFeedViewController {
    func bindViewModel() {
        viewModel.statePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                self?.handle(state: state)
            }
            .store(in: &cancellables)
        
        viewModel.isPaginatingPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] isPaginating in
                self?.updateFooterSpinner(isLoading: isPaginating)
            }
            .store(in: &cancellables)
    }
    
    func handle(state: ViewState) {
        switch state {
        case .idle:
            break
        case .loading:
            setCollectionViewScrolling(enabled: false)
            skeletonManager.showSkeleton(count: LayoutConstants.NewsViewController.skeletonItemsCount)
        case .loaded(let items):
            setCollectionViewScrolling(enabled: true)
            hideSkeleton()
            applySnapshot(items)
            refreshControl.endRefreshing()
        case .error(let message):
            refreshControl.endRefreshing()
            showError(message) {
                self.viewModel.loadInitial()
            }
        case .noConnection(let message):
            refreshControl.endRefreshing()
            hideSkeleton()
            showError(message) {
                self.viewModel.loadInitial()
            }
        }
    }
}

// MARK: - UICollectionViewDelegate
extension NewsFeedViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let visibleHeight = scrollView.frame.size.height
        
        // Подгружаем следующую страницу заранее
        if offsetY > contentHeight - visibleHeight * LayoutConstants.NewsViewController.preloadThreshold {
            viewModel.loadNext()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedItem = dataSource?.itemIdentifier(for: indexPath) else {
            return
        }
        let url = selectedItem.fullUrl
        let safariVC = SFSafariViewController(url: url)
        
        present(safariVC, animated: true)
    }
}
