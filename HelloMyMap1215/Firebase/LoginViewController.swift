//
//  LoginViewController.swift
//  DemoFirebase
//
//  Created by 李世文 on 2021/9/5.
//

import UIKit
import Firebase
import FBSDKLoginKit
import GoogleSignIn

class LoginViewController: UIViewController,GIDSignInDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var fbLoginButtonView: UIView!
    
    @IBOutlet weak var googleLogin: GIDSignInButton!
    
    //Firebase
    //當用戶的登入狀態發生變化時會調用此 Listener
    var handle: AuthStateDidChangeListenerHandle?
    
    //Facebook
    var fbLoginButton = FBLoginButton()
    
    var loadingView: UIView?
    //var googleLogin: GIDSignInButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        //加入手勢，點擊收鍵盤
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardForTap))
        self.view.addGestureRecognizer(tap)
        
        //Facebook
        fbLoginButton.delegate = self
        fbLoginButton.permissions = ["public_profile", "email"]
        fbLoginButtonView.addSubview(fbLoginButton)
        
        //Google
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //Facebook
        fbLoginButton.frame.origin = CGPoint(x: 0, y: 0)
        fbLoginButton.frame.size = fbLoginButtonView.frame.size
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Firebase
        handle = Auth.auth().addStateDidChangeListener({ [weak self] auth, user in
            print("---觸發監聽器---LoginViewController")
            guard let self = self else { return }
            
            if let _ = user,
               self.presentedViewController == nil {
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
              
//                self.performSegue(withIdentifier: "LoginSuccessSegue", sender: nil)
                
//
                
            }
            
        })
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        view.setLoadingView(false)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    @objc func dismissKeyboardForTap(){
        self.view.endEditing(true)
    }
    
    @IBAction func dismissKeyboard(_ sender: UITextField) {}
    
    @IBAction func dissmissKeyboardWithRegisterButton(_ sender: Any) {
        view.endEditing(true)
    }
    
    func alert(title: String) {
        let controller = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
    }

    @IBAction func login(_ sender: Any) {
        view.endEditing(true)
        guard let email = emailTextField.text,
              email.isEmpty == false else {
            alert(title: "請輸入電子郵件地址")
            return
        }
        
        guard let password = passwordTextField.text,
              password.isEmpty == false else {
            alert(title: "請輸入密碼")
            return
        }
        
        view.setLoadingView(true)
        //Firebase
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            guard error == nil else {
                self.view.setLoadingView(false)
                if let errorInfo = error?.localizedDescription {
                    print("---登入失敗---\(errorInfo)")
                    self.alert(title: errorInfo)
                }
                return
            }
            
        }
    }
    
    
    
    fileprivate func moveToMapViewController() {
        let mapvc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyMapViewController")
        mapvc.modalPresentationStyle = .overFullScreen
        self.present(mapvc, animated: true, completion: nil)
    }
    
    //google登入
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error)
            return
        }
        guard let authentication = user.authentication else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,accessToken: authentication.accessToken)
        
        
        print("Google 登入成功")
        view.setLoadingView(true)
        
        //Firebase
        Auth.auth().signIn(with: credential) { [weak self] result, error in
            self!.view.setLoadingView(false)
            guard let self = self else {
                return
            }
            guard error == nil else {
                self.alert(title: "\(error!.localizedDescription)")
                return
            }
            print("Firebase 登入成功")
            self.moveToMapViewController()
            
        }
        
        
    }
    
    
    @IBAction func googleLogin(_ sender: Any) {
        //Google
        GIDSignIn.sharedInstance()?.signIn()
    }
}

//Facebook
extension LoginViewController: LoginButtonDelegate {
    
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard error == nil else {
            print("登入失敗 \(error!.localizedDescription)")
            alert(title: error!.localizedDescription)
            return
        }

        guard let token = result?.token else { return }

        print("FB 登入成功")
        view.setLoadingView(true)
        //Firebase
        let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)

        Auth.auth().signIn(with: credential) { [weak self] result, error in
            guard let self = self else {
                self!.view.setLoadingView(false)
                return
            }
            guard error == nil else {
                self.view.setLoadingView(true)
                print("Firebase 登入失敗 \(error!.localizedDescription)")
                self.alert(title: "\(error!.localizedDescription)")
                return
            }

            print("Firebase 登入成功")
            self.moveToMapViewController()
        }

    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("fb 登出")
    //    self.nameLabel.text = nil //logout就清除名字
    }
    
}
