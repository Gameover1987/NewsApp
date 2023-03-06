
import UIKit
import SnapKit

final class ResetPasswordViewController : UIViewController {
    
    private let resetPasswordViewModel: ResetPasswordViewModel
    
    private lazy var emailTextField: TextFieldWithPadding = {
        let textField = TextFieldWithPadding()
        textField.placeholder = "Почта"
        textField.backgroundColor = Colors.Common.textFieldBackground
        textField.keyboardType = .emailAddress
        textField.layer.cornerRadius = 22
        textField.addTarget(self, action: #selector(emailTextFieldEditingChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var resetPasswordButton: UIButton = {
        let button = UIButton()
        button.setTitle(Strings.AuthAndRegistration.resetPasswordButton, for: .normal)
        button.titleLabel?.font = Fonts.forButtons
        button.backgroundColor = Colors.Common.buttonBackground
        button.layer.cornerRadius = 21
        button.addTarget(self, action: #selector(resetPasswordButtonTouch), for: .touchUpInside)
        return button
    }()
    
    init(resetPasswordViewModel: ResetPasswordViewModel) {
        self.resetPasswordViewModel = resetPasswordViewModel
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
    func emailTextFieldEditingChanged() {
        resetPasswordViewModel.email = emailTextField.text!
    }
    
    @objc
    func resetPasswordButtonTouch() {
        resetPasswordViewModel.resetPassword()
    }
    
    private func setupUI() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        title = Strings.AuthAndRegistration.resetPasswordTitle
        
        view.backgroundColor = .white
        
        view.addSubview(emailTextField)
        emailTextField.snp.makeConstraints { make in
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(38)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.height.equalTo(44)
        }
        
        view.addSubview(resetPasswordButton)
        resetPasswordButton.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(42)
        }
    }
    
    private func bindViewModel() {
        resetPasswordViewModel.okAction = { [weak self] in
            guard let self = self else {return}
            
            self.showMessage(title: "Успешно", message: "Инструкция по сбросу пароля \nпридет Вам на почту") {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        
        resetPasswordViewModel.errorAction = { [weak self] error in
            self?.showMessage(title: "Ошибка", message: error)
        }
    }
}
