//
//  GameViewController.swift
//  ELColorGame
//
//  Created by Mateusz Szklarek on 24/09/15.
//  Copyright © 2015 EL Passion. All rights reserved.
//

import UIKit
import SnapKit
import AVFoundation
import GameKit

class GameViewController: UIViewController, GameViewDelegate, MenuViewControllerDelegate {
    
    var scoreNumber = 0
    var gameBoardController: GameBoardController?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = GameView(delegate: self)
        self.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupGameIfNeeded()
    }
    
    private func setupGameIfNeeded() {
        if let gameView = view as? GameView {
            if gameView.boardView == nil {
                let boardView = createGameBoardView(gameView: gameView)
                gameView.boardView = boardView
                gameBoardController = GameBoardController(view: boardView)
            }
        }
    }
    
    private func createGameBoardView(gameView gameView: GameView) -> GameBoardView {
        let slotSize = CGSize(width: 44, height: 44)
        let spacing = CGFloat(15.5)
        let (rows, columns) = GameBoardView.maxBoardSize(forViewSize: gameView.boardContainerView.frame.size, slotSize: slotSize, spacing: spacing)
        return GameBoardView(slotSize: slotSize, rows: rows, columns: columns, spacing: spacing)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        gameBoardController?.startInserting()
    }
    
    override func viewWillDisappear(animated: Bool) {
        gameBoardController?.stopInserting()
    }
    
    // MARK: Sound
    
    func playSound() {
        if let soundURL = NSBundle.mainBundle().URLForResource("bubble_pop_sound", withExtension: "m4a") {
            var mySound: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(soundURL, &mySound)
            AudioServicesPlaySystemSound(mySound);
        }
    }
    
    func playBombSound() {
        if let soundURL = NSBundle.mainBundle().URLForResource("bomb_explosion", withExtension: "m4a") {
            var mySound: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(soundURL, &mySound)
            AudioServicesPlaySystemSound(mySound);
        }
    }
    
    // MARK: GameCenter
    
    func synchronizeHighestScore() {
        if GKLocalPlayer.localPlayer().authenticated {
            let score = GKScore(leaderboardIdentifier: "drag_and_drop_color_leaderboard_01")
            score.value = Int64(scoreNumber)
            GKScore.reportScores([score], withCompletionHandler: { (error) -> Void in
                if error != nil {
                    print("error")
                }
            })
        }
    }
    
    private func presentMenuViewController() {
        let menuViewController = MenuViewController(delegate: self)
        presentViewController(menuViewController, animated: true, completion: nil)
    }

    // MARK: GameViewDelegate

    func gameBoardViewDidTapPause(gameBoardView: GameView) {
        gameBoardController?.stopInserting()
        self.presentMenuViewController()
    }

    func gameBoardViewDidTapRestart(gameBoardView: GameView) {
        gameBoardController?.restartGame()
    }
    
    // MARK: MenuViewControllerDelegate
    
    func menuViewControllerDidResumeGame(menuViewController: MenuViewController) {
        gameBoardController?.startInserting()
    }
    
    func menuViewControllerDidTapNewGame(menuViewController: MenuViewController) {
        gameBoardController?.restartGame()
    }
    
    func menuViewControllerDidTapQuit(menuViewController: MenuViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}