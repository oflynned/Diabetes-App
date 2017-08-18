//
//  DiaryViewController.swift
//  Diabetes
//
//  Created by Ed on 25/05/2017.
//  Copyright © 2017 GlassByte. All rights reserved.
//

import UIKit
import SwiftyJSON

class DiaryViewController: UIViewController {
    
    var TableData:Array< String > = Array < String >()
    
    
   
    @IBOutlet weak var getRequestButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func forceGetRequest(_ sender: Any) {
        
        let parameters = ["email":"suleaa@hotmail.ie"] as [String : Any]

        
        guard let url = URL(string: "https://neurobranchbeta.com/api/v1/plans/get")else {return}
        
        var request = URLRequest(url:url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody =  try?JSONSerialization.data(withJSONObject: parameters, options: []) else{return}
        
        request.httpBody  = httpBody
        
        let session = URLSession.shared
        session.dataTask(with:request){(data,response,error) in
            if let response = response{
                print("response",response)
            }
            if let data = data {
                do{
                    let json =  try JSONSerialization.jsonObject(with: data, options: [])
                    print("JSON", json)
                 
                    //print("string4",string4)
                }catch{print(error)}
                }
            
            
        }.resume()
    }
    
    func createAlert(title: String, message: String) {
        let submitAction = UIAlertAction(title: "Submit", style: .default, handler: { (action) -> Void in })
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) -> Void in })
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(submitAction)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }

}
