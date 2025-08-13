//
//  DiaryWriteViewController.swift
//  Diary
//
//  Created by Daehoon Lee on 8/12/25.
//

import ReactorKit
import RxCocoa
import SnapKit
import UIKit

final class DiaryWriteViewController: UIViewController, ReactorKit.View {
    typealias Reactor = DiaryWriteViewReactor
    
    var disposeBag = DisposeBag()
    
    private let titleLabel = {
        let label = UILabel()
        label.text = "제목"
        return label
    }()
    
    private let titleTextField = {
        let textField = UITextField()
        textField.borderStyle = .bezel
        return textField
    }()
    
    private let contentLabel = {
        let label = UILabel()
        label.text = "내용"
        return label
    }()
    
    private let contentTextView = {
        let textView = UITextView()
        textView.layer.borderColor = UIColor.systemGray.cgColor
        textView.layer.borderWidth = 1
        textView.font = .systemFont(ofSize: 16)
        return textView
    }()
    
    private let saveButton = {
        let button = UIButton(configuration: .filled())
        button.setTitle("저장", for: .normal)
        return button
    }()
    
    init(reactor: DiaryWriteViewReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setUI()
    }
    
    private func setUI() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(titleTextField)
        view.addSubview(contentLabel)
        view.addSubview(contentTextView)
        view.addSubview(saveButton)
        setConstraints()
    }
    
    private func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalToSuperview().offset(16)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(44)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(4)
            make.leading.equalTo(titleLabel)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(4)
            make.leading.trailing.equalTo(titleTextField)
            make.bottom.equalTo(saveButton.snp.top).offset(-20)
        }
        
        saveButton.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
    }
    
    func bind(reactor: DiaryWriteViewReactor) {
        // TODO: reactor action 호출, reactor state 바인딩
        titleTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .bind { title in
                reactor.action.onNext(.inputTitle(title))
            }.disposed(by: disposeBag)
        
        contentTextView.rx.text.orEmpty
            .distinctUntilChanged()
            .bind { content in
                reactor.action.onNext(.inputContent(content))
            }.disposed(by: disposeBag)
        
        saveButton.rx.tap
            .bind {
                reactor.action.onNext(.save)
            }.disposed(by: disposeBag)
        
        reactor.state
            .map { state in
                state.isRequestEnable
            }
            .distinctUntilChanged()
            .bind { [weak self] isRequestEnable in
                self?.saveButton.isEnabled = isRequestEnable
            }.disposed(by: disposeBag)
    }
}
