//  MenuVC.swift
//  Created by Dominik Hel on 30.10.2021.

//  MARK: - Imports
import UIKit

//  MARK: - Class MenuVC
final class MenuVC: UIViewController {
    //  MARK: - Constants and variables
    private var categories = [Category]()
    
    //  MARK: - UI components
    private let loadingView: LoadingView = {
        let loadingView = LoadingView()
        loadingView.layer.borderWidth = 0.5
        loadingView.layer.borderColor = UIColor.quaternaryLabel.cgColor
        loadingView.layer.cornerRadius = .pi
        return loadingView
    }()
    
    private let listOfCategories: UITableView = {
        let listOfCategories = UITableView()
        listOfCategories.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return listOfCategories
    }()
    
    //  MARK: - Inits
    init(categories: [Category]) {
        super.init(nibName: nil, bundle: nil)
        self.categories = categories
        listOfCategories.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Init error!")
    }
    
    //  MARK: - Functions
    @objc private func didTapGear() {
        let settingsVC = SettingsVC()
        settingsVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    //  MARK: - Life cycle functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait)
        navigationItem.largeTitleDisplayMode = .always
        view.alpha = 1
        listOfCategories.allowsSelection = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.all)
        view.alpha = 0
    }
    
    override func viewDidLayoutSubviews() {
        listOfCategories.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        listOfCategories.center = view.center
        
        loadingView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width * 0.3, height: self.view.frame.width * 0.3)
        loadingView.center = view.center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(listOfCategories)
        
        title = "Categories"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true

        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(didTapGear))
        
        listOfCategories.delegate = self
        listOfCategories.dataSource = self
    }
}

//  MARK: - MenuVC extension
extension MenuVC: UITableViewDelegate, UITableViewDataSource {
    //  MARK: - TableView functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        categories[indexPath.row].editName()
        cell.textLabel?.text = categories[indexPath.row].name
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        view.addSubview(loadingView)
        let id = categories[indexPath.row].id
        let numberOfQuestions = UserDefaultsStorage.shared.loadNumberOfQuestions()
        let typesOfDifficulty = UserDefaultsStorage.shared.loadTypesOfDifficulty()
        listOfCategories.allowsSelection = false
        
        QuizProvider.shared.fetchQuiz(urlID: id, numberOfQuestions: numberOfQuestions, typesOfDifficulty: typesOfDifficulty) { [weak self] results in
            DispatchQueue.main.async {
                self?.loadingView.removeFromSuperview()
            }
            switch (results) {
            case .failure(let error):
                DispatchQueue.main.async {
                    print(error)
                    let alert = UIAlertController(title: "Error", message: "\(error)", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "Cancle", style: .cancel, handler: nil)
                    alert.addAction(alertAction)
                    self?.present(alert, animated:  true, completion: nil)
                    self?.listOfCategories.allowsSelection = true
                }
            case .success(let data):
                DispatchQueue.main.async {
                    let gameVC = GameVC(questions: data)
                    gameVC.modalPresentationStyle = .fullScreen
                    self?.navigationController?.pushViewController(gameVC, animated: true)
                }
            }
        }
    }
}

//  MARK: - String extension
extension String {
    var htmlAttributedString: NSAttributedString? {
        return try? NSAttributedString(data: Data(utf8), options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
    }
}
