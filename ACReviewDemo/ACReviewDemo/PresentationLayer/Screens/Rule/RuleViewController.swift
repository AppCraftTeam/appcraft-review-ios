//
//  RuleViewController.swift
//  ACReviewDemo
//
//  Created by Pavel Moslienko on 04.07.2024.
//

import ACReview
import UIKit

final class RuleViewController: UIViewController {
    
    var model: RuleViewModel?
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ruleNameLabel, conditionLabel, statusLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    private lazy var ruleNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var conditionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Действие", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        initView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        guard let model = self.model else {
            return
        }
        switch model.rule {
        case .appUpdateWithDelayRule:
            break
        case .eventDelayRule:
            break
        case .timeSpentRule:
            model.timeSpentRule.endSession()
            let reviewService = ACReviewService(rule: model.timeSpentRule)
            reviewService.tryToShowRating()
        default:
            break
        }
        #warning("move in AppDelegate")
        let eventDelayRule = ACEventDelayRule(key: AppKeys.eventDelayRuleKey, minimumUsageTime: 5)
        if eventDelayRule.isActiveCondition {
            eventDelayRule.endSession()
        }
    }
}

// MARK: - Module methods
private extension RuleViewController {
    
    func setupView() {
        view.backgroundColor = .white
        
        containerView.backgroundColor = .black.withAlphaComponent(0.1)
        containerView.layer.cornerRadius = 15.0
        
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        containerView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
        
        view.addSubview(actionButton)
        NSLayoutConstraint.activate([
            actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            actionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            actionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func initView() {
        guard let model = self.model else {
            return
        }
        self.ruleNameLabel.text = model.rule.title
        self.conditionLabel.text = model.rule.subtitle
        self.statusLabel.text = "Вызов запроса на оценку не требуется"
        self.actionButton.isHidden = model.rule != .ruleCounter || model.rule != .eventDelayRule
        
        switch model.rule {
        case .appUpdateRule:
            let rule = ACAppUpdateRule()
            let reviewService = ACReviewService(rule: rule)
            reviewService.tryToShowRating(
                notRequiredFinished: {
                    self.statusLabel.text = "Вызов запроса на оценку не требуется"
                },
                requiredFinished: { isDisplayd in
                    self.statusLabel.text = "Вызов запроса на оценку был удовлетворен. Окно было показано - \(isDisplayd)"
                }
            )
        case .appUpdateWithDelayRule:
            model.appUpdateWithDelayRule.startSession()
            let reviewService = ACReviewService(rule:  model.appUpdateWithDelayRule)
            reviewService.tryToShowRating(
                notRequiredFinished: {
                    self.statusLabel.text = "Проверка будет осуществлена при выходе из экрана или при следующем его открытии. Вызов запроса на оценку не требуется"
                },
                requiredFinished: { isDisplayd in
                    self.statusLabel.text = "Вызов запроса на оценку был удовлетворен. Окно было показано - \(isDisplayd)"
                }
            )
        case .eventDelayRule:
            let reviewService = ACReviewService(rule: model.eventDelayRule)
            reviewService.tryToShowRating(
                notRequiredFinished: {
                    self.statusLabel.text = "Вызов запроса на оценку не требуется"
                },
                requiredFinished: { isDisplayd in
                    self.statusLabel.text = "Вызов запроса на оценку был удовлетворен. Окно было показано - \(isDisplayd)"
                }
            )
        case .ruleCounter:
            break
        case .seriallyRule:
            let rule = ACSeriallyRule(actionFrequency: .daily(everyXDays: 2))
            let reviewService = ACReviewService(rule: rule)
            reviewService.tryToShowRating(
                notRequiredFinished: {
                    self.statusLabel.text = "Вызов запроса на оценку не требуется"
                },
                requiredFinished: { isDisplayd in
                    self.statusLabel.text = "Вызов запроса на оценку был удовлетворен. Окно было показано - \(isDisplayd)"
                }
            )
        case .timeSpentRule:
            model.timeSpentRule.startSession()
            let reviewService = ACReviewService(rule:  model.timeSpentRule)
            reviewService.tryToShowRating(
                notRequiredFinished: {
                    self.statusLabel.text = "Проверка будет осуществлена при выходе из экрана или при следующем его открытии. Вызов запроса на оценку не требуется \(model.timeSpentRule.getTotalSecondsSpent())"
                },
                requiredFinished: { isDisplayd in
                    self.statusLabel.text = "Вызов запроса на оценку был удовлетворен. Окно было показано - \(isDisplayd)"
                }
            )
        }
    }
    
    @objc
    private func actionButtonTapped() {
        guard let model = self.model else {
            return
        }
        
        switch model.rule {
        case .eventDelayRule:
            let rule = ACEventDelayRule(key: AppKeys.eventDelayRuleKey, minimumUsageTime: 5)
            rule.startSession()
        case .ruleCounter:
            let rule = ACRuleCounter(customFlagKey: AppKeys.ruleCounterKey, threshold: 5)
            let reviewService = ACReviewService(rule: rule)
            
            rule.incrementFlag()
            reviewService.tryToShowRating(
                notRequiredFinished: {
                    self.statusLabel.text = "Вызов запроса на оценку не требуется"
                },
                requiredFinished: { isDisplayd in
                    self.statusLabel.text = "Вызов запроса на оценку был удовлетворен. Окно было показано - \(isDisplayd)"
                }
            )
        default:
            break
        }
    }
}


/*
 /*
  var subtitle: String {
  switch self {
  case .appUpdateWithDelayRule:
  return "Условие: после установки новой версии приложения нужно провести 5 минут в приложении (суммарно)"
  case .eventDelayRule:
  return  "Условие: после нажатия на кнопку на сл.экране нужно провести 5 минут в приложении (суммарно)"
  case .timeSpentRule:
  return "Условие: провести 5 минут на сл.экране (суммарно)"
  }
  }
  */
 
 */
