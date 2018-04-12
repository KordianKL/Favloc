//
//  ViewController.swift
//  Favloc
//
//  Created by Kordian Ledzion on 03/01/2018.
//  Copyright © 2018 KordianLedzion. All rights reserved.
//

import UIKit

class MainCollectionViewController: UIViewController {
    
    weak var coordinator: MainCoordinator?
    
    private lazy var defaultBottomInset: CGFloat = {
        return layoutContextValue(base: CGFloat(17.0),
                                  contextMapping: [.iPhone5_5: CGFloat(8.0 * 17.0),
                                                   .iPhone4_7: CGFloat(6.0 * 17.0),
                                                   .iPhone4_0: CGFloat(4.0 * 17.0),
                                                   .iPhone3_5: CGFloat(2.0 * 17.0)])
    }()
    
    private let deleteButton = UIBarButtonItem()
    private let addButton = UIButton()
    private let collectionView: UICollectionView
    private let cellIdentifier = "collectionViewCell"
    private let defaultInset: CGFloat = 17.0
    private var longPressGesture: UILongPressGestureRecognizer!
    private let viewModel: DataSource
    private var deleting = false
    
    init(viewModel: DataSource) {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setUpCollectionView(with: collectionLayout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpNavBar()
        setUpAddButton()
        setUpGestureRecognizers()
        layoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setUpNavBar() {
        navigationItem.title = "FAVLOC"
        deleteButton.style = .plain
        deleteButton.title = "Select"
        deleteButton.action = #selector(deletionProcess)
        deleteButton.target = self
        navigationItem.leftBarButtonItem = deleteButton
    }
    
    private func setUpAddButton() {
        addButton.setImage(#imageLiteral(resourceName: "addButton"), for: .normal)
        addButton.addTarget(self, action: #selector(addNewPlace), for: .touchUpInside)
    }
    
    @objc private func addNewPlace() {
        viewModel.add {
            DispatchQueue.main.async { [unowned self] in
                self.collectionView.reloadData()
                self.scrollToBottom()
            }
        }
    }
    
    @objc private func deletionProcess() {
        if deleting {
            if let selectedItems = collectionView.indexPathsForSelectedItems {
                view.isUserInteractionEnabled = false
                for index in selectedItems {
                    self.collectionView.deselectItem(at: index, animated: true)
                }
                viewModel.delete(itemsAt: selectedItems) {
                    DispatchQueue.main.async { [unowned self] in
                        self.collectionView.reloadData()
                        self.view.isUserInteractionEnabled = true
                    }
                }
            }
        }
        deleteButton.style = deleting ? .plain : .done
        deleteButton.title = deleting ? "Select" : "Delete"
        addButton.isEnabled = deleting
        deleting = !deleting
        collectionView.allowsMultipleSelection = deleting
    }
    
    private func setUpGestureRecognizers() {
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(gesture:)))
        self.collectionView.addGestureRecognizer(longPressGesture)
    }
    
    @objc private func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
        case UIGestureRecognizerState.began:
            guard let selectedIndexPath = self.collectionView.indexPathForItem(at: gesture.location(in: self.collectionView)) else {
                break
            }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case UIGestureRecognizerState.changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case UIGestureRecognizerState.ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    private func layoutSubviews() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor)
            ])
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -24.0)
            ])
    }
    
    private func setUpCollectionView(with layout: UICollectionViewFlowLayout) {
        layout.itemSize = layoutContextValue(base: CGSize(width: 160, height: 210),
                                             contextMapping: [.iPhone4_0: CGSize(width: 270, height: 210),
                                                              .iPhone3_5: CGSize(width: 215, height: 210)])
        layout.minimumLineSpacing = defaultInset
        layout.minimumInteritemSpacing = defaultInset
        
        collectionView.backgroundColor = .paleGrey
        collectionView.register(MainCollectionViewControllerCell.self, forCellWithReuseIdentifier: cellIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPrefetchingEnabled = true
    }
    
    private func scrollToBottom() {
        let lastSectionIndex = collectionView.numberOfSections - 1
        let lastItemIndex = collectionView.numberOfItems(inSection: lastSectionIndex) - 1
        let indexPath = NSIndexPath(item: lastItemIndex, section: lastSectionIndex)
        collectionView.scrollToItem(at: indexPath as IndexPath, at: UICollectionViewScrollPosition.bottom, animated: true)
    }
}

extension MainCollectionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !deleting {
            let selectResult = viewModel.select(itemAt: indexPath.row)
            switch selectResult {
            case .success(let place):
                coordinator?.presentDetails(for: place) {
                    DispatchQueue.main.async { [unowned self] in
                        self.collectionView.deselectItem(at: indexPath, animated: true)
                        self.collectionView.reloadData()
                    }
                }
            case .failure:
                break
            }
        } else {
            let cell = collectionView.cellForItem(at: indexPath) as! MainCollectionViewControllerCell
            cell.toggleBorder()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MainCollectionViewControllerCell
        cell.toggleBorder()
    }
}

extension MainCollectionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                                      for: indexPath) as! MainCollectionViewControllerCell
        let selectResult = viewModel.select(itemAt: indexPath.row)
        switch selectResult {
            case .success(let place):
                cell.setUp(with: place)
            case .failure:
                break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        viewModel.insert(itemAt: sourceIndexPath.row, into: destinationIndexPath.row)
    }
}

extension MainCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: defaultInset, left: defaultInset, bottom: defaultBottomInset, right: defaultInset)
    }
}
