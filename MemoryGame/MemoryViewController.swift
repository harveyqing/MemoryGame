//
//  MemoryViewController.swift
//  MemoryGame
//
//  Created by qingtian on 16/1/7.
//  Copyright © 2016年 qingtian. All rights reserved.
//

import UIKit

class MemoryViewController: UIViewController {
    
    // MARK: Properties
    
    private let difficulty: Difficulty
    
    private var collectionView: UICollectionView!
    private var deck: Deck!
    
    private var selectedIndexes = Array<NSIndexPath>()
    private var numberOfPairs = 0
    private var score = 0
    
    // MARK: Initializers
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(difficulty: Difficulty) {
        self.difficulty = difficulty
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: Deinitializers
    
    deinit {
        print("deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        start()
    }
    
    private func start() {
        deck = createDeck(numCardsNeededDifficulty(difficulty))
        for i in 0..<deck.count {
            print("The card at index [\(i)] is [\(deck[i].description)]")
        }
        collectionView.reloadData()
    }
    
    private func createDeck(numCards: Int) -> Deck {
        let fullDeck = Deck.full().shuffled()
        let halfDeck = fullDeck.deckOfNumberOfCards(numCards / 2)
        return (halfDeck + halfDeck).shuffled()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: Setup
private extension MemoryViewController {
    func setup() {
        view.backgroundColor = UIColor.greenSea()
        
        let space: CGFloat = 5
        let (covWidth, covHeight) = collectionViewSizeDifficulty(
            difficulty,
            space: space)
        let layout = layoutCardSize(
            cardSizeDifficulty(difficulty, space: space),
            space: space)
        
        collectionView = UICollectionView(
            frame: CGRect(x: 0, y: 0, width: covWidth, height: covHeight),
            collectionViewLayout: layout)
        collectionView.center = view.center
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.scrollEnabled = false
        collectionView.registerClass(
            CardCell.self,
            forCellWithReuseIdentifier: "cardCell")
        collectionView.backgroundColor = UIColor.clearColor()
        
        self.view.addSubview(collectionView)
        
    }
    
    func collectionViewSizeDifficulty(
        difficulty: Difficulty,
        space: CGFloat) -> (CGFloat, CGFloat)
    {
        let (columns, rows) = sizeDifficulty(difficulty)
        let (cardWidth, cardHeight) = cardSizeDifficulty(difficulty, space: space)
        
        let covWidth = columns * (cardWidth + 2 * space)
        let covHeight = rows * (cardHeight + space)
        
        return (covWidth, covHeight)
    }
    
    // Individual card size for a given difficulty
    func cardSizeDifficulty(
        difficulty: Difficulty, space: CGFloat) -> (CGFloat, CGFloat)
    {
        let ratio: CGFloat = 1.452
        let (_, rows) = sizeDifficulty(difficulty)
        let cardHeight: CGFloat = view.frame.height / rows - 2 * space
        let cardWidth: CGFloat = cardHeight / ratio
        return (cardWidth, cardHeight)
    }
    
    func layoutCardSize(
        cardSize: (cardWidth: CGFloat, cardHeight: CGFloat),
        space: CGFloat
    ) -> UICollectionViewLayout {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: space, left: space, bottom: space, right: space)
        layout.itemSize = CGSize(width: cardSize.cardWidth, height: cardSize.cardHeight)
        layout.minimumLineSpacing = space
        
        return layout
    }
}

// MARK: Difficulty
private extension MemoryViewController {
    // Cards number for a specific difficulty.
    func sizeDifficulty(difficulty: Difficulty) -> (CGFloat, CGFloat) {
        switch difficulty {
        case .Easy:
            return (4, 3)
        case .Medium:
            return (6, 4)
        case .Hard:
            return (8, 4)
        }
    }
    
    // total cards for a given difficulty.
    func numCardsNeededDifficulty(difficulty: Difficulty) -> Int {
        let (columns, rows) = sizeDifficulty(difficulty)
        return Int(columns * rows)
    }
}

// MARK: UICollectionViewDataSource
extension MemoryViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return deck.count
    }
    
    func collectionView(
        collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(
            "cardCell", forIndexPath: indexPath) as! CardCell
        let card = deck[indexPath.row]
        cell.renderCardName(card.description, backImageName: "back")
        
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension MemoryViewController: UICollectionViewDelegate {
    func collectionView(
        collectionView: UICollectionView,
        didSelectItemAtIndexPath indexPath: NSIndexPath
    ) {
        if selectedIndexes.contains(indexPath) {
            return
        }

        selectedIndexes.append(indexPath)

        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! CardCell
        cell.upturn()
        
        if selectedIndexes.count < 2 {
            return
        }
        
        let card1 = deck[selectedIndexes[0].row]
        let card2 = deck[selectedIndexes[1].row]
        
        if card1 == card2 {
            numberOfPairs++
            checkIfFinished()
            removeCards()
        } else {
            score++
            turnCardsFaceDown()
        }
    }
}

extension UIViewController {
    func execAfter(delay: Double, block: () -> Void) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(),
            block)
    }
}

// MARK: Actions
private extension MemoryViewController {
    func checkIfFinished() {
        if numberOfPairs == deck.count / 2 {
            showFinalPopUp()
        }
        
    }
    
    func removeCards() {
        execAfter(1.0) {
            self.removeCardsAtPlaces(self.selectedIndexes)
            self.selectedIndexes = Array<NSIndexPath>()
        }
    }
    
    func turnCardsFaceDown() {
        execAfter(2.0) {
            self.downturnCardsAtPlaces(self.selectedIndexes)
            self.selectedIndexes = Array<NSIndexPath>()
        }
        
    }
    
    func showFinalPopUp() {
        let alert = UIAlertController(
            title: "Great",
            message: "You won with score: \(score)",
            preferredStyle: .Alert)
        alert.addAction(UIAlertAction(
            title: "Ok",
            style: .Default,
            handler: { action in
                self.dismissViewControllerAnimated(true, completion: nil)
                return
            }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func removeCardsAtPlaces(places: Array<NSIndexPath>) {
        for index in places {
            let cardCell = collectionView.cellForItemAtIndexPath(index) as! CardCell
            cardCell.remove()
        }
    }
    
    func downturnCardsAtPlaces(places: Array<NSIndexPath>) {
        for index in places {
            let cardCell = collectionView.cellForItemAtIndexPath(index) as! CardCell
            cardCell.downturn()
        }
    }
}