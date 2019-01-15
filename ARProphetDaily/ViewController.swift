//
//  ViewController.swift
//  ARProphetDaily
//
//  Created by TRUNG NGUYEN on 1/15/19.
//  Copyright © 2019 TRUNG NGUYEN. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration()
        
        if let trackedImages = ARReferenceImage.referenceImages(inGroupNamed: "NewspaperImages", bundle: Bundle.main){
            
            configuration.trackingImages = trackedImages
            configuration.maximumNumberOfTrackedImages = 1
            
//            print("Images HarryPotter found in the folder")
        }

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        if let imageAnchor = anchor as? ARImageAnchor {
            
            let videoNode = SKVideoNode(fileNamed: "harrypotter.mp4")
            
            videoNode.play()
            
            let videoScene = SKScene(size: CGSize(width: 360, height: 144)) // if using a bigger size set than (480,360), the really scene may be smaller in AR; however, the smaller size is fine.
            
            videoNode.position = CGPoint(x: videoScene.size.width/2, y: videoScene.size.height/2)
            videoNode.yScale *= -1.0
            
            
            videoScene.addChild(videoNode)
            
            
            let planeGeometry = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width + 0.005, height: imageAnchor.referenceImage.physicalSize.height + 0.005)
            planeGeometry.firstMaterial?.diffuse.contents = videoScene
            
            let planeNode = SCNNode(geometry: planeGeometry)
            
            planeNode.eulerAngles.x = -.pi/2
            
            
            node.addChildNode(planeNode)
        }
        
        return node
    }

}
