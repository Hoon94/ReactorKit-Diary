//
//  DiaryListViewController.swift
//  Diary
//
//  Created by Daehoon Lee on 8/11/25.
//

import RxCocoa
import RxSwift
import UIKit

final class DiaryListViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let writeButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .black
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
        writeButton.rx.tap
            .bind { [weak self] in
                let writeViewController = DiaryWriteViewController(reactor: DiaryWriteViewReactor(initialState: .init()))
                self?.navigationController?.pushViewController(writeViewController, animated: true)
            }.disposed(by: disposeBag)
    }

    private func setUI() {
        view.backgroundColor = .white
        navigationItem.setRightBarButtonItems([
            UIBarButtonItem(customView: writeButton)
        ], animated: true)
        setConstraints()
    }
    
    private func setConstraints() {
        
    }
}

