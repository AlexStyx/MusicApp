//
//  FooterView.swift
//  MusicApp
//
//  Created by Александр Бисеров on 8/24/21.
//

import UIKit
import SnapKit

class FooterView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "LOADING"
        label.isHidden = true
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .center
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private func setupUI() {
        addSubviews()
        layout()
    }
    
    private func addSubviews() {
        addSubview(loadingLabel)
        addSubview(activityIndicator)
    }
    
    private func layout() {
        loadingLabel.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(5)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.top.equalTo(loadingLabel.snp.bottom)
        }
    }
    
    func hideFooterView() {
        activityIndicator.stopAnimating()
        loadingLabel.isHidden = true
    }
    
    func showFooterView() {
        activityIndicator.startAnimating()
        loadingLabel.isHidden = false
    }
    
}


