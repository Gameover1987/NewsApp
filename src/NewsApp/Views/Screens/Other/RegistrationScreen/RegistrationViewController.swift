
import UIKit
import SnapKit

final class RegistrationViewController : UIViewController {
    
    private let registrationViewModel: RegistrationViewModel
    private let viewFactory: ViewFactoryProtocol
    
    private lazy var userNameTextField: TextFieldWithPadding = {
        let textField = TextFieldWithPadding()
        textField.placeholder = "Имя"
        textField.backgroundColor = Colors.Common.textFieldBackground
        textField.keyboardType = .emailAddress
        textField.layer.cornerRadius = 22
        textField.addTarget(self, action: #selector(userNameTextFieldEditingChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var emailTextField: TextFieldWithPadding = {
        let textField = TextFieldWithPadding()
        textField.placeholder = "Почта"
        textField.backgroundColor = Colors.Common.textFieldBackground
        textField.keyboardType = .emailAddress
        textField.layer.cornerRadius = 22
        textField.addTarget(self, action: #selector(emailTextFieldEditingChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = TextFieldWithPadding()
        textField.isSecureTextEntry = true
        textField.placeholder = "Пароль"
        textField.layer.cornerRadius = 22
        textField.backgroundColor = Colors.Common.textFieldBackground
        textField.addTarget(self, action: #selector(passwordTextFieldEditingChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle(Strings.AuthAndRegistration.auth, for: .normal)
        button.titleLabel?.font = Fonts.forButtons
        button.backgroundColor = Colors.Common.buttonBackground
        button.layer.cornerRadius = 21
        button.addTarget(self, action: #selector(loginButtonTouch), for: .touchUpInside)
        return button
    }()
    
    init(registrationViewModel: RegistrationViewModel, viewFactory: ViewFactoryProtocol) {
        self.registrationViewModel = registrationViewModel
        self.viewFactory = viewFactory
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func loadView() {
        super.loadView()
        
        setupUI()
        bindViewModel()
    }
    
    @objc
    func userNameTextFieldEditingChanged() {
        registrationViewModel.userName = userNameTextField.text!
    }
    
    @objc
    func emailTextFieldEditingChanged() {
        registrationViewModel.email = emailTextField.text!
    }
    
    @objc
    func passwordTextFieldEditingChanged() {
        registrationViewModel.password = passwordTextField.text!
    }
    
    @objc
    func loginButtonTouch() {
        registrationViewModel.performRegistration()
    }
    
    private func setupUI() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        title = Strings.AuthAndRegistration.register
        
        view.backgroundColor = .white
        
        view.addSubview(userNameTextField)
        userNameTextField.snp.makeConstraints { make in
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(38)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(44)
        }
        
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(38)
            make.top.equalTo(userNameTextField.snp.bottom).offset(15)
            make.height.equalTo(44)
        }
        
        view.addSubview(passwordTextField)
        passwordTextField.snp.makeConstraints { make in
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(38)
            make.top.equalTo(emailTextField.snp.bottom).offset(15)
            make.height.equalTo(44)
        }
        
        view.addSubview(loginButton)
        loginButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(42)
        }
    }
    
    private func bindViewModel() {
        registrationViewModel.okAction = { [weak self] in
            guard let self = self else {return}
            
            self.navigationController?.pushViewController(self.viewFactory.createMainTabBar(), animated: true)
            self.navigationController?.navigationBar.isHidden = true
        }
        
        registrationViewModel.errorAction = { [weak self] error in
            self?.showMessage(title: "Ошибка", message: error)
        }
    }
}
