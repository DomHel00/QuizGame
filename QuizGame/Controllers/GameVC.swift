//  GameVC.swift
//  Created by Dominik Hel on 30.10.2021.

//  MARK: - Imports
import UIKit

//  MARK: - Class GameVC
final class GameVC: UIViewController {
    //  MARK: - Constants and variables
    /// An array of Question struct instance.
    private var questions = [Question]()
    /// Number of correct answers.
    private var numberOfCorrectAnswers = 0
    /// The current index of the questions array.
    private var currentQuestionIndex: Int = 0 {
        didSet {
            questionIndexLabel.text = "\(currentQuestionIndex+1)/\(UserDefaultsStorage.shared.loadNumberOfQuestions())"
        }
    }
    
    //  MARK: - UI components
    private let questionIndexLabel: UILabel = {
        let questionIndexLabel = UILabel()
        questionIndexLabel.translatesAutoresizingMaskIntoConstraints = false
        questionIndexLabel.font = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: UIFont(name: "Bradley Hand", size: 36)!)
        questionIndexLabel.text = "1/\(UserDefaultsStorage.shared.loadNumberOfQuestions())"
        questionIndexLabel.textColor = .systemOrange
        questionIndexLabel.textAlignment = .center
        return questionIndexLabel
    }()
    
    private let questionTextView: UITextView = {
        let questionTextView = UITextView()
        questionTextView.translatesAutoresizingMaskIntoConstraints = false
        questionTextView.font = .systemFont(ofSize: 24)
        questionTextView.textColor = .label
        questionTextView.textAlignment = .center
        questionTextView.isEditable = false
        return questionTextView
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
    
    private let buttonStackView: UIStackView = {
        let buttonStackView = UIStackView()
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.axis = .vertical
        buttonStackView.distribution = .fillEqually
        buttonStackView.spacing = 10
        return buttonStackView
    }()
    
    //  MARK: - Inits
    /// Initializer for creating a new GameVC instance.
    ///
    /// - Parameters:
    ///     - Questions: An array of Question struct instance.
    init(questions: [Question]) {
        super.init(nibName: nil, bundle: nil)
        self.questions = questions
        //currentQuestionIndex = 0
        updateUI()
    }
    
    /// Required initializer.
    required init?(coder: NSCoder) {
        fatalError("Init error!")
    }
    
    //  MARK: - StackView functions
    /// Sets  up the stack view.
    private func setUpStackView() {
        for button in answerButtons {
            buttonStackView.addArrangedSubview(button)
        }
    }
    
    /// Updates the stack view UI for compact mode.
    private func updateStackViewToCompactMode() {
        for subview in buttonStackView.subviews {
            subview.removeFromSuperview()
        }
        
        let horizontalStackView = UIStackView(arrangedSubviews: [answerButtons[0], answerButtons[1]])
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 10
        horizontalStackView.distribution = .fillEqually

        let secondHorizontalStackView = UIStackView(arrangedSubviews: [answerButtons[2], answerButtons[3]])
        secondHorizontalStackView.axis = .horizontal
        secondHorizontalStackView.spacing = 10
        secondHorizontalStackView.distribution = .fillEqually
        
        buttonStackView.addArrangedSubview(horizontalStackView)
        buttonStackView.addArrangedSubview(secondHorizontalStackView)
    }
    
    /// Updates the stack view UI for regular mode.
    private func updateStackViewToRegularMode() {
        for subview in buttonStackView.subviews {
            subview.removeFromSuperview()
        }

        for button in answerButtons {
            buttonStackView.addArrangedSubview(button)
        }
    }
    
    //  MARK: - Buttons functions
    /// Locks taping on all buttons.
    private func lockTapOnButton() {
        for button in answerButtons {
            button.isEnabled = false
        }
    }
    
    /// Unlocks taping on all buttons.
    private func unlockTapOnButton() {
        for button in answerButtons {
            button.isEnabled = true
        }
    }
    
    /// It randomly divides the answers to a question into titles on the buttons.
    private func setUpButtonAnswersTitles(answers: [String]) {
        var answers = answers
        for button in 0..<answers.count {
            let randomAnswer = answers.randomElement()
            answerButtons[button].setTitle(randomAnswer?.htmlAttributedString?.string, for: .normal)
            for (index, answer) in answers.enumerated() {
                if answer == randomAnswer {
                    answers.remove(at: index)
                }
            }
        }
    }
    
    /// Captures button press.
    @objc private func didTapButton(sender: UIButton) {
        lockTapOnButton()
        let selectedAnswer = sender.titleLabel?.text
        let buttonTag = sender.tag
        checkAnswer(currentQuestionIndex: currentQuestionIndex, answer: selectedAnswer!, tag: buttonTag)
    }
    
    //  MARK: - Game logic functions
    /// Checks the selected answer.
    private func checkAnswer(currentQuestionIndex: Int, answer: String, tag: Int) {
        let answerBool = answer == questions[currentQuestionIndex].correct_answer.htmlAttributedString!.string
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
                            self.currentQuestionIndex += 1
                            self.unlockTapOnButton()
                            self.updateUI()
                        }
                    }
                }
            }
    }
    
    /// Updates UI.
    private func updateUI() {
        let max = UserDefaultsStorage.shared.loadNumberOfQuestions()
        if currentQuestionIndex < max {
            //print("\(questions[currentQuestionIndex].question.htmlAttributedString!.string)")
            //print("\(questions[currentQuestionIndex].getAllAnswers())")
            //print("\(questions[currentQuestionIndex].correct_answer.htmlAttributedString!.string)")
            
            questionTextView.text = questions[currentQuestionIndex].question.htmlAttributedString!.string
            
            if (questions[currentQuestionIndex].getAllAnswers().count > 2) {
                answerButtons[2].isHidden = false
                answerButtons[3].isHidden = false
                setUpButtonAnswersTitles(answers: questions[currentQuestionIndex].getAllAnswers())
            } else {
                answerButtons[2].isHidden = true
                answerButtons[3].isHidden = true
                setUpButtonAnswersTitles(answers: questions[currentQuestionIndex].getAllAnswers())
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
            DispatchQueue.main.async { [weak self] in
                self?.updateStackViewToCompactMode()
            }
        case .regular:
            DispatchQueue.main.async { [weak self] in
                self?.updateStackViewToRegularMode()
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
            questionIndexLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            questionIndexLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            questionIndexLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            questionIndexLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.12),
            
            questionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            questionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            questionTextView.topAnchor.constraint(equalTo: questionIndexLabel.bottomAnchor, constant: 20),
            questionTextView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.25),
            
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonStackView.topAnchor.constraint(equalTo: questionTextView.bottomAnchor, constant: 20),
            buttonStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(questionIndexLabel)
        view.addSubview(questionTextView)
        view.addSubview(buttonStackView)
                
        title = "Quiz"
        navigationItem.largeTitleDisplayMode = .never
        
        if traitCollection.verticalSizeClass == .compact {
            updateStackViewToCompactMode()
        } else {
            updateStackViewToRegularMode()
        }
    }
}
