//
//  ViewController.swift
//  Frog Timer
//
//  Created by Edwin Wilson on 5/10/19.
//  Copyright © 2019 Edwin Wilson. All rights reserved.
//

import UIKit
import AVFoundation
import CountdownLabel
import AudioToolbox

class ViewController: UIViewController {

    enum Constants {
        static let timerDuration: TimeInterval = 30
    }

    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var timerLabel: CountdownLabel!
    @IBOutlet weak var muteButton: UIButton!
    var player: AVAudioPlayer?

    func makePlayerReady() {
        guard let url = Bundle.main.url(forResource: "tomex", withExtension: "mp3") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

        } catch let error {
            print(error.localizedDescription)
        }
    }

    func playSound() {

        muteButton.isHidden = false
        player?.play()
    }


    func stopSound() {

        muteButton.isHidden = true
        player?.stop()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        muteButton.isHidden = true

        timerLabel.layer.borderColor = UIColor.black.cgColor
        timerLabel.layer.borderWidth = 3.0

        startStopButton.layer.borderColor = UIColor.black.cgColor
        startStopButton.backgroundColor = UIColor.green
        startStopButton.layer.cornerRadius = 10

        muteButton.layer.cornerRadius = 10
        muteButton.layer.borderWidth = 2.0
        muteButton.layer.borderColor = UIColor.black.cgColor

        timerLabel.animationType = .Fall
        timerLabel.countdownDelegate = self
        makePlayerReady()
        resetUI()
    }

    @IBAction func startStopButtonTapped(_ sender: UIButton) {

        stopSound()
        if sender.tag == 0 {
            sender.tag = 1
            startStopButton.backgroundColor = UIColor.red
            startStopButton.setTitle("STOP", for: .normal)
            startTimer()
        } else {
            timerLabel.cancel()
            resetUI()
        }

    }

    @IBAction func muteButtonTapped(_ sender: UIButton) {

        sender.isHidden = true
        stopSound()
    }

    func resetUI() {

        startStopButton.tag = 0
        timerLabel.text = " 00:00:\(Int(Constants.timerDuration)) "
        startStopButton.setTitle("START", for: .normal)
        startStopButton.backgroundColor = UIColor.green
    }

    func startTimer() {

        timerLabel.setCountDownTime(minutes: Constants.timerDuration)
        timerLabel.start()
    }

}

extension ViewController: CountdownLabelDelegate {

    @objc func countdownFinished() {

        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        resetUI()
        playSound()
    }

    @objc func countdownCancelled() {

        resetUI()
    }

    @objc func countingAt(timeCounted: TimeInterval, timeRemaining: TimeInterval) {

        var hepticFeedBack: UIImpactFeedbackGenerator?
        if timeRemaining < 3 {
            hepticFeedBack = UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle.heavy)
        } else {
            hepticFeedBack = UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle.light)
        }
        hepticFeedBack?.prepare()
        hepticFeedBack?.impactOccurred()
    }
}
