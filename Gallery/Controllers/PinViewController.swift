import UIKit

class PinViewController: UIViewController {
    
    private var isFirstLoad: Bool = true
    private let isFirstLaunch = StorageService.shared.isFirstLaunch
    
    @IBOutlet weak var pinTextField: UITextField!
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
        if isFirstLaunch {
            pinTextField.placeholder = "Create PIN"
        } else {
            pinTextField.placeholder = "Enter you PIN"
        }
    }
    
    @IBAction private func onBtnClick(_ sender: UIButton) {
        let tag = sender.tag
        switch tag {
        case 0: onDigitClick(digit: sender.titleLabel?.text ?? "")
        case 1: onDeleteClick()
        case 2: onLockClick()
        default: return
        }
    }
    
    private func onDigitClick(digit: String) {
        pinTextField.text = (pinTextField.text ?? "") + digit
    }
    
    private func onDeleteClick() {
        var text: String = pinTextField.text ?? ""
        if text.isEmpty == false {
            text.removeLast()
            pinTextField.text = text
        }
    }
    
    private func onLockClick() {
        if isFirstLaunch {
            StorageService.shared.isFirstLaunch = false
            StorageService.shared.pinCode = pinTextField.text ?? ""
            navigateToGallery()
        } else {
            checkPin()
        }
    }
    
    private func navigateToGallery() {
        let galleryViewController = GalleryViewController()
        self.navigationController?.pushViewController(galleryViewController, animated: true)
    }
    
    private func checkPin() {
        if pinTextField.text == StorageService.shared.pinCode {
            navigateToGallery()
        } else {
            pinTextField.text = ""
            pinTextField.layer.borderColor = UIColor.red.cgColor
            pinTextField.layer.borderWidth = 1
        }
    }
}

