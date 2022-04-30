//  MenuVC.swift
//  Created by Dominik Hel on 30.10.2021.

//  MARK: - Imports
import UIKit

//  MARK: - Class MenuVC
final class MenuVC: UIViewController {
    //  MARK: - Constants and variables
    /// An array of category struct instances.
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
    /// Initializer for creating a new MenuVC instance.
    ///
    /// - Parameters:
    ///     - categories: An array of category struct instances.
    init(categories: [Category]) {
        super.init(nibName: nil, bundle: nil)
        self.categories = categories
        listOfCategories.reloadData()
    }
    
    /// Required initializer.
    required init?(coder: NSCoder) {
        fatalError("Init error!")
    }
    
    //  MARK: - Functions
    /// Shows settingsVC.
    @objc private func didTapGear() {
        let settingsVC = SettingsVC()
        settingsVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    /// Locks the touch on UI elements.
    private func lockUI() {
        listOfCategories.allowsSelection = false
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    /// Unlocks the touch on UI elements.
    private func unlockUI() {
        listOfCategories.allowsSelection = true
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    //  MARK: - Override variables
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    //  MARK: - Life cycle functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait)
        navigationItem.largeTitleDisplayMode = .always
        view.alpha = 1
        unlockUI()
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
        loadingView.startSpinnerAnimation()
        let id = categories[indexPath.row].id
        let numberOfQuestions = UserDefaultsStorage.shared.loadNumberOfQuestions()
        let difficultyType = UserDefaultsStorage.shared.loadDifficultyType()
        lockUI()
        if (InternetMonitor.shared.isConnected) {
            QuizProvider.shared.fetchQuiz(categoryID: id, numberOfQuestions: numberOfQuestions, difficultyType: difficultyType) { [weak self] results in
                DispatchQueue.main.async {
                    self?.loadingView.stopSpinnerAnimation()
                    self?.loadingView.removeFromSuperview()
                }
                switch (results) {
                case .failure(let error):
                    DispatchQueue.main.async {
                        print(error)
                        let alert = UIAlertController(title: "Fatal Error", message: "\(error)", preferredStyle: .alert)
                        let alertAction = UIAlertAction(title: "Cancle", style: .cancel, handler: nil)
                        alert.addAction(alertAction)
                        self?.present(alert, animated:  true, completion: nil)
                        self?.unlockUI()
                    }
                case .success(let data):
                    DispatchQueue.main.async {
                        let gameVC = GameVC(questions: data)
                        gameVC.modalPresentationStyle = .fullScreen
                        self?.navigationController?.pushViewController(gameVC, animated: true)
                    }
                }
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.loadingView.removeFromSuperview()
                self?.unlockUI()
                let alert = UIAlertController(title: "Internet Connection Error", message: "You are not connected to the internet.", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "Try again!", style: .cancel)
                alert.addAction(alertAction)
                self?.present(alert, animated:  true, completion: nil)
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
