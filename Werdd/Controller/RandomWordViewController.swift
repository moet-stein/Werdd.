//
//  RandomWordViewController.swift
//  Werdd
//
//  Created by Moe Steinmueller on 10.05.22.
//

import UIKit

class RandomWordViewController: UIViewController {
    var wordManager = WordManager()
    private var fetchedWord: SingleResult?
    
    private var contentView: RandomWordView!
    
    private var cardSpinner: UIActivityIndicatorView!
    private var tableViewSpinner: UIActivityIndicatorView!
    
    private var wordLabel: UILabel!
    private var categoryImageView: CategoryImage!
    private var definitionLabel: UILabel!
    
    private var randomWordButton: IconButton!
    private var seeDetailsButton: IconButton!

    private var noWordFoundInRandomCard: NoWordFoundView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        wordManager.delegate = self
        wordManager.fetchRandomWord()
        
        contentView = RandomWordView()
        view = contentView
//        view.isUserInteractionEnabled = true
        
        cardSpinner = contentView.cardSpinner
        cardSpinner.startAnimating()
        
        wordLabel = contentView.wordLabel
        categoryImageView = contentView.categoryImageView
        definitionLabel = contentView.definitionLabel
        
        randomWordButton = contentView.randomWordButton
        seeDetailsButton = contentView.seeDetailsButton

        noWordFoundInRandomCard = contentView.noWordFoundInRandomCard
        addButtonsTarget()
        
        print("viewDidLoad RandomWordViewController")
        
    }
    
    override func viewDidLayoutSubviews() {
        addButtonsTarget()
        
    }

    private func addButtonsTarget() {
        randomWordButton.addTarget(self, action: #selector(randomWordButtonTapped), for: .touchUpInside)
        seeDetailsButton.addTarget(self, action: #selector(seeDetailsButtonTapped), for: .touchUpInside)
    }
    
    private func refreshCard(word: Word) {
        let word = word
        wordLabel.text = word.word
        
        let randomResult = word.results?.randomElement()
        fetchedWord = SingleResult(word: word.word, result: randomResult)
        
        if let category = fetchedWord?.result?.partOfSpeech {
            categoryImageView.isHidden = false
            categoryImageView.image = UIImage(named: category)
        } else {
            categoryImageView.isHidden = true
        }
        
        if let definition =  fetchedWord?.result?.definition {
            definitionLabel.text = definition
        } else {
            definitionLabel.text = "No definition found for this word"
        }
        
        wordLabel.zoomIn(duration: 0.5)
        categoryImageView.zoomIn(duration: 0.5)
        definitionLabel.zoomIn(duration: 0.5)
    }
    
    @objc func randomWordButtonTapped() {
        cardSpinner.startAnimating()
//        randomWordButton.isUserInteractionEnabled = false
        wordManager.fetchRandomWord()
        print("randomWordButtonTapped")
    }
    
    @objc func viewFavoritesButtonTapped() {
        navigationController?.pushViewController(FavoritesViewController(), animated: true)
    }
    
    @objc func seeDetailsButtonTapped() {
        navigationController?.pushViewController(DetailsViewController(passedFavWord: nil, selectedWord: fetchedWord), animated: true)
    }

}

extension RandomWordViewController: WordManegerDelegate {
    
    func didUpdateWord(_ wordManager: WordManager, word: Word) {
        print("didUpdateWord")
        DispatchQueue.main.async {
            self.wordLabel.isHidden = false
            self.definitionLabel.isHidden = false
            self.categoryImageView.isHidden = false
            self.noWordFoundInRandomCard.isHidden = true
            
            self.refreshCard(word: word)
            self.cardSpinner.stopAnimating()
            self.randomWordButton.isUserInteractionEnabled = true
        }
        
    }
    
    func didUpdateTableView(_ wordManager: WordManager, word: Word) {
//       words = [SingleResult]()
//        if let results = word.results {
//            for result in results {
//                self.words.append(SingleResult(word: word.word, result: result))
//            }
//        }  else {
//            self.words.append(SingleResult(word: word.word, result: nil))
//        }
//        DispatchQueue.main.async {
//            self.noWordFoundInTableView.isHidden = true
//            self.wordsTableView.reloadData()
//            self.tableViewSpinner.stopAnimating()
//            self.wordsTableView.isUserInteractionEnabled = true
//        }
    }
    
    func didFailWithError(error: Error?, random: Bool) {
        DispatchQueue.main.async {
            if random {
                self.wordLabel.isHidden = true
                self.definitionLabel.isHidden = true
                self.categoryImageView.isHidden = true
                self.noWordFoundInRandomCard.isHidden = false
                self.cardSpinner.stopAnimating()
                self.randomWordButton.isUserInteractionEnabled = true
            }
            
        }
        if let error = error {
            print(error)
        }
    }
    
}
