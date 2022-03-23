//
//  RegisterViewController.swift
//  TMap
//
//  Created by student on 2022/3/17.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardForTap))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboardForTap(){
        self.view.endEditing(true)
    }
    
    @IBAction func dismissKeyboard(_ sender: Any) {}
    
    @IBAction func register(_ sender: Any) {
        view.endEditing(true)
        guard let email = emailTextField.text,
              email.isEmpty == false else {
            alert(title: "請輸入email")
            return
        }
        
        guard let password = passwordTextField.text,
              password.count > 5 else {
            alert(title: "密碼需大於(包含)6個字")
            return
        }
        
        guard let confirmPassword = confirmPasswordTextField.text,
              confirmPassword.isEmpty == false else {
            alert(title: "請輸入密碼確認")
            return
        }
        
        guard let name = nameTextField.text,
              name.isEmpty == false else {
            alert(title: "請輸入暱稱")
            return
        }
        
        guard password == confirmPassword else {
            alert(title: "密碼 與 密碼確認 不相符，請重新輸入")
            passwordTextField.text = ""
            confirmPasswordTextField.text = ""
            return
        }
        
        //註冊
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] authDataResult, error in
            guard let self = self else { return }
            guard let user = authDataResult?.user,
                  error == nil else {
                print("---註冊失敗---" + error!.localizedDescription)
                self.alert(title: error!.localizedDescription)
                return
            }
            print("---註冊成功--- email: \(user.email ?? "") --- uid: \(user.uid)")
            //設定匿名
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = name
            changeRequest?.commitChanges(completion: { [weak self] error in
                guard let self = self else { return }
                if error != nil {
                    print("---個人資料設定失敗---\(error!.localizedDescription)")
                } else {
                    print("---個人資料設定成功")
                }
                weak var pvc = self.presentingViewController
                self.dismiss(animated: true) {
//                    self.navigationController?.pushViewController(MyMapViewController(), animated: true)
                    pvc?.storyboard?.instantiateViewController(withIdentifier: "MapVC")
//                    pvc?.performSegue(withIdentifier: "LoginSuccessSegue", sender: nil)
                }
            })
            
        }
        
    }
    
    @IBAction func dismiss(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func alert(title: String) {
        let controller = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        controller.addAction(action)
        present(controller, animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
