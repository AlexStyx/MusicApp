//
//  SearchMusicViewController.swift
//  MusicApp
//
//  Created by Александр Бисеров on 8/22/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage

protocol SearchMusicDisplayLogic: AnyObject {
    func displayData(viewModel: SearchMusic.Model.ViewModel.ViewModelData)
}

class SearchMusicViewController: UIViewController, SearchMusicDisplayLogic {
    
    var interactor: SearchMusicBusinessLogic?
    var router: (NSObjectProtocol & SearchMusicRoutingLogic)?
    var playerViewNavigationDelegate: SlideOutNavigationDelegate?
    
    private var timer: Timer?
    private lazy var footerView = FooterView()
    
    private var viewModel: TracksViewModel? {
        didSet {
            tableView.reloadData()
            footerView.hide()
        }
    }
    
    // MARK: - Setup
    
    private func setup() {
        let viewController        = self
        let interactor            = SearchMusicInteractor()
        let presenter             = SearchMusicPresenter()
        let router                = SearchMusicRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        addSubviews()
        layout()
        setupSeachController()
    }
    
    
    func displayData(viewModel: SearchMusic.Model.ViewModel.ViewModelData) {
        switch viewModel {
        case .displeyTracks(let searchViewModel):
            self.viewModel = searchViewModel
        case .displayFooter:
            footerView.show()
        }
    }
    
    
    //MARK: - Setup UI
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TrackCell.self, forCellReuseIdentifier: TrackCell.reuseId)
        tableView.tableFooterView = footerView
        return tableView
    }()
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
    
    private func layout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupSeachController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
    }
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension SearchMusicViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.cells.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let trackCell = tableView.dequeueReusableCell(withIdentifier: TrackCell.reuseId, for: indexPath) as? TrackCell,
            let trackCellViewModel = viewModel?.cells[indexPath.row]
        else { fatalError("Cannot cast to track cell") }
        trackCell.setup(viewModel: trackCellViewModel)
        return trackCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard
            let trackCellViewModel = viewModel?.cells[indexPath.row]
        else { return }
        playerViewNavigationDelegate?.slideUp(viewModel: trackCellViewModel)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        viewModel?.cells.isEmpty ?? true ? 250 : 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Search music"
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
}

//MARK: - UISearchBarDelegate
extension SearchMusicViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
            self?.interactor?.makeRequest(request: .requestTracks(searchText: searchText))
        })
    }
}

//MARK: - PlayerDelegate
extension SearchMusicViewController: PlayerDelegate {
    func goToNextTrack() -> TrackCellViewModelType? {
        getTrack(isNext: true)
    }
    
    func goToPreviousTrack() -> TrackCellViewModelType? {
        getTrack(isNext: false)
    }
    
    
    private func getTrack(isNext: Bool) -> TrackCellViewModelType? {
        guard let currentIndexPath = tableView.indexPathForSelectedRow else { return nil }
        tableView.deselectRow(at: currentIndexPath, animated: true)
        var nextIndexPath = currentIndexPath
        if isNext  {
            nextIndexPath.row += 1
            if nextIndexPath.row == viewModel?.cells.count {
                nextIndexPath.row = 0
            }
        } else {
            nextIndexPath.row -= 1
            if nextIndexPath.row == -1 {
                nextIndexPath.row = (viewModel?.cells.count ?? 1) - 1
            }
        }
        tableView.selectRow(at: nextIndexPath, animated: true, scrollPosition: .none)
        return viewModel?.cells[nextIndexPath.row]
    }
}

