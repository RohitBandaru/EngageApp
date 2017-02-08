//
//  VoicemailViewController.swift
//  EngageApp
//
//  Created by Grace Lam on 1/9/17.
//  Copyright © 2017 Huna Makia. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import AudioKit
import Speech

class VoicemailViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    
    var candidate: Candidate!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var positionLabel: UILabel!
    @IBOutlet var companyLabel: UILabel!
    
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var playButton: UIButton!
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var imageView: UIImageView!
    
    var audioRecorder:AVAudioRecorder!
    var audioPlayer:AVAudioPlayer!
    var recordingName:String = ""
    
    // booleans for wave animation functionalities
    var startedPlayback:Bool!
    var replay:Bool!
    
    // init AudioKit for audio wave animation
    var mic = AKMicrophone()
    var playerWave:AKAudioPlayer!
    var audioInputPlot: EZAudioPlot = EZAudioPlot()
    var plot: AKNodeOutputPlot!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = candidate.fullName
        locationLabel.text = candidate.location
        positionLabel.text = candidate.position
        companyLabel.text = candidate.company
        
        startedPlayback = false
        replay = false
        
        // disable play and done buttons on launch
        playButton.isEnabled = false
        playButton.alpha = 0.35
        doneButton.isEnabled = false
        doneButton.alpha = 0.25
        recordButton.setBackgroundImage(UIImage(named: "record"), for: UIControlState.normal)
        playButton.setBackgroundImage(UIImage(named: "play"), for: UIControlState.normal)
        
        // set the audio file
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        var currentDateTime = Date()
        var formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        recordingName = formatter.string(from: currentDateTime)+".wav"
        var pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        //print(filePath!)
        
        // set up audio session
        var session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            print("e " + error.localizedDescription)
        }
        
        do {
            try session.setActive(true)
        } catch let error as NSError {
            print("f " + error.localizedDescription)
        }
        
        // initialize and prepare the recorder
        do {
            audioRecorder = try AVAudioRecorder(url: filePath!, settings: [:])
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            
        } catch let error as NSError {
            audioRecorder = nil
            print("g " + error.localizedDescription)
        }
        
        // initialize and prepare the player
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioRecorder.url)
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
        } catch let error as NSError {
            audioPlayer = nil
            print("h " + error.localizedDescription)
        }
        
        self.view.addSubview(audioInputPlot)
        
        do {
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
        } catch _ {
        }
    }
    
    
    func setupRecordingPlot() {
        if (plot != nil) {
            plot.clear()
            audioInputPlot.willRemoveSubview(plot)
            plot.removeFromSuperview()
        }
        
        mic = AKMicrophone()
        let frm: CGRect = imageView.frame
        let borders: CGRect = CGRect(x: frm.origin.x, y: frm.origin.y, width: frm.size.width, height: frm.size.height)
        let tracker = AKAmplitudeTracker.init(mic)
        let silence = AKBooster(tracker, gain: 0)
        AudioKit.output = silence
        audioInputPlot.bounds = borders
        audioInputPlot.frame = borders
        
        mic.stop()
        plot = AKNodeOutputPlot(mic, frame: borders)
        plot.plotType = .rolling
        plot.shouldFill = true
        plot.shouldMirror = true
        plot.color = UIColor.gray
        plot.gain = 3 // adjust later
        plot.backgroundColor = UIColor.white
        audioInputPlot.addSubview(plot)
    }
    
    @IBAction func recordStopButton(sender: UIButton) {
        
        // determining function of record/stop button
        if (recordButton.currentBackgroundImage == UIImage(named: "record")) {
            recordAudio()
        } else {
            stopRecording()
        }
    }
    
    func recordAudio() {
        
        switch AVAudioSession.sharedInstance().recordPermission() {
            case AVAudioSessionRecordPermission.granted:
                print("Permission granted")
            
            case AVAudioSessionRecordPermission.denied:
                let alert = UIAlertController(title: "Microphone Access Denied", message: "This app requires microphone access to record the voicemail.", preferredStyle: .alert)
                
                let settingsAction = UIAlertAction(title: "Settings", style: .default) { (action:UIAlertAction!) in
                    guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                        return
                    }
                    
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        })
                    }
                }
                alert.addAction(settingsAction)
                
                self.present(alert, animated: true, completion:nil)
                return
            
            default:
                break
        }
        
        recordButton.setBackgroundImage(UIImage(named: "stop"), for: UIControlState.normal)
        
        // stop the audio player before recording
        if (audioPlayer.isPlaying) {
            audioPlayer.stop()
            
            playerWave.stop()
            AudioKit.stop()
        }
        
        // start recording
        if (!audioRecorder.isRecording) {
            
            audioRecorder.record()
            
            playButton.isEnabled = false
            playButton.alpha = 0.35
            doneButton.isEnabled = false
            doneButton.alpha = 0.25
            
            // animate audio wave
            setupRecordingPlot()
            AudioKit.start()
            mic.start()
        }
    }
    
    func stopRecording() {
        
        recordButton.setBackgroundImage(UIImage(named: "record"), for: UIControlState.normal)
        
        // stop recording and close the file, else cannot play
        if (audioRecorder.isRecording) {
            
            audioRecorder.stop()
            
            playButton.isEnabled = true
            playButton.alpha = 1
            doneButton.isEnabled = true
            doneButton.alpha = 1
            
            // animate audio wave
            AudioKit.stop()
            mic.stop()
            
            startedPlayback = false
        }
        
        // update the player here, else play will always start from beginning
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioRecorder.url)
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
        } catch let error as NSError {
            audioPlayer = nil
            print("a " + error.localizedDescription)
        }
        
        do {
            playerWave = try AKAudioPlayer(file: AKAudioFile(forReading: audioRecorder.url))
            playerWave.looping = true
        } catch let error as NSError {
            playerWave = nil
            print("b " + error.localizedDescription)
        }
    }
    
    
    func setupPlaybackPlot() {
        plot.clear()
        audioInputPlot.willRemoveSubview(plot)
        plot.removeFromSuperview()
        
        let frm: CGRect = imageView.frame
        let borders: CGRect = CGRect(x: frm.origin.x, y: frm.origin.y, width: frm.size.width, height: frm.size.height)
        let tracker = AKAmplitudeTracker.init(playerWave)
        let silence = AKBooster(tracker, gain: 0)
        AudioKit.output = silence
        
        plot = AKNodeOutputPlot(playerWave, frame: borders)
        plot.plotType = .rolling
        plot.shouldFill = true
        plot.shouldMirror = true
        plot.color = UIColor.gray
        plot.gain = 3 // adjust later
        plot.backgroundColor = UIColor.white
        audioInputPlot.addSubview(plot)
    }
    
    @IBAction func playPauseButton(sender: UIButton) {
        
        // determining function of play/pause button
        if (playButton.currentBackgroundImage == UIImage(named: "play")) {
            playAudio()
        } else {
            pauseAudio()
        }
    }
    
    func playAudio() {
        
        playButton.setBackgroundImage(UIImage(named: "pause"), for: UIControlState.normal)
        recordButton.isEnabled = false
        recordButton.alpha = 0.35
        
        // play the recording
        if (!audioPlayer.isPlaying) {
            
            if (!startedPlayback) {
                setupPlaybackPlot()
                startedPlayback = true
            }
            
            // animate audio wave
            AudioKit.start()
            if (replay == true) {
                plot.clear()
                playerWave.stop()
                playerWave.startTime = 0.0
                playerWave.play(from: 0.0)
                //print(playerWave.startTime, playerWave.currentTime, playerWave.endTime)
                replay = false
            } else {
                playerWave.start()
            }
            
            audioPlayer.play()
            //print("playing", playerWave.currentTime, audioPlayer.duration) // for testing purposes
        }
    }
    
    func pauseAudio() {
        
        playButton.setBackgroundImage(UIImage(named: "play"), for: UIControlState.normal)
        recordButton.isEnabled = true
        recordButton.alpha = 1
        
        // animate audio wave
        playerWave.pause()
        AudioKit.stop()
        
        // pause the replay
        if (audioPlayer.isPlaying) {
            audioPlayer.pause()
        }
    }
    
    
    @IBAction func doneVoicemail(sender: UIButton) {
        
        // end voicemail recording session
        audioRecorder.stop()
        audioPlayer.stop()
        
        AudioKit.stop()
        playerWave.stop()
        mic.stop()
        
        // set audio session inactive
        var audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch let error as NSError {
            print("c " + error.localizedDescription)
        }
        
        self.performSegue(withIdentifier: "doneSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // pass the recorded file to the next view controller
        if segue.identifier == "doneSegue" {
            let destinationViewController = segue.destination as! ConfirmVoicemailViewController
            destinationViewController.audioFile = audioRecorder.url as NSURL!
            destinationViewController.candidate = candidate
            destinationViewController.recordingName = self.recordingName
        }
    }
    
    @IBAction func returnFromSegueActions(sender: UIStoryboardSegue) {
        if sender.identifier == "doneSegueUnwind" {
            // disable play and done buttons on return
            playButton.isEnabled = false
            playButton.alpha = 0.35
            doneButton.isEnabled = false
            doneButton.alpha = 0.25
            recordButton.isEnabled = true
            recordButton.alpha = 1
            recordButton.setBackgroundImage(UIImage(named: "record"), for: UIControlState.normal)
            playButton.setBackgroundImage(UIImage(named: "play"), for: UIControlState.normal)
            
            var audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setActive(true)
            } catch let error as NSError {
                print("d " + error.localizedDescription)
            }
            
            audioRecorder.deleteRecording()
            plot.clear()
        }
    }
    
    override func segueForUnwinding(to toViewController: UIViewController, from fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
        if let id = identifier{
            if id == "doneSegueUnwind" {
                let unwindSegue = SegueFromLeftUnwind(identifier: id, source: fromViewController, destination: toViewController, performHandler: { () -> Void in
                    
                })
                return unwindSegue
            }
        }
        
        return super.segueForUnwinding(to: toViewController, from: fromViewController, identifier: identifier)!
    }
    
    
    @IBAction func backPushed(sender:UIButton) {
        self.performSegue(withIdentifier: "voicemailToSearchResults", sender: self)
        
    }
    
    
    // handling audio interruptions when recording, flag will be false
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        recordButton.setBackgroundImage(UIImage(named: "record"), for: UIControlState.normal)
        
        if !flag {
            audioRecorder.stop()
            mic.stop()
            
            playButton.isEnabled = false
            playButton.alpha = 0.35
            doneButton.isEnabled = false
            doneButton.alpha = 0.25
            
            let alert = UIAlertController(title: "Error", message: "Your voicemail could not be recorded due to interruptions. Please try recording again.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            }
            alert.addAction(okAction)
            
            self.present(alert, animated: true, completion:nil)
        }
    }
    
    
    // handling audio interruptions when recording, flag will be false
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        // reset play button if finished playing successfully
        if flag {
            pauseAudio()
            replay = true
        }
    }
}
