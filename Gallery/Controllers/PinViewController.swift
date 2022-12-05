import UIKit
import LocalAuthentication

class PinViewController: UIViewController {
    
    private let isFirstLaunch: Bool = StorageService.shared.isFirstLaunch
    private var isFirstLoad: Bool = true
    private var enteredPin: String = ""
    
    @IBOutlet weak var pinTextField: UITextView!
    @IBOutlet weak var showPinButton: UIButton!
    @IBOutlet private var buttons: [UIButton]!
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if isFirstLoad {
            initView()
            isFirstLoad = false
        }
    }
    
    private func initView() {
        buttons.forEach{
            $0.layer.cornerRadius = $0.frame.height / 2
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.white.cgColor
        }
        pinTextField.layer.borderColor = UIColor.white.cgColor
        pinTextField.layer.borderWidth = 1
        pinTextField.delegate = self
        setupPinButton()
        updateTextField()
    }
    
    private func setupPinButton() {
        showPinButton.isEnabled = false
        showPinButton.setImage(UIImage(systemName: "eye"), for: .normal)
        showPinButton.setImage(UIImage(systemName: "eye.slash"), for: .selected)
    }
    
    private func updateTextField(isNewSymbol: Bool = false) {
        if isNewSymbol {
            setTextFieldValue(showLastSymbol: true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.setTextFieldValue()
            }
        } else {
            setTextFieldValue()
        }
    }
    
    private func setTextFieldValue(showLastSymbol: Bool = false) {
        guard enteredPin.count > 0
        else {
            if isFirstLaunch {
                pinTextField.text = "Create PIN"
            } else {
                pinTextField.text = "Enter you PIN"
            }
            return
        }
        if showLastSymbol {
            pinTextField.text = String(Array(repeating: "*", count: enteredPin.count - 1)) + String(enteredPin.last ?? Character(""))
        } else {
            self.pinTextField.text = String(Array(repeating: "*", count: self.enteredPin.count))
        }
    }
    
    private func onDigitClick(digit: String) {
        enteredPin += digit
        updateTextField(isNewSymbol: true)
    }
    
    private func onDeleteClick() {
        if enteredPin.isEmpty == false {
            enteredPin.removeLast()
            updateTextField()
        }
    }
    
    private func onLockClick() {
        if isFirstLaunch {
            StorageService.shared.isFirstLaunch = false
            StorageService.shared.pinCode = enteredPin
            navigateToGallery()
        } else {
            checkPin()
        }
    }
    
    private func navigateToGallery() {
        let imageViewController = ImageViewController()
        self.navigationController?.pushViewController(imageViewController, animated: true)
    }
    
    private func checkPin() {
        if enteredPin == StorageService.shared.pinCode {
            navigateToGallery()
        } else {
            enteredPin = ""
            pinTextField.text = "ERROR!"
            pinTextField.layer.borderColor = UIColor.red.cgColor
            pinTextField.layer.borderWidth = 1
        }
    }
    
    @IBAction func onButtonClick(_ sender: UIButton) {
        let tag = sender.tag
        switch tag {
        case 0: onDigitClick(digit: sender.titleLabel?.text ?? "")
        case 1: onDeleteClick()
        case 2: onLockClick()
        default: return
        }
    }
    
    @IBAction func onShowPinButtonClick(_ sender: UIButton) {
        pinTextField.isSecureTextEntry.toggle()
        showPinButton.isSelected = !pinTextField.isSecureTextEntry
        if !pinTextField.isSecureTextEntry {
            pinTextField.text = enteredPin
        } else {
            setTextFieldValue()
        }
    }
    
    
    @IBAction func onFaceIDButtonClick(_ sender: UIButton) {
        let context = LAContext()
        var error: NSError? = nil
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identity yourself"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
                DispatchQueue.main.async { [weak self] in
                    guard success, error == nil
                    else {
                        self?.enteredPin = ""
                        self?.updateTextField()
                        return
                    }
                    self?.navigateToGallery()
                }
            }
        }
    }
}

extension PinViewController: UITextViewDelegate {
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        showPinButton.isEnabled = pinTextField.text?.count ?? 0 > 0
    }
}

