//
//  ViewController.swift
//  Lab5
//
//  Created by Likhon Gomes on 4/1/20.
//  Copyright © 2020 Likhon Gomes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let imageView = UIImageView()
    let gameStatusTextView = UITextView()
    
    let player1NameLabel = UITextField()
    let player1ScoreLabel = UILabel()
    let player1ProgressView = UIProgressView()
    let player1PseudoProgressView = UIProgressView()
    
    let player2NameLabel = UITextField()
    let player2ScoreLabel = UILabel()
    let player2ProgressView = UIProgressView()
    let player2PseudoProgressView = UIProgressView()
    
    let continueButton = UIButton()
    let rollButton = UIButton()
    let holdButton = UIButton()
    
    let buttonStack = UIStackView()
    
    let dice = [#imageLiteral(resourceName: "Dice1"),#imageLiteral(resourceName: "Dice2"),#imageLiteral(resourceName: "Dice3"),#imageLiteral(resourceName: "Dice4"),#imageLiteral(resourceName: "Dice5"),#imageLiteral(resourceName: "Dice6")]
    var player1Name = String()
    var player2Name = String()
    var player1Score = Double()
    var player2Score = Double()
    var player:Int!
    var gameStarted = false
    var tempScore:Double?
    
    
    
    let gameColor = #colorLiteral(red: 0.9189423323, green: 0.3425189853, blue: 0.4192157984, alpha: 1)
    let disableColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder()
        view.backgroundColor = gameColor
        imageViewSetup()
        gameStatusSetup()
        
        buttonStackSetup()
        rollButtonSetup()
        holdButtonSetup()
        continueButtonSetup()
        
        player1ScoreLabelSetup()
        player1NameLabelSetup()
        player1ProgressViewSetup()
        
        player2ScoreLabelSetup()
        player2NameLabelSetup()
        player2ProgressViewSetup()
        
        player = 1
    }
    
    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        imageView.layer.add(animation, forKey: "shake")
    }
    
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }
    
    // Enable detection of shake motion
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            rollButtonTapped()
        }
    }
    
    func startGame(){
        tempScore = 0
        continueButton.isEnabled = false
        continueButton.setTitle("Tap to Continue", for: .normal)
        rollButton.isEnabled = true
    }
    
    func imageViewSetup(){
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: view.frame.size.width-100).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: view.frame.size.width-100).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.image = #imageLiteral(resourceName: "Dice6")
    }
    
    //MARK: Roll Button
    func rollButtonSetup(){
        rollButton.translatesAutoresizingMaskIntoConstraints = false
        rollButton.setTitle("Roll", for: .normal)
        rollButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        rollButton.backgroundColor = .white
        rollButton.setTitleColor(gameColor, for: .normal)
        rollButton.setTitleColor(disableColor, for: .disabled)
        rollButton.layer.cornerRadius = 10
        rollButton.isEnabled = false
        rollButton.addTarget(self, action: #selector(rollButtonTapped), for: .touchUpInside)
    }
    
    @objc func rollButtonTapped(){
        
        if gameStarted {
            var turn = Int.random(in: 1...6)
            imageView.image = dice[turn-1]

            let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .heavy)
            impactFeedbackgenerator.prepare()
            impactFeedbackgenerator.impactOccurred()
            shake()
            if player == 1 {
                if turn == 1 {
                    turn = 0
                    player = 2
                    tempScore = 0
                    player = 2
                    //holdButton.isEnabled = false
                    rollButton.isEnabled = false
                    continueButton.isEnabled = true
                    gameStatusTextView.text = "Lose turn! Player 2's turn"
                } else {
                    tempScore! += Double(turn)
                    //holdButton.isEnabled = true
                    
                }
                player1PseudoProgressView.setProgress(Float((player1Score + tempScore!) * 0.01), animated: true)
            }
            
            if player == 2 {
                if turn == 1 {
                    turn = 0
                    tempScore = 0
                    player = 1
                    //holdButton.isEnabled = false
                    rollButton.isEnabled = false
                    continueButton.isEnabled = true
                    gameStatusTextView.text = "Lose turn! Player 1's turn"
                } else {
                    tempScore! += Double(turn)
                    //holdButton.isEnabled = true
                }
                player2PseudoProgressView.setProgress(Float((player2Score + tempScore!) * 0.01), animated: true)
            }
            gameStatusTextView.text = "Turn total \(tempScore!)"
            if turn != 0 {
                print(turn)
                holdButton.isEnabled = true
            } else {
                holdButton.isEnabled = false
            }
        }
    }
    
    
    
    //MARK: Hold Button
    func holdButtonSetup() {
        holdButton.translatesAutoresizingMaskIntoConstraints = false
        holdButton.setTitle("Hold", for: .normal)
        holdButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        holdButton.backgroundColor = .white
        holdButton.setTitleColor(gameColor, for: .normal)
        holdButton.setTitleColor(disableColor, for: .disabled)
        holdButton.layer.cornerRadius = 10
        holdButton.isEnabled = false
        holdButton.addTarget(self, action: #selector(holdButtonTapped), for: .touchUpInside)
    }
    
    @objc func holdButtonTapped() {
        holdButton.isEnabled = false
        rollButton.isEnabled = false
        continueButton.isEnabled = true
        if player == 1 {
            player = 2
            if tempScore != nil { player1Score += tempScore! }
            gameStatusTextView.text = "\(tempScore!) points scored! Player 2's turn"
            player1ScoreLabel.text = String(player1Score)
            player1ProgressView.setProgress(Float(player1Score) * 0.01, animated: true)
            tempScore = 0
            if player1Score >= 100 {
                gameStatusTextView.text = "Congrats! player 1 wins"
                player1Score = 0
                player2Score = 0
                continueButton.setTitle("Tap to Start", for: .normal)
                player1PseudoProgressView.setProgress(Float((player1Score + tempScore!) * 0.01), animated: true)
                player2PseudoProgressView.setProgress(Float((player1Score + tempScore!) * 0.01), animated: true)
                player1ProgressView.setProgress(Float((player1Score + tempScore!) * 0.01), animated: true)
                player2ProgressView.setProgress(Float((player1Score + tempScore!) * 0.01), animated: true)
            }
        } else {
            player = 1
            if tempScore != nil { player2Score += tempScore! }
            gameStatusTextView.text = "\(tempScore!) points scored! Player 1's turn"
            player2ScoreLabel.text = String(player2Score)
            player2ProgressView.setProgress(Float(player2Score) * 0.01, animated: true)
            tempScore = 0
            if player1Score >= 100 {
                gameStatusTextView.text = "Congrats! player 1 wins"
                player1Score = 0
                player2Score = 0
                continueButton.setTitle("Tap to Start", for: .normal)
            }
        }
        
    }
    
    func buttonStackSetup() {
        view.addSubview(buttonStack)
        buttonStack.addArrangedSubview(rollButton)
        buttonStack.addArrangedSubview(holdButton)
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        buttonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
        buttonStack.heightAnchor.constraint(equalToConstant: 50).isActive = true
        buttonStack.backgroundColor = .red
        buttonStack.distribution = .fillEqually
        buttonStack.spacing = 10
    }
    
    //MARK: Coninious Button
    func continueButtonSetup() {
        view.addSubview(continueButton)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        continueButton.bottomAnchor.constraint(equalTo: buttonStack.topAnchor, constant: -10).isActive = true
        continueButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        continueButton.setTitleColor(gameColor, for: .normal)
        continueButton.setTitleColor(disableColor, for: .disabled)
        continueButton.backgroundColor = .white
        continueButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        continueButton.setTitle("New Game", for: .normal)
        continueButton.layer.cornerRadius = 10
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
    }
    
    @objc func continueButtonTapped(){
        gameStarted = true
        startGame()
    }
    
    func player1ScoreLabelSetup(){
        view.addSubview(player1ScoreLabel)
        player1ScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        player1ScoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        player1ScoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        player1ScoreLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        player1ScoreLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        player1ScoreLabel.font = UIFont.boldSystemFont(ofSize: 25)
        player1ScoreLabel.text = String(player1Score)
        player1ScoreLabel.textAlignment = .right
        player1ScoreLabel.textColor = .white
    }
    
    func player1NameLabelSetup() {
        view.addSubview(player1NameLabel)
        player1NameLabel.translatesAutoresizingMaskIntoConstraints = false
        player1NameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        player1NameLabel.trailingAnchor.constraint(equalTo: player1ScoreLabel.leadingAnchor, constant: -10).isActive = true
        player1NameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        player1NameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        player1NameLabel.layer.cornerRadius = 10
        player1NameLabel.font = UIFont.boldSystemFont(ofSize: 25)
        player1NameLabel.text = "Player1"
        player1NameLabel.textColor = .white
    }
    
    func player1ProgressViewSetup() {
        view.addSubview(player1PseudoProgressView)
        player1PseudoProgressView.translatesAutoresizingMaskIntoConstraints = false
        player1PseudoProgressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        player1PseudoProgressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        player1PseudoProgressView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        player1PseudoProgressView.topAnchor.constraint(equalTo: player1NameLabel.bottomAnchor, constant: 5).isActive = true
        player1PseudoProgressView.tintColor = #colorLiteral(red: 0.9587948918, green: 0.6680087447, blue: 0.7277810574, alpha: 1)
        
        
        view.addSubview(player1ProgressView)
        player1ProgressView.translatesAutoresizingMaskIntoConstraints = false
        player1ProgressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        player1ProgressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        player1ProgressView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        player1ProgressView.topAnchor.constraint(equalTo: player1NameLabel.bottomAnchor, constant: 5).isActive = true
        player1ProgressView.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    func player2ScoreLabelSetup(){
        view.addSubview(player2ScoreLabel)
        player2ScoreLabel.translatesAutoresizingMaskIntoConstraints = false
        player2ScoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        player2ScoreLabel.topAnchor.constraint(equalTo: player1ProgressView.bottomAnchor, constant: 10).isActive = true
        player2ScoreLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        player2ScoreLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        player2ScoreLabel.font = UIFont.boldSystemFont(ofSize: 25)
        player2ScoreLabel.text = String(player2Score)
        player2ScoreLabel.textAlignment = .right
        player2ScoreLabel.textColor = .white
    }
    
    
    
    func player2NameLabelSetup() {
        view.addSubview(player2NameLabel)
        player2NameLabel.translatesAutoresizingMaskIntoConstraints = false
        player2NameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        player2NameLabel.trailingAnchor.constraint(equalTo: player2ScoreLabel.leadingAnchor, constant: -10).isActive = true
        player2NameLabel.topAnchor.constraint(equalTo: player1ProgressView.bottomAnchor, constant: 10).isActive = true
        player2NameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        player2NameLabel.layer.cornerRadius = 10
        player2NameLabel.font = UIFont.boldSystemFont(ofSize: 25)
        player2NameLabel.text = "Player2"
        player2NameLabel.textColor = .white
    }
    
    func player2ProgressViewSetup() {
        view.addSubview(player2PseudoProgressView)
        player2PseudoProgressView.translatesAutoresizingMaskIntoConstraints = false
        player2PseudoProgressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        player2PseudoProgressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        player2PseudoProgressView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        player2PseudoProgressView.topAnchor.constraint(equalTo: player2NameLabel.bottomAnchor, constant: 5).isActive = true
        player2PseudoProgressView.tintColor = #colorLiteral(red: 0.9587948918, green: 0.6680087447, blue: 0.7277810574, alpha: 1)
        view.addSubview(player2ProgressView)
        player2ProgressView.translatesAutoresizingMaskIntoConstraints = false
        player2ProgressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        player2ProgressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        player2ProgressView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        player2ProgressView.topAnchor.constraint(equalTo: player2NameLabel.bottomAnchor, constant: 5).isActive = true
        player2ProgressView.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    func gameStatusSetup(){
        view.addSubview(gameStatusTextView)
        gameStatusTextView.translatesAutoresizingMaskIntoConstraints = false
        gameStatusTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        gameStatusTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        gameStatusTextView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        gameStatusTextView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        gameStatusTextView.textColor = .white
        gameStatusTextView.backgroundColor = .clear
        gameStatusTextView.font = UIFont.systemFont(ofSize: 20)
        gameStatusTextView.isScrollEnabled = false
        gameStatusTextView.isSelectable = false
        gameStatusTextView.textAlignment = .center
        gameStatusTextView.text = ""
    }
    
}

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        self.clipsToBounds = true  // add this to maintain corner radius
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.setBackgroundImage(colorImage, for: forState)
        }
    }
}
