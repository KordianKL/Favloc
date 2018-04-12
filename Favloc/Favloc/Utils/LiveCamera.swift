//
//  LiveCamera.swift
//  Favloc
//
//  Created by Kordian Ledzion on 14/01/2018.
//  Copyright © 2018 KordianLedzion. All rights reserved.
//

import AVFoundation
import UIKit

protocol LiveCameraDelegate: class {
    func didCaptureImage(_ data: Data?, on camera: LiveCamera)
}

class LiveCamera: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate, AVCapturePhotoCaptureDelegate {
    
    weak var delegate: LiveCameraDelegate?
    private var session: AVCaptureSession!
    private var photoOutput: AVCapturePhotoOutput!
    private var sessionQueue: DispatchQueue!
    
    init(view: UIView) {
        super.init()
        var backCameraDevice: AVCaptureDevice!
        session = AVCaptureSession()
        
        let devices = AVCaptureDevice.DiscoverySession.init(
            deviceTypes: [.builtInWideAngleCamera],
            mediaType: .video,
            position: .back
            ).devices
        
        for device in devices {
            backCameraDevice = device
        }
        
        var possibleCameraInput: AnyObject?
        do {
            possibleCameraInput = try AVCaptureDeviceInput.init(device: backCameraDevice)
        } catch let error{
            print(error)
        }
        
        if let backCameraInput = possibleCameraInput as? AVCaptureDeviceInput, session.canAddInput(backCameraInput) {
            session.addInput(backCameraInput)
        }
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.frame = view.bounds
        view.layer.addSublayer(previewLayer)
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sample buffer delegate", qos: DispatchQoS.userInitiated))
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
        }
        
        photoOutput = AVCapturePhotoOutput()
        photoOutput.isHighResolutionCaptureEnabled = true
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
        }
        
        session.sessionPreset = .photo
        
        sessionQueue = DispatchQueue(label: "com.example.camera.capture.session", qos: DispatchQoS.userInitiated)
        sessionQueue.async {
            self.session.startRunning()
        }
    }
    
    func capturePhoto() {
        sessionQueue.async { [weak self] in
            let settings = AVCapturePhotoSettings()
            settings.isAutoStillImageStabilizationEnabled = true
            settings.isHighResolutionPhotoEnabled = true
            settings.flashMode = .auto
            self?.photoOutput.capturePhoto(with: settings, delegate: self!)
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if let buffer = photoSampleBuffer {
            let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(
                forJPEGSampleBuffer: buffer,
                previewPhotoSampleBuffer: previewPhotoSampleBuffer
            )
            delegate?.didCaptureImage(data, on: self)
        } else {
            print("No buffer")
        }
    }
}

