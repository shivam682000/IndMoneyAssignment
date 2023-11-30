//
//  ViewController.swift
//  TestConcurrency
//
//  Created by Shivam Kumar on 27/11/23.
//

import UIKit

class GridViewController: UIViewController {
    
    var rows: Int = 4
    var column: Int = 3
    var space: Int = 5
    
    var thiefX: Int = 0
    var thiedY: Int = 0
    
    var policeX: Int = 1
    var policeY: Int = 1
    
    @IBOutlet weak var btnGenerate: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.btnGenerate.isEnabled = true
    }
    
    func generateCoordinateOfPoliceAndThief()  {
        self.thiefX = Int.random(in: 0...(self.rows-1))
        self.thiedY = Int.random(in: 0...(self.column-1))
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.generatePoliceCoordinate()
        }
    }
    
    func generatePoliceCoordinate() {
        self.policeX = self.randomExcludingNumber(from: 0, to: self.rows, excluding: self.thiefX)
        self.policeY = self.randomExcludingNumber(from: 0, to: self.column, excluding: self.thiedY)
        DispatchQueue.main.async {
            self.btnGenerate.isEnabled = true
            self.collectionView.reloadData()
        }
    }
    
    func randomExcludingNumber(from lowerBound: Int, to upperBound: Int, excluding excludingNumber: Int) -> Int {
        var randomValue: Int
        repeat {
            randomValue = Int.random(in: lowerBound..<upperBound)
        } while randomValue == excludingNumber

        return randomValue
    }
    
    private func setup() {
        collectionView.register(UINib(nibName: "GridCell", bundle: .main), forCellWithReuseIdentifier: "GridCell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    
    @IBAction func actionGenerate(_ sender: Any) {
        self.btnGenerate.isEnabled = false
        self.generateCoordinateOfPoliceAndThief()
    }
    
}

extension GridViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return rows
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return column
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath) as? GridCell else { return UICollectionViewCell() }
        let row = indexPath.section
        let column = indexPath.row
        cell.imgVwIcon.image = nil
        if row == self.thiefX && column == self.thiedY {
            cell.imgVwIcon.backgroundColor = nil
            cell.view.backgroundColor = .blue
            cell.imgVwIcon.image = UIImage(named: "robber")
        } else if row == self.policeX && column == self.policeY {
            cell.imgVwIcon.backgroundColor = nil
            cell.view.backgroundColor = .orange
            cell.imgVwIcon.image = UIImage(named: "police")
        } else {
            cell.imgVwIcon.image = nil
            cell.view.backgroundColor = .darkGray
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.frame.size.width
        let padding = (column - 1) * space
        let paddingFloat = CGFloat(padding)
        let itemWidthDifference = screenWidth - paddingFloat
        let itemWidth = itemWidthDifference/CGFloat(column)
        return CGSize(width: itemWidth - 2, height: itemWidth + 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(space)
    }
}
