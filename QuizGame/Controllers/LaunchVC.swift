//  LaunchVC.swift
//  Created by Dominik Hel on 30.10.2021.

//  MARK: - Imports
import UIKit

//  MARK: - Class LaunchVC
final class LaunchVC: UIViewController {    
    //  MARK: - UI components
    private let backgroundImage: UIImageView = {
        let backgroundImage = UIImageView()
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.image = UIImage(named: "Logo")
        backgroundImage.contentMode = .scaleAspectFit
        backgroundImage.clipsToBounds = true
        return backgroundImage
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: UIFont(name: "Bradley Hand", size: 40)!)
        titleLabel.text = "QUIZ GAME"
        titleLabel.textColor = .systemOrange
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        return titleLabel
    }()
    
    private let subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: UIFont(name: "Bradley Hand", size: 36)!)
        subtitleLabel.text = "Downloading data"
        subtitleLabel.textColor = .white
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        return subtitleLabel
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.style = .large
        spinner.color = .white
        return spinner
    }()
    
    //  MARK: - Functions
    private func startFetching() {
        if spinner.isAnimating == false {
            spinner.startAnimating()
        }
        if (InternetMonitor.shared.isConnected) {
            CategoryProvider.shared.fetchCategoris { [weak self] results in
                switch(results) {
                case .failure(let error):
                    DispatchQueue.main.async {
                        print(error)
                        let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "Cancle", style: .cancel, handler: nil)
                        alert.addAction(alertAction)
                        self?.spinner.stopAnimating()
                        self?.present(alert, animated:  true, completion: nil)
                    }
                case.success(let results):
                    DispatchQueue.main.async {
                        self?.spinner.stopAnimating()
                        let menuVc = MenuVC(categories: results)
                        let navigationVC = UINavigationController(rootViewController: menuVc)
                        navigationVC.modalPresentationStyle = .fullScreen
                        self?.spinner.stopAnimating()
                        self?.present(navigationVC, animated: true, completion: nil)
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                let alert = UIAlertController(title: "No Internet Connection", message: "Bad connection", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Cancle", style: .cancel) { _ in
                    self.startFetching()
                }
                alert.addAction(alertAction)
                self.present(alert, animated:  true, completion: nil)
            }}
    }
    
    //  MARK: - Life cycle functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.all)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            
            titleLabel.topAnchor.constraint(equalTo: backgroundImage.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            subtitleLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12),
            
            spinner.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 10),
            spinner.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            spinner.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            spinner.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        view.addSubview(backgroundImage)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(spinner)
        
        spinner.startAnimating()
        startFetching()
    }
}
