//
//  AnalysisHistoryCell.swift
//  PureSkinAIApp
//
//  Created by sude on 18.08.2025.
//

import UIKit
import SnapKit

class AnalysisHistoryCell: UITableViewCell {
    static let identifier = "AnalysisHistoryCell"
    
    var onAddTapped: (() -> Void)?
    var onSelectAnalysis: ((SkinAnalysis) -> Void)?
    var onDeleteAnalysis: ((SkinAnalysis, IndexPath) -> Void)? 
    
    private var analyses: [SkinAnalysis] = []
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 130, height: 200)
        layout.minimumLineSpacing = 12
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        return cv
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(AddSelfieCell.self, forCellWithReuseIdentifier: AddSelfieCell.identifier)
        collectionView.register(AnalysisHistoryItemCell.self, forCellWithReuseIdentifier: AnalysisHistoryItemCell.identifier)
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { $0.edges.equalToSuperview().inset(12) }
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func configure(with analyses: [SkinAnalysis]) {
        self.analyses = analyses
        collectionView.reloadData()
    }
}

extension AnalysisHistoryCell: UICollectionViewDataSource, UICollectionViewDelegate {
    // MARK: - DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return analyses.isEmpty ? 1 : analyses.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if analyses.isEmpty {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: AddSelfieCell.identifier,
                for: indexPath
            ) as! AddSelfieCell
            return cell
        } else {
            if indexPath.item == 0 {
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: AddSelfieCell.identifier,
                    for: indexPath
                ) as! AddSelfieCell
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: AnalysisHistoryItemCell.identifier,
                    for: indexPath
                ) as! AnalysisHistoryItemCell
                
                let analysis = analyses[indexPath.item - 1]
                cell.configure(with: analysis)
                
                cell.onDeleteTapped = { [weak self] in
                    guard let self = self else { return }
                    self.onDeleteAnalysis?(analysis, indexPath)
                }
                
                return cell
            }
        }
    }
    
    // MARK: - Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            onAddTapped?()
        } else {
            onSelectAnalysis?(analyses[indexPath.item - 1])
        }
    }
}
