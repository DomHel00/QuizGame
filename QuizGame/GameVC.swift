//  GameVC.swift
//  Created by Dominik Hel on 30.10.2021.

//  MARK: - Imports
import UIKit

//  MARK: - Class GameVC
final class GameVC: UIViewController {
    //  MARK: - Constants and variables
    private var questions = [Questions]()
    private var numberOfCorrectAnswers = 0
    private var poradi: Int = 0 {
        didSet {
            myLabel.text = "\(poradi+1)/\(UserDefaultsStorage.shared.loadNumberOfQuestions())"
        }
    }
    
    //  MARK: - UI components
    private let myLabel: UILabel = {
        let myLabel = UILabel()
        myLabel.text = "1/\(UserDefaultsStorage.shared.loadNumberOfQuestions())"
        myLabel.textColor = .systemOrange
        myLabel.textAlignment = .center
        //myLabel.font = .preferredFont(forTextStyle: .largeTitle)
        //myLabel.adjustsFontForContentSizeCategory = true
        myLabel.font = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: UIFont(name: "Bradley Hand", size: 36)!)
        myLabel.adjustsFontForContentSizeCategory = true

        //myLabel.font = UIFont(name: "Bradley Hand", size: 34)
        //myLabel.adjustsFontSizeToFitWidth = true
        myLabel.translatesAutoresizingMaskIntoConstraints = false
        return myLabel
    }()
    
    private let myTextView: UITextView = {
        let myTextView = UITextView()
        myTextView.textColor = .label
        myTextView.isEditable = false
        myTextView.font = .systemFont(ofSize: 24)
        myTextView.translatesAutoresizingMaskIntoConstraints = false
        myTextView.textAlignment = .center
        return myTextView
    }()
    
    private let answerButtons: [UIButton] = {
        var answerButtons = [UIButton]()
        for i in 0...3 {
            let answerButton = UIButton()
            answerButton.tag = i
            answerButton.setTitleColor(.label, for: .normal)
            answerButton.backgroundColor = .clear
            answerButton.layer.borderColor = UIColor.systemOrange.cgColor
            answerButton.layer.borderWidth = 2
            answerButton.layer.cornerRadius = 25
            answerButton.addTarget(self, action: #selector(didTapButton(sender:)), for: .touchUpInside)
            answerButtons.append(answerButton)
        }
        return answerButtons
    }()
    
    private let myStackView: UIStackView = {
        let myStackView = UIStackView()
        myStackView.translatesAutoresizingMaskIntoConstraints = false
        myStackView.axis = .vertical
        myStackView.spacing = 10
        myStackView.distribution = .fillEqually
        return myStackView
    }()
    
    //  MARK: - Inits
    init(questions: [Questions]) {
        super.init(nibName: nil, bundle: nil)
        self.questions = questions
        poradi = 0
        setUpStackView()
        updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Init error!")
    }
    
    //  MARK: - StackView functions
    private func setUpStackView() {
        for button in answerButtons {
            myStackView.addArrangedSubview(button)
        }
    }
    
    private func updateStackViewToCompactMode() {
        for subview in myStackView.subviews {
            subview.removeFromSuperview()
        }
        
        let m2 = UIStackView(arrangedSubviews: [answerButtons[0], answerButtons[1]])
        m2.axis = .horizontal
        m2.spacing = 10
        m2.distribution = .fillEqually
        let m3 = UIStackView(arrangedSubviews: [answerButtons[2], answerButtons[3]])
        m3.axis = .horizontal
        m3.spacing = 10
        m3.distribution = .fillEqually
        //  TODO: - Nahradit m3 m2
        
        myStackView.addArrangedSubview(m2)
        myStackView.addArrangedSubview(m3)
    }
    
    private func updateStackViewToRegularMode() {
        for subview in myStackView.subviews {
            subview.removeFromSuperview()
        }
        setUpStackView()
    }
    
    //  MARK: - Buttons functions
    private func lockTapOnButton() {
        for button in answerButtons {
            button.isEnabled = false
        }
    }
    
    private func unlockTapOnButton() {
        for button in answerButtons {
            button.isEnabled = true
        }
    }
    
    private func setUpButtonAnswersTitles(answers: [String]) {
        var answers = answers
        for button in 0..<answers.count {
            let randomAnswer = answers.randomElement()
            answerButtons[button].setTitle(randomAnswer, for: .normal)
            for (index, answer) in answers.enumerated() {
                if answer == randomAnswer {
                    answers.remove(at: index)
                }
            }
        }
    }
    
    @objc private func didTapButton(sender: UIButton) {
        lockTapOnButton()
        let answer = sender.titleLabel?.text
        let tag = sender.tag
        checkAnswer(poradi: poradi, answer: answer!, tag: tag)
    }
    
    //  MARK: - Game logic functions
    private func checkAnswer(poradi: Int, answer: String, tag: Int) {
        let answerBool = answer == questions[poradi].correct_answer.htmlAttributedString!.string
        if answerBool {
            numberOfCorrectAnswers += 1
        }
        UIView.animate(withDuration: 0.5, delay: 0, options: []) { [weak self] in
            self?.answerButtons[tag].backgroundColor = answerBool ? .systemGreen : .systemRed
            } completion: { done in
                if done {
                    UIView.animate(withDuration: 0.3) {
                        self.answerButtons[tag].backgroundColor = .systemBackground
                    } completion: { done in
                        if done {
                            self.poradi += 1
                            self.unlockTapOnButton()
                            self.updateUI()
                        }
                    }
                }
            }
    }
    
    private func updateUI() {
        let max = UserDefaultsStorage.shared.loadNumberOfQuestions()
        if poradi < max {
            //print("\(questions[poradi].question.htmlAttributedString!.string)")
            print("\(questions[poradi].getAllAnswers())")
            print("\(questions[poradi].correct_answer.htmlAttributedString!.string)")
            
            myTextView.text = questions[poradi].question.htmlAttributedString!.string
            
            if (questions[poradi].getAllAnswers().count > 2) {
                answerButtons[2].isHidden = false
                answerButtons[3].isHidden = false
                setUpButtonAnswersTitles(answers: questions[poradi].getAllAnswers())
            } else {
                answerButtons[2].isHidden = true
                answerButtons[3].isHidden = true
                setUpButtonAnswersTitles(answers: questions[poradi].getAllAnswers())
            }
            
        } else {
            let endVC = EndVC(numberOfCorrectAnswers: numberOfCorrectAnswers)
            endVC.modalPresentationStyle = .fullScreen
            navigationController?.pushViewController(endVC, animated: true)
        }
    }
    
    //  MARK: - Life cycle functions
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        switch (traitCollection.verticalSizeClass) {
        case .compact:
            DispatchQueue.main.async {
                self.updateStackViewToCompactMode()
            }
        case .regular:
            DispatchQueue.main.async {
                self.updateStackViewToRegularMode()
            }
        default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.alpha = 1
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.alpha = 0
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            myLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            myLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            myLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            myLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12),
            
            myTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            myTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            myTextView.topAnchor.constraint(equalTo: myLabel.bottomAnchor, constant: 20),
            myTextView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            
            myStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            myStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            myStackView.topAnchor.constraint(equalTo: myTextView.bottomAnchor, constant: 20),
            myStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(myLabel)
        view.addSubview(myTextView)
        view.addSubview(myStackView)
                
        title = "Quiz"
        navigationItem.largeTitleDisplayMode = .never
        
        if traitCollection.verticalSizeClass == .compact {
            updateStackViewToCompactMode()
        } else {
            updateStackViewToRegularMode()
        }
    }
}
