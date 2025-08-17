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
        tableView.register(DiaryListTableViewCell.self, forCellReuseIdentifier: DiaryListTableViewCell.id)
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
        modeButton.rx.tap
            .map { Reactor.Action.touchMode }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        writeButton.rx.tap
            .bind { [weak self] in
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                let viewContext = appDelegate.persistentContainer.viewContext
                
                let writeViewController = DiaryWriteViewController(reactor: DiaryWriteViewReactor(initialState: .init(), coreData: DiaryCoreData(viewContext: viewContext)))
                self?.navigationController?.pushViewController(writeViewController, animated: true)
            }.disposed(by: disposeBag)
        
        textField.rx.text.orEmpty.distinctUntilChanged()
            .map { Reactor.Action.query($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // mode에 따라 다른 기능 동작
        // 삭제 - 삭제할 아이템 선택
        // 일반 - 다이어리 상세로 이동
        tableView.rx.modelSelected(DiaryListCellData.self)
            .filter { _ in reactor.currentState.mode == .delete }
            .map { Reactor.Action.selectItem(id: $0.diary.id) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(DiaryListCellData.self)
            .filter { _ in reactor.currentState.mode == .normal }
            .map { Reactor.Action.selectItem(id: $0.diary.id) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .map { Reactor.Action.delete }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.cellDataList }
            .distinctUntilChanged()
            .bind(to: tableView.rx.items) { tableView, row, cellData in
                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellData.cellId) as? DiaryListTableViewCell else { return UITableViewCell() }
                
                cell.apply(cellData: cellData)
                return cell
            }.disposed(by: disposeBag)
        
        reactor.state.map { $0.mode }
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { viewController, mode in
                switch mode {
                case .normal:
                    viewController.modeButton.setTitle("삭제", for: .normal)
                    viewController.deleteButton.isHidden = true
                case .delete:
                    viewController.modeButton.setTitle("완료", for: .normal)
                    viewController.deleteButton.isHidden = false
                }
            }.disposed(by: disposeBag)
        
        reactor.pulse(\.$deleteSuccess)
            .map { _ in Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$error)
            .compactMap { $0 }
            .withUnretained(self)
            .bind { viewController, error in
                let alert = UIAlertController(title: "에러", message: error.description, preferredStyle: .alert)
                alert.addAction(UIAlertAction.init(title: "확인", style: .default))
                viewController.navigationController?.present(alert, animated: true)
            }.disposed(by: disposeBag)
        
        EventBus.shared.asObservable()
            .bind { event in
                if case .refreshList = event {
                    reactor.action.onNext(.refresh)
                }
            }.disposed(by: disposeBag)
    }
}
