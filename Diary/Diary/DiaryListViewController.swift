//
//  DiaryListViewController.swift
//  Diary
//
//  Created by Daehoon Lee on 8/11/25.
//

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import UIKit

final class DiaryListViewController: UIViewController, ReactorKit.View {
    
    typealias Reactor = DiaryListViewReactor
    
    var disposeBag = DisposeBag()
    
    private let writeButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let modeButton = {
        let button = UIButton()
        button.setTitle("삭제", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let textField = {
        let textField = UITextField()
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 8
        return textField
    }()
    
    private let tableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.contentInset = .init(top: 16, left: 0, bottom: 16, right: 0)
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    
    private let deleteButton = {
        let button = UIButton()
        button.setTitle("삭제하기", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.isHidden = true
        return button
    }()
    
    init(reactor: DiaryListViewReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }

    private func setUI() {
        title = "다이어리"
        view.backgroundColor = .white
        navigationItem.setRightBarButtonItems([
            UIBarButtonItem(customView: writeButton),
            UIBarButtonItem(customView: modeButton)
        ], animated: true)
        view.addSubview(textField)
        view.addSubview(tableView)
        view.addSubview(deleteButton)
        setConstraints()
    }
    
    private func setConstraints() {
        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(deleteButton.snp.top)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(60)
        }
    }
    
    func bind(reactor: DiaryListViewReactor) {
        writeButton.rx.tap
            .bind { [weak self] in
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                let viewContext = appDelegate.persistentContainer.viewContext
                
                let writeViewController = DiaryWriteViewController(reactor: DiaryWriteViewReactor(initialState: .init(), coreData: DiaryCoreData(viewContext: viewContext)))
                self?.navigationController?.pushViewController(writeViewController, animated: true)
            }.disposed(by: disposeBag)
    }
}
