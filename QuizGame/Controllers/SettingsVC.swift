//  SettingsVC.swift
//  Created by Dominik Hel on 12.01.2022.

//  MARK: - Imports
import UIKit

//  MARK: - Class SettingsVC
final class SettingsVC: UIViewController {
    //  MARK: - Constants and variables
    /// An array of possibilities of number of questions.
    private let numberOfQuestions = [10, 15, 20, 25, 30, 35, 40, 45, 50]
    /// An array of possibilities of type of difficulty.
    private let difficultyType = ["All", "Easy", "Medium", "Hard"]

    //  MARK: - UI components
    private let firstTitleLabel: UILabel = {
        let firstTitleLabel: UILabel = UILabel()
        firstTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        firstTitleLabel.text = "Number of questions"
        firstTitleLabel.textColor = .label
        firstTitleLabel.textAlignment = .center
        firstTitleLabel.numberOfLines = 0
        return firstTitleLabel
    }()
    
    private let secondTitleLabel: UILabel = {
        let secondTitleLabel: UILabel = UILabel()
        secondTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        secondTitleLabel.text = "Dificulty of questions"
        secondTitleLabel.textColor = .label
        secondTitleLabel.textAlignment = .center
        secondTitleLabel.numberOfLines = 0
        return secondTitleLabel
    }()
    
    private let myStackView: UIStackView = {
        let myStackView = UIStackView()
        myStackView.translatesAutoresizingMaskIntoConstraints = false
        myStackView.axis = .horizontal
        myStackView.distribution = .fillEqually
        myStackView.spacing = 0
        return myStackView
    }()
    
    private let settingsPicker: UIPickerView = {
        let settingsPicker = UIPickerView()
        settingsPicker.translatesAutoresizingMaskIntoConstraints = false
        return settingsPicker
    }()
    
    //  MARK: - Functions
    /// Saves a selected settings.
    @objc private func didTapSave() {
        /*Pozor!
        Využívané API není dokonalé.
        Původně si zde hráč mohl nastavit množství otázek a úroven obtížnosti.
        Vyskytl se zde problém, že API nemá v některých kategoriích dostatek otázek s vybranou obtížností.
        Kód níže zobrazuje jak by vše mělo fungovat nebýt této chyby.
        Avšak abych předešel těmto problémům i když uživatel změní své nastavení, tak hodnoty zůstanou vždy nastaveny na výchozí stav.
        
        Ideálně by vše fungovalo takto:
        let selectedNumber = numberOfQuestions[settingsPicker.selectedRow(inComponent: 0)]
        let selectedType = difficultyType[settingsPicker.selectedRow(inComponent: 1)]
        UserDefaultsStorage.shared.save(numberOfQuestions: selectedNumber, difficultyType: selectedType)
        navigationController?.popToRootViewController(animated: true)
        */
        
        UserDefaultsStorage.shared.save(numberOfQuestions: 10, difficultyType: "All")
        navigationController?.popToRootViewController(animated: true)
    }
    
    //  MARK: - Life cycle functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait)
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.all)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            myStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            myStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            myStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            settingsPicker.topAnchor.constraint(equalTo:myStackView.bottomAnchor, constant: 0),
            settingsPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingsPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            settingsPicker.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    
        view.addSubview(settingsPicker)
        
        title = "Settings"
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(didTapSave))
        
        settingsPicker.delegate = self
        settingsPicker.dataSource = self
        
        view.addSubview(myStackView)
        myStackView.addArrangedSubview(firstTitleLabel)
        myStackView.addArrangedSubview(secondTitleLabel)
        
        //  TODO: - Pokud jsou nastavené hodnoty, nastavit je jako výchozí do picker view komponenty
    }
}
    
//  MARK: - SettingsVC extension
extension SettingsVC: UIPickerViewDelegate, UIPickerViewDataSource {
    //  MARK: - PickerView functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return numberOfQuestions.count
        case 1:
            return difficultyType.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return String(numberOfQuestions[row])
        case 1:
            return difficultyType[row]
        default:
            return ""
        }
    }
}
