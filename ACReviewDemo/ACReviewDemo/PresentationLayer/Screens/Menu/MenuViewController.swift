//
//  MenuViewController.swift
//  ACReviewDemo
//
//  Created by Pavel Moslienko on 03.07.2024.
//

import UIKit

final class MenuViewController: AppViewController {
    
    var model: MenuViewModel = MenuViewModel()
    
    // MARK: - UI components
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "ACReviewDemo"
        self.view.backgroundColor = .systemGroupedBackground
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.backgroundColor = .systemGroupedBackground
        
        model.didOpenRuleScreen = { [weak self] ruleType in
            let vc = RuleViewController()
            vc.model = RuleViewModel(ruleType: ruleType)
            
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension MenuViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.rules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        
        let rule = model.rules[indexPath.row]
        
        cell.textLabel?.text = rule.title
        cell.detailTextLabel?.text = rule.subtitle
        cell.detailTextLabel?.textColor = .gray
        cell.detailTextLabel?.numberOfLines = 0
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rule = model.rules[indexPath.row]
        model.handleRule(rule)
    }
}

// MARK: - UITableViewDataSource
extension MenuViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
}
