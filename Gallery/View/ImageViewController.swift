import UIKit
import Alamofire
import Combine

class ImageViewController: UIViewController {

    private var viewModel = ImageViewModel.shared
    private var bindings = Set<AnyCancellable>()
    private var images = [UIImage]() {
        didSet{
            imageCollectionView.reloadData()
        }
    }
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.$photos
            .assign(to: \.images, on: self)
            .store(in: &bindings)
    }
    
    private func setupCollectionView() {
        imageCollectionView.register(ImageCollectionViewCell.nib(), forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
    }
    
    private func showPicker(withSourceType sourceType: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = false
        pickerController.mediaTypes = ["public.image"]
        pickerController.sourceType = sourceType
        present(pickerController, animated: true)
    }
    
    private func setImage(_ image: UIImage, withName name: String? = nil) {
        let fileName = name ?? UUID().uuidString
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let fileURL = URL(fileURLWithPath: fileName, relativeTo: directoryURL).appendingPathExtension("png")
        guard let data = image.pngData() else { return }
        try? data.write(to: fileURL)
        StorageService.shared.images.append(fileName)
        images.append(image)
    }
    
    private func showDialogWithInput() {
        let alert = UIAlertController(title: "DOWNLOAD IMAGE", message: "Enter a uri", preferredStyle: .alert)

        alert.addTextField()

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let uri = alert?.textFields?[0].text as? String ?? ""
            self.viewModel.downloadImage(by: uri)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addImage(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.showPicker(withSourceType: .camera)
        }
        let libraryAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
            self.showPicker(withSourceType: .photoLibrary)
        }
        let uriAction = UIAlertAction(title: "Url", style: .default) { _ in
            self.showDialogWithInput()
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(cameraAction)
        }
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            alert.addAction(libraryAction)
        }
        alert.addAction(uriAction)

        present(alert, animated: true)
    }
}

// TODO center cell
extension ImageViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { images.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = indexPath.row
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell
        else { return UICollectionViewCell() }
        
        cell.setup(with: images[index])
        return cell
    }
}

extension ImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        var name: String?
        if let imageName = info[.imageURL] as? URL {
            name = imageName.lastPathComponent
        }
        setImage(image, withName: name)
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
