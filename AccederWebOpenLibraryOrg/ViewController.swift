//
//  ViewController.swift
//  AccederWebOpenLibraryOrg
//
//  Created by Rodrigo Gálvez Díaz on 26/8/16.
//  Copyright © 2016 iOS.SwiftProgramar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    // Variables enlazadas a la interfaz
    @IBOutlet weak var isbnTxt: UITextField!
    @IBOutlet weak var responseTxv: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        isbnTxt.delegate = self
        responseTxv.delegate = self
        responseTxv.text = "Inserta un ISBN en el cuadro superior para buscarlo"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:978-84-376-0494-7
    
    func asincrono(isbn: String?) {
        responseTxv.text = "Haciendo petición para el isbn: " + isbn!
        let urls = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:" + isbn!
        let url = NSURL(string: urls)
        let session = NSURLSession.sharedSession()
        let bloque = {(datos: NSData?, resp: NSURLResponse?, error: NSError?) -> Void in
            if error != nil {
                dispatch_async(dispatch_get_main_queue(), {
                    //Alerta
                    let alertController = UIAlertController(title: "Error", message:
                        "Hubo un error con la red, por favor compruebe que su dispositivo tenga acceso a la red.", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                })

                print(error)
            } else {
                let texto = NSString(data: datos!, encoding: NSUTF8StringEncoding)
                dispatch_async(dispatch_get_main_queue(), {
                    self.responseTxv.text = texto != "{}" ? texto as String! : "No se han encontrado resultados"
                })
                print(texto)
            }
            
            
        }
        
         let dt = session.dataTaskWithURL(url!, completionHandler: bloque)
        dt.resume()
        
    }
    
    // Reinicio del mensaje al borrar el texto de busqueda
    func textFieldShouldClear(textField: UITextField) -> Bool {
        responseTxv.text = "Inserta un ISBN en el cuadro superior para buscarlo"
        return true
    }

    // Ocultar el teclado y realizar la petición
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        asincrono(textField.text)
        return true
    }

}

