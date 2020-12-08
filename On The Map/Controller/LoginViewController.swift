//
//  ViewController.swift
//  On The Map
//
//  Created by Tommy Lam on 12/8/20.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loginAction(_ sender: Any) {
        loginActionInProgress(status: true)
        UdacityAPI.login(userEmail: emailTextfield.text ?? "", password: passwordTextfield.text ?? "", completion: handleLoginCompletion(success:error:))
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        let signUpUrl = UdacityAPI.Endpoints.signUpUrl.url
        UIApplication.shared.open(signUpUrl, options: [:], completionHandler: nil)
    }

    func handleLoginCompletion(success: Bool, error: Error?) {
        if success {
            print("Login Success")
            //perform segue
            //self.performSegue(withIdentifier: "loggedIn", sender: nil)
            loginActionInProgress(status: false)
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapVC") as UIViewController
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: false, completion: nil)

        } else {
            loginActionInProgress(status: false)
            let alertVC = UIAlertController(title: "Login Error", message: "Please Check Login Credentials", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertVC, animated: true)

        }
    }

    func loginActionInProgress(status: Bool) {
        if status {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        emailTextfield.isEnabled = !status
        passwordTextfield.isEnabled  = !status
        loginButton.isEnabled = !status
        signUpButton.isEnabled = !status
    }
}

