//  EndVC.swift
//  Created by Dominik Hel on 15.01.2022.

//  MARK: - Imports
import UIKit

//  MARK: - Class EndVC
final class EndVC: UIViewController {
    private let numberOfCorrectAnswers: Int
    
    init(numberOfCorrectAnswers: Int) {
        self.numberOfCorrectAnswers = numberOfCorrectAnswers
        super.init(nibName: nil, bundle: nil)
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Init error!")
    }
    
    private func updateUI() {
        scoreLabel.text = "Number of correct answers: \(numberOfCorrectAnswers) / \(UserDefaultsStorage.shared.loadNumberOfQuestions())"
        
        let percentValue = Double(numberOfCorrectAnswers) / Double(UserDefaultsStorage.shared.loadNumberOfQuestions())
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.numberStyle = .percent
        successLabel.text = "Percentage success: \(formatter.string(from: NSNumber(value: percentValue)) ?? "-")"
        
        if percentValue >= 0.85 {
            markLabel.text = "A - Great result! Try another quiz!"
        }
        else if percentValue < 0.85 && percentValue >= 0.70  {
            markLabel.text = "B - Good result! Try another quiz!"
        }
        else if percentValue < 0.70 && percentValue >= 0.50  {
            markLabel.text = "C - Avarage result! Try another quiz!"
        }
        else if percentValue < 0.50 && percentValue >= 0.28  {
            markLabel.text = "D - Not much result! Try another quiz!"
        }
        else if percentValue < 0.28 {
            markLabel.text = "F - Bad result! Try another quiz!"
        }
    }
    

    private let scoreLabel: UILabel = {
        let scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.numberOfLines = 0
        scoreLabel.font = .preferredFont(forTextStyle: .title2)
        scoreLabel.adjustsFontForContentSizeCategory = true
        scoreLabel.textColor = .label
        scoreLabel.textAlignment = .center
        return scoreLabel
    }()
    
    private let successLabel: UILabel = {
        let successLabel = UILabel()
        successLabel.translatesAutoresizingMaskIntoConstraints = false
        successLabel.numberOfLines = 0
        successLabel.font = .preferredFont(forTextStyle: .title2)
        successLabel.adjustsFontForContentSizeCategory = true
        successLabel.textColor = .label
        successLabel.textAlignment = .center
        return successLabel
    }()
    
    private let markLabel: UILabel = {
        let markLabel = UILabel()
        markLabel.translatesAutoresizingMaskIntoConstraints = false
        markLabel.numberOfLines = 0
        markLabel.font = .preferredFont(forTextStyle: .title2)
        markLabel.adjustsFontForContentSizeCategory = true
        markLabel.textColor = .label
        markLabel.textAlignment = .center
        return markLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.addSubview(titleLabel)
        view.addSubview(scoreLabel)
        view.addSubview(successLabel)
        view.addSubview(markLabel)
        
        view.backgroundColor = .systemBackground
        
        title = "Your results"
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back to menu", style: .plain, target: self, action: #selector(back))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            /*titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
            */
            scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            scoreLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scoreLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),
            
            successLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 10),
            successLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            successLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            successLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15),

            markLabel.topAnchor.constraint(equalTo: successLabel.bottomAnchor, constant: 10),
            markLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            markLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            markLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15)

            
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .always
    }
    
    @objc func back() {
        guard let controllers = navigationController?.viewControllers else {return}
        DispatchQueue.main.async {
            self.navigationController?.popToViewController(controllers.first!, animated: true)
            
        }

    }

   

}

/*
 
 
 100% - 80% Výborný výkon. Zkus další quiz.
 <80% - 60 - Super výkon.
 <60% - 40 - Dobrý výkon.
 <40% - 20% - Nic moc výkon.
 <20% - Snad ti jen nesedly otázky.
 */
