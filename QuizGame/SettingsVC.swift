//  SettingsVC.swift
//  Created by Dominik Hel on 12.01.2022.

//  MARK: - Imports
import UIKit

//  MARK: - Class SettingsVC
final class SettingsVC: UIViewController {
    //  MARK: - Constants and variables
    private let numberOfQuestions = [10, 15, 20, 25, 30, 35, 40, 45, 50]
    private let typesOfDifficulty = ["All", "Easy", "Medium", "Hard"]

    //  MARK: - UI components
    private let settingsLabel: UILabel = {
        let settingsLabel = UILabel()
        settingsLabel.translatesAutoresizingMaskIntoConstraints = false
        settingsLabel.text = "Select how many questions you want."
        settingsLabel.textAlignment = .center
        settingsLabel.textColor = .label
        settingsLabel.font = .preferredFont(forTextStyle: .title3)
        return settingsLabel
    }()
        
    private let settingsPicker: UIPickerView = {
        let settingsPicker = UIPickerView()
        settingsPicker.translatesAutoresizingMaskIntoConstraints = false
        return settingsPicker
    }()
    
    //  MARK: - Functions
    @objc private func didTapSave() {
        /*
        let selectedNumber = numberOfQuestions[settingsPicker.selectedRow(inComponent: 0)]
        let selectedType = typesOfDifficulty[settingsPicker.selectedRow(inComponent: 1)]
        UserDefaultsStorage.shared.save(numberOfQuestions: selectedNumber, typesOfDifficulty: selectedType)
        */
        
        UserDefaultsStorage.shared.save(numberOfQuestions: 10, typesOfDifficulty: "All")
        navigationController?.popToRootViewController(animated: true)
    }
    
    //  MARK: - Life cycle functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .always
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        NSLayoutConstraint.activate([
            settingsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            settingsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            settingsLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1),
            
            settingsPicker.topAnchor.constraint(equalTo: settingsLabel.bottomAnchor, constant: 5),
            settingsPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            settingsPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            settingsPicker.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3)
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    
        view.addSubview(settingsLabel)
        view.addSubview(settingsPicker)
        
        title = "Settings"
        navigationItem.largeTitleDisplayMode = .always

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(didTapSave))
        
        settingsPicker.delegate = self
        settingsPicker.dataSource = self
        
        //  TODO: - Pokud jsou nastavené hodnoty, nastavit je jako výchozí do picker view komponenty
    }
}
    
//  MARK: - SettingsVC extension
extension SettingsVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return numberOfQuestions.count
        case 1:
            return typesOfDifficulty.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return String(numberOfQuestions[row])
        case 1:
            return typesOfDifficulty[row]
        default:
            return ""
        }
    }
    
    
}
