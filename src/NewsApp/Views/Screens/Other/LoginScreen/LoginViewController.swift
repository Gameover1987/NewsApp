
import UIKit
import SnapKit

final class LoginViewController : UIViewController {
    
    private let loginViewModel: LoginViewModel
    private let viewFactory: ViewFactoryProtocol
    
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
        button.setTitle(Strings.Auth.auth, for: .normal)
        button.titleLabel?.font = Fonts.forButtons
        button.backgroundColor = Colors.Common.buttonBackground
        button.layer.cornerRadius = 21
        button.addTarget(self, action: #selector(loginButtonTouch), for: .touchUpInside)
        return button
    }()
    
    private lazy var noAccountLabel: UILabel = {
        let label = UILabel()
        label.text = "Нет аккаунта?"
        label.font = Fonts.forCaptions
        return label
    }()
    
    private lazy var registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Зарегистрироваться", for: .normal)
        button.setTitleColor(Colors.Common.hyperlinkButtontext, for: .normal)
        button.titleLabel?.font = Fonts.forHyperlinkButtons
        return button
    }()
    
    private lazy var resetPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle("Сбросить пароль", for: .normal)
        button.setTitleColor(Colors.Common.hyperlinkButtontext, for: .normal)
        button.titleLabel?.font = Fonts.forHyperlinkButtons
        return button
    }()
    
    init(loginViewModel: LoginViewModel, viewFactory: ViewFactoryProtocol) {
        self.loginViewModel = loginViewModel
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
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        title = Strings.Auth.auth
        
#if DEBUG
        emailTextField.text = "test@mail.com"
        emailTextFieldEditingChanged()
        passwordTextField.text = "12345"
        passwordTextFieldEditingChanged()
#endif
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @objc func emailTextFieldEditingChanged() {
        loginViewModel.login = emailTextField.text!
    }
    
    @objc func passwordTextFieldEditingChanged() {
        loginViewModel.password = passwordTextField.text!
    }
    
    @objc func loginButtonTouch() {
        loginViewModel.authorize()
    }
    
    private func bindViewModel() {
        loginViewModel.okAction = { [weak self] in
            guard let self = self else {return}
            
            self.navigationController?.pushViewController(self.viewFactory.createMainTabBar(), animated: true)
            self.navigationController?.navigationBar.isHidden = true
        }
        
        loginViewModel.errorAction = { error in
            print(error)
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(38)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(45)
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
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(88)
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.height.equalTo(42)
        }
        
        let hStack = UIStackView(arrangedSubviews: [noAccountLabel, registerButton])
        hStack.setCustomSpacing(6, after: noAccountLabel)
        view.addSubview(hStack)
        hStack.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(loginButton.snp.bottom).offset(20)
        }
        
        view.addSubview(resetPasswordButton)
        resetPasswordButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
    }
}
