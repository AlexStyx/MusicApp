//
//  SavedMusicViewController.swift
//  MusicApp
//
//  Created by Александр Бисеров on 8/23/21.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SavedMusicDisplayLogic: AnyObject {
    func displayData(viewModel: SavedMusic.Model.ViewModel.ViewModelData)
}

class SavedMusicViewController: UIViewController, SavedMusicDisplayLogic {
    
    var interactor: SavedMusicBusinessLogic?
    var router: (NSObjectProtocol & SavedMusicRoutingLogic)?

    
    // MARK: Setup
    
    private func setup() {
        let viewController        = self
        let interactor            = SavedMusicInteractor()
        let presenter             = SavedMusicPresenter()
        let router                = SavedMusicRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
    
    // MARK: Routing
    
    
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        view.backgroundColor = .orange
    }
    
    func displayData(viewModel: SavedMusic.Model.ViewModel.ViewModelData) {
        
    }
    
}
