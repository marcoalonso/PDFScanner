//
//  ViewController.swift
//  PDFScanner
//
//  Created by Marco Alonso Rodriguez on 30/10/22.
//

import UIKit
import Vision
import VisionKit
import PDFKit
import PhotosUI

class ViewController: UIViewController, VNDocumentCameraViewControllerDelegate {
    
    
    @IBOutlet weak var previewDoc: UIImageView!
    
    //MARK: Variables
    let pdfVista = PDFView()
    let scanVC = VNDocumentCameraViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pdfVista.delegate = self
        scanVC.delegate = self
        
        previewDoc.isUserInteractionEnabled = true
        previewDoc.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(previsualizar)))
        
        present(scanVC, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pdfVista.frame = view.bounds
    }
    
    @objc func previsualizar(){
        performSegue(withIdentifier: "verDocumento", sender: self)
    }
    
    @IBAction func abrirGaleriaButton(_ sender: UIBarButtonItem) {
        let vc = UIImagePickerController()
        vc.sourceType = .savedPhotosAlbum
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    
    @IBAction func guardarPDFButton(_ sender: UIBarButtonItem) {
        
        cargarPDF()
        let alerta = UIAlertController(title: "ATENCION", message: "¿Deseas guardar este documento como PDF?", preferredStyle: .alert)
        let accionAceptar = UIAlertAction(title: "SI", style: .default) { _ in
            let vc = UIActivityViewController(activityItems: [self.pdfVista.document?.dataRepresentation()!], applicationActivities: [])
            self.present(vc, animated: true)
        }
        alerta.addAction(accionAceptar)
        alerta.addAction(UIAlertAction(title: "No", style: .destructive))
        present(alerta, animated: true)
        
        
    }
    
    func cargarPDF(){
        previewDoc.addSubview(pdfVista)
        
        //Crear el documento a mostrar
        let documento = PDFDocument()
        guard let pagina = PDFPage(image: previewDoc.image ?? UIImage(systemName: "car")!) else { return }
        documento.insert(pagina, at: 0)
        
        pdfVista.document = documento
        
        //Diseño y visualizacion
        pdfVista.autoScales = true
        pdfVista.usePageViewController(true)
        
    }
    
    @IBAction func tomarOtraVezButton(_ sender: UIBarButtonItem) {
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

extension ViewController: PDFViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imagenSeleccionada = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            
            previewDoc.image = imagenSeleccionada
            //actualizar el pdf creado con esa pagina que se le agregara al documento PDF
            cargarPDF()
            
            picker.dismiss(animated: true)
            
        }
    }
    
}
