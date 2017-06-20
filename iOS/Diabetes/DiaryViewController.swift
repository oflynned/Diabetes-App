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
        let myUrl = URL(string: "http://13.94.249.94/api/v1");
        
        var request = URLRequest(url:myUrl!)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil {
                print("error=\(String(describing: error))")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let parseJSON = json {
                    let response = parseJSON["response"] as? String
                    self.createAlert(title: "Response", message: response!)
                }
            } catch {
                print(error)
            }
        }
        task.resume()
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
