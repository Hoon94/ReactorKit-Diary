//
//  DiaryListTableViewCell.swift
//  Diary
//
//  Created by Daehoon Lee on 8/16/25.
//

import RxSwift
import SnapKit
import UIKit

final class DiaryListTableViewCell: UITableViewCell {
    
    static let id = "DiaryListTableViewCell"
    
    public var disposeBag = DisposeBag()
    
    private let stackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    private let selectedImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .black
        return imageView
    }()
    
    private let titleLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(selectedImageView)
        stackView.addArrangedSubview(titleLabel)
        
        stackView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview().inset(16)
        }
        
        selectedImageView.snp.makeConstraints { make in
            make.size.equalTo(22)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func apply(cellData: DiaryListCellData) {
        titleLabel.text = cellData.diary.title
        
        if let isSelected = cellData.isSelected {
            selectedImageView.isHidden = false
            selectedImageView.image = .init(systemName: isSelected ? "checkmark.seal.fill" : "checkmark.seal")
        } else {
            selectedImageView.isHidden = true
        }
    }
}
