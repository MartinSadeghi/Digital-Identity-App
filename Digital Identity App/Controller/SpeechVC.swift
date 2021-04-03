//
//  SpeechVC.swift
//  Digital Identity App
//
//  Created by Mohammadreza Sadeghi on 25/03/2021.
//

import Foundation
import UIKit
import Speech
import AVFoundation

class SpeechRecognizerManager {
    
    static let shared = SpeechRecognizerManager()
    let audioEngine = AVAudioEngine()
    let SpeechRecognizer : SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask:SFSpeechRecognitionTask?
    var isRecording = false
    private var mustBeEnable = false
    var textMessage = ""
    
    private init(){
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, options: .defaultToSpeaker)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch let error as NSError {
            print("ERROR:", error)
        }
    }
    
    func requestSpeechAthorization(callBack: @escaping (Bool)->Void){
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus
                {
                case .authorized :
                    callBack(true)
                case .denied :
                    callBack(false)
                    print("User denied access to speech recognition")
                case .restricted :
                    callBack(false)
                    print("Speech Recognition is restricted on this Device")
                case .notDetermined :
                    callBack(false)
                    print("Speech Recognition not yet authorized")
                @unknown default:
                    print("")
                }
            }
        }
    }
    
    func recordAndRecognizeSpeech(){
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer , _ in
            
            self.request.append(buffer)
        }
        audioEngine.prepare()
        do
        {
            try audioEngine.start()
        }catch
        {
            return print(error)
        }
        
        guard let myRecognizer = SFSpeechRecognizer() else {
            return
        }
        
        if !myRecognizer.isAvailable
        {
            return
        }
        
        recognitionTask = SpeechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            
            if let result = result
            {
                let bestString = result.bestTranscription.formattedString
                self.textMessage = bestString
                
            }else if let error = error
            {
                print(error)
            }
        })
        
        isRecording = true
    }
    
    func stopRecording(){
        if isRecording == true
        {
            print("isRecording : \(isRecording) so stop all elements")
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
            recognitionTask?.cancel()
            isRecording = false
        }
        else{
            print("isRecording : \(isRecording)")
            isRecording = true
        }
    }
    
    
}
