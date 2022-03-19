//  EndVC.swift
//  Created by Dominik Hel on 15.01.2022.

//  MARK: - Imports
import UIKit

//  MARK: - Class EndVC
final class EndVC: UIViewController {
    //  MARK: - Constants and variables
    private let numberOfCorrectAnswers: Int
    
    //  MARK: - UI components
    private let topBackgroundImage: UIImageView = {
        let topBackgroundImage = UIImageView()
        topBackgroundImage.translatesAutoresizingMaskIntoConstraints = false
        topBackgroundImage.image = UIImage(named: "topBackgroundImage")
        topBackgroundImage.contentMode = .scaleAspectFill
        topBackgroundImage.clipsToBounds = true
        return topBackgroundImage
    }()
    
    private let scoreLabel: UILabel = {
        let scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.font = .preferredFont(forTextStyle: .title2)
        scoreLabel.textColor = .label
        scoreLabel.textAlignment = .center
        scoreLabel.numberOfLines = 0
        return scoreLabel
    }()
    
    private let successLabel: UILabel = {
        let successLabel = UILabel()
        successLabel.translatesAutoresizingMaskIntoConstraints = false
        successLabel.font = .preferredFont(forTextStyle: .title2)
        successLabel.textColor = .label
        successLabel.textAlignment = .center
        successLabel.numberOfLines = 0
        return successLabel
    }()
    
    private let markLabel: UILabel = {
        let markLabel = UILabel()
        markLabel.translatesAutoresizingMaskIntoConstraints = false
        markLabel.font = .preferredFont(forTextStyle: .title2)
        markLabel.textColor = .label
        markLabel.textAlignment = .center
        markLabel.numberOfLines = 0
        return markLabel
    }()
    
    private let myStackView: UIStackView = {
        let myStackView = UIStackView()
        myStackView.translatesAutoresizingMaskIntoConstraints = false
        myStackView.axis = .vertical
        myStackView.distribution = .fillEqually
        myStackView.spacing = 10
        return myStackView
    }()
    
    private let bottomBackgroundImage: UIImageView = {
        let bottomBackgroundImage = UIImageView()
        bottomBackgroundImage.translatesAutoresizingMaskIntoConstraints = false
        bottomBackgroundImage.image = UIImage(named: "bottomBackgroundImage")
        bottomBackgroundImage.contentMode = .scaleAspectFill
        bottomBackgroundImage.clipsToBounds = true
        return bottomBackgroundImage
    }()
    
    //  MARK: - Inits
    init(numberOfCorrectAnswers: Int) {
        self.numberOfCorrectAnswers = numberOfCorrectAnswers
        super.init(nibName: nil, bundle: nil)
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Init error!")
    }
    
    //  MARK: - Functions
    @objc private func didTapBack() {
        guard let controllers = navigationController?.viewControllers else {return}
        DispatchQueue.main.async {
            self.navigationController?.popToViewController(controllers.first!, animated: true)
        }
    }
    
    private func updateUI() {
        myStackView.addArrangedSubview(scoreLabel)
        myStackView.addArrangedSubview(successLabel)
        myStackView.addArrangedSubview(markLabel)

        scoreLabel.text = "Number of correct answers: \n\(numberOfCorrectAnswers) / \(UserDefaultsStorage.shared.loadNumberOfQuestions())"
        
        let percentValue = Double(numberOfCorrectAnswers) / Double(UserDefaultsStorage.shared.loadNumberOfQuestions())
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.numberStyle = .percent
        successLabel.text = "Percentage success: \n\(formatter.string(from: NSNumber(value: percentValue)) ?? "-")"
        
        if percentValue >= 0.85 {
            markLabel.text = "Your mark:\nA - Great result! Try another quiz!"
        }
        else if percentValue < 0.85 && percentValue >= 0.70  {
            markLabel.text = "Your mark:\nB - Good result! Try another quiz!"
        }
        else if percentValue < 0.70 && percentValue >= 0.50  {
            markLabel.text = "Your mark:\nC - Avarage result! Try another quiz!"
        }
        else if percentValue < 0.50 && percentValue >= 0.28  {
            markLabel.text = "Your mark:\nD - Not much result! Try another quiz!"
        }
        else if percentValue < 0.28 {
            markLabel.text = "Your mark:\nF - Bad result! Try another quiz!"
        }
    }
    
    //  MARK: - Life cycle functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            topBackgroundImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            topBackgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            topBackgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            topBackgroundImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
            
            myStackView.topAnchor.constraint(equalTo: topBackgroundImage.bottomAnchor),
            myStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            myStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            bottomBackgroundImage.topAnchor.constraint(equalTo: myStackView.bottomAnchor, constant: 10),
            bottomBackgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            bottomBackgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            bottomBackgroundImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
            bottomBackgroundImage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(topBackgroundImage)
        view.addSubview(myStackView)
        view.addSubview(bottomBackgroundImage)
        
        view.backgroundColor = .systemBackground
        
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        AppUtility.lockOrientation(.portrait)

        title = "Your results"
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back to menu", style: .plain, target: self, action: #selector(didTapBack))
    }
}
