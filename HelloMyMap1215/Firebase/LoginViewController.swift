//
//  LoginViewController.swift
//  TMap
//
//  Created by student on 2022/3/17.
//

import UIKit
import Firebase
import FBSDKLoginKit
import GoogleSignIn

class LoginViewController: UIViewController,GIDSignInDelegate {
    
    
    
    @IBOutlet weak var facebookLoginBtn: UIButton!
    
    @IBOutlet weak var googleLogin: UIButton!
    
    @IBOutlet weak var appleLogin: UIView!
    
//    @IBOutlet weak var privacyBtn: UIButton!
    
    //Firebase
    //當用戶的登入狀態發生變化時會調用此 Listener
    var handle: AuthStateDidChangeListenerHandle?
    
    //Facebook
    var fbLoginButton = FBLoginButton()
    
    var loadingView: UIView?
    
    //var googleLogin: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        
        //加入手勢，點擊收鍵盤
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardForTap))
        self.view.addGestureRecognizer(tap)
        
        //Facebook
        facebookLoginBtn.layer.cornerRadius = 7
        facebookLoginBtn.backgroundColor = UIColor.white
        facebookLoginBtn.addTarget(self, action: #selector(facebookLoginBtnAct), for: .touchUpInside)
        facebookLoginBtn.setTitleColor(.blue, for: .normal)
        
        //Google
        googleLogin.layer.cornerRadius = 7
        googleLogin.backgroundColor = UIColor.white
        googleLogin.addTarget(self, action: #selector(googleLoginBtnAct), for: .touchUpInside)
        googleLogin.setTitleColor(.blue, for: .normal)
        
        appleLogin.layer.cornerRadius = 7
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Firebase
        handle = Auth.auth().addStateDidChangeListener({ [weak self] auth, user in
            print("---觸發監聽器---LoginViewController")
            guard let self = self else { return }
            
            if let _ = user,
               self.presentedViewController == nil {
                
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
    
    
    @objc func facebookLoginBtnAct(){
        
        let loginManager = LoginManager()
        
        //for FB
        loginManager.logIn(permissions: ["public_profile", "email"], from: self){
            [weak self] (result ,error) in
            
            // Check for error
            guard error == nil else {
                // Error occurred
                print(error!.localizedDescription)
                return
            }
            // Check for cancel
            guard let result = result, !result.isCancelled else {
                print("User cancelled login")
                return
            }
            
            guard let token = result.token else { return }
            
            self!.view.setLoadingView(true)
            //Firebase
            let credential = FacebookAuthProvider.credential(withAccessToken: token.tokenString)
            
            Auth.auth().signIn(with: credential) { [weak self] result, error in
                self!.view.setLoadingView(false)
                guard error == nil else {
                    print("Firebase 登入失敗 \(error!.localizedDescription)")
                    self!.alert(title: "\(error!.localizedDescription)")
                    return
                }
                
                print("Firebase 登入成功")
                self!.moveToMapViewController()
            }
        }
    }
    
    @objc func googleLoginBtnAct(){
        
        GIDSignIn.sharedInstance()?.signIn()
    }

    @IBAction func privacyBtn(_ sender: AnyObject) {

    //    @objc func privacyBtn(){
        print("inside")
        if let url = URL(string: "https://pages.flycricket.io/tmap/privacy.html"){
        
            UIApplication.shared.open(url, options:[:])}
        
    
}
}
