//
//  Son.swift
//  ulviEvAlir
//
//  Created by serhan on 25.12.22.
//

import UIKit

class Son: UIViewController {

    
    
    @IBOutlet weak var yigilanPul: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let baza = UserDefaults.standard
        let yigilanPul2 = baza.integer(forKey: "yigilanPul")
        yigilanPul.text = "\(yigilanPul2)"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated:  true  )
    }
    
    @IBAction func tekrarOyna(_ sender: Any) {
        
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
}
