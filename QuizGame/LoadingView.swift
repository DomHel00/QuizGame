//  LoadingView.swift
//  Created by Dominik Hel on 30.10.2021.

//  MARK: - Imports
import UIKit

//  MARK: - Class LoadingView
final class LoadingView: UIView {
    //  MARK: - UI components
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = .label
        spinner.style = .large
        return spinner
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Downloading data..."
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .label
        titleLabel.textAlignment = .center
        return titleLabel
    }()
    
    //  MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemGray3
        self.addSubview(spinner)
        self.addSubview(titleLabel)
        spinner.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Init error!")
    }
    
    //  MARK: - Functions
    public func stop() {
        spinner.stopAnimating()
    }
    
    //  MARK: - Life cycle functions
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            spinner.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            spinner.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            spinner.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            spinner.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7),
            
            titleLabel.topAnchor.constraint(equalTo: spinner.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
