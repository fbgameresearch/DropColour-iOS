//
//  GameOverViewController.swift
//  ELColorGame
//
//  Created by Mateusz Szklarek on 26/09/15.
//  Copyright © 2015 EL Passion. All rights reserved.
//

import UIKit
import GameKit

class GameOverViewController: UIViewController, GKGameCenterControllerDelegate, GameOverViewDelegate {


    private let scoreNumber: Int

        self.scoreNumber = score
        super.init(nibName: nil, bundle: nil)
        self.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        self.modalPresentationStyle = UIModalPresentationStyle.Custom
    }

    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func loadView() {
        self.view = GameOverView(score: scoreNumber, delegate: self)
    }

    // MARK: GameOverViewDelegate

    func gameOverViewDidTapRetry(gameOverView: GameOverView) {
        }
    }

    func gameOverViewDidTapShowLeaders(gameOverView: GameOverView) {
        showLeaders()
    }

    func gameOverViewDidTapQuit(gameOverView: GameOverView) {
        }
    }
    
    // MARK: GameCenter
    
    func showLeaders() {
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        presentViewController(gc, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
}



}
