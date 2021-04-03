//
//  ViewController.swift
//  Digital Identity App
//
//  Created by Mohammadreza Sadeghi on 25/03/2021.
//

import UIKit
import SceneKit
import ARKit

class ARCameraVC: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Set the scene to the view
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        guard  let  trackedImage = ARReferenceImage.referenceImages(inGroupNamed: "Digital Identity", bundle: Bundle.main)
        else { return }
        configuration.trackingImages = trackedImage
        configuration.maximumNumberOfTrackedImages = 1
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        if let imageAnchor = anchor as? ARImageAnchor  {
            
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.8)
            let planeNode = SCNNode(geometry: plane)

            planeNode.eulerAngles.x = -.pi / 2
            node.addChildNode(planeNode)
            
            
//            let takenImage = sceneView.snapshot()
//            print(takenImage)
//            let capturedImage = screenshot()
//            print("image Saved \(capturedImage)")
//            print("image found")
//
        }
        DispatchQueue.main.async {
            let takenImage =  self.screenshot()
        } 
        

    return node
    }
    
    func screenshot () -> UIImage {
             //Create the UIImage
             let renderer = UIGraphicsImageRenderer(size: view.frame.size)
             let image = renderer.image(actions: { context in
                 view.layer.render(in: context.cgContext)
             })
             
             //Save it to the camera roll
     UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
        return image
         }
     
     
     @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
             // save complete
         }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}

