//
//  CameraViewController.swift
//  seesaw
//
//  Created by Ricardo on 2017/7/17.
//  Copyright © 2017年 Ricardo. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {

    @IBOutlet weak var cameraView: UIView!
    
    let captureSession = AVCaptureSession()
    
    var captureDevice: AVCaptureDevice?
    
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var phtotImage: UIImage?
    
    var frontCamera: Bool = false
    
    var stillImageOutput: AVCaptureStillImageOutput = AVCaptureStillImageOutput()
    
    
    
    @IBAction func setCamera(_ sender: Any) {
        frontCamera = !frontCamera
        captureSession.beginConfiguration()
        let inputs = captureSession.inputs as! [AVCaptureInput]
        for oldInput: AVCaptureInput in inputs{
            captureSession.removeInput((oldInput))
        }
        frontCamera(frontCamera)
        
        captureSession.commitConfiguration()
    }
   
    @IBAction func takePhoto(_ sender: Any) {
        if let videoConnection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo){
            stillImageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: {
                (imageDateSampleBuffer, error) in
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDateSampleBuffer)
                
                self.phtotImage = UIImage(data: imageData!)
                
                self.performSegue(withIdentifier: "segueToPhoto", sender: self)
                
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToPhoto" {
            if let photoViewController = segue.destination as? PhotoViewController{
                photoViewController.photoImage = self.phtotImage
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        frontCamera(frontCamera)
        if captureDevice != nil{
            beginSession()
        }
        
        // Do any additional setup after loading the view.
    }

    func beginSession(){
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.cameraView.layer.addSublayer(previewLayer!)
        previewLayer?.frame = self.cameraView.layer.bounds
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        captureSession.startRunning()
        stillImageOutput.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
        if captureSession.canAddOutput(stillImageOutput) {
            captureSession.addOutput(stillImageOutput)
        }
    }
    
    
    func frontCamera(_ front: Bool){
        let devices = AVCaptureDevice.devices()
        do{
            try captureSession.removeInput(AVCaptureDeviceInput(device: captureDevice))
        }catch{
            print("error")
        }
        
        for device in devices!{
            if((device as AnyObject).hasMediaType(AVMediaTypeVideo)){
                if front{
                    if (device as AnyObject).position == AVCaptureDevicePosition.front{
                        captureDevice = (device as? AVCaptureDevice)!
                        
                        do{
                            try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
                        }catch{
                            
                        }
                        break
                    }
                }else{
                    if (device as AnyObject).position == AVCaptureDevicePosition.back{
                        captureDevice = (device as? AVCaptureDevice)!
                        
                        do{
                            try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
                        }catch{
                            
                        }
                        break
                    }
                }
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
