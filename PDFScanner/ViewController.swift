//
//  ViewController.swift
//  PDFScanner
//
//  Created by Marco Alonso Rodriguez on 30/10/22.
//

import UIKit
import Vision
import VisionKit

class ViewController: UIViewController, VNDocumentCameraViewControllerDelegate {

    
    @IBOutlet weak var previewDoc: UIImageView!
    
    //MARK: Variables
    let scanVC = VNDocumentCameraViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scanVC.delegate = self
        present(scanVC, animated: true)
    }

    //MARK: Delegate
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        if scan.pageCount > 0 {
            
            previewDoc.image = scan.imageOfPage(at: 0)
            
         controller.dismiss(animated: true)
        }
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        controller.dismiss(animated: true) {
            let alerta = UIAlertController(title: "ATENCION", message: "", preferredStyle: .alert)
            let accionAceptar = UIAlertAction(title: "OK", style: .default) { _ in
                //Do something
            }
            alerta.addAction(accionAceptar)
            self.present(alerta, animated: true)
        }
    }

}

