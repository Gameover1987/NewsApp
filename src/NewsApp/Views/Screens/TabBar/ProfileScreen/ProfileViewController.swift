
import UIKit

final class ProfileViewController : UIViewController {
    
    private lazy var userIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage(named: "userIcon")
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var userNameTextField: TextFieldWithPadding = {
        let textField = TextFieldWithPadding()
        textField.placeholder = "Имя"
        textField.backgroundColor = Colors.Common.textFieldBackground
        textField.keyboardType = .emailAddress
        textField.layer.cornerRadius = 22
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    private lazy var emailTextField: TextFieldWithPadding = {
        let textField = TextFieldWithPadding()
        textField.placeholder = "Почта"
        textField.backgroundColor = Colors.Common.textFieldBackground
        textField.keyboardType = .emailAddress
        textField.layer.cornerRadius = 22
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    private lazy var exitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Выйти", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.addTarget(self, action: #selector(exitButtonTouch), for: .touchUpInside)
        return button
    }()
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = Colors.Profile.background
        
        self.title = Strings.Profile.title
        
        view.addSubview(userIcon)
        userIcon.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(21)
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
        
        view.addSubview(userNameTextField)
        userNameTextField.snp.makeConstraints { make in
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(38)
            make.top.equalTo(userIcon.snp.bottom).offset(30)
            make.height.equalTo(44)
        }
        
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(38)
            make.top.equalTo(userNameTextField.snp.bottom).offset(15)
            make.height.equalTo(44)
        }
        
        view.addSubview(exitButton)
        exitButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        userNameTextField.text = Authorizer.shared.user?.userName
        emailTextField.text = Authorizer.shared.user?.email
    }
    
    @objc
    private func exitButtonTouch() {
        self.showExitDialog(title: "Выход", message: "Вы уверены, что хотите выйти из аккаунта") { isOk in
            if isOk {
                return
            }
            
            self.tabBarController?.navigationController?.popToRootViewController(animated: true)
        }
    }
}
