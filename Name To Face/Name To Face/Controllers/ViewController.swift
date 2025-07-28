//
//  ViewController.swift
//  Name To Face
//
//  Created by Dip on 22/7/25.
//

import UIKit

class ViewController: UICollectionViewController {
    
    // MARK: - Properties
    
    var people: [Person] = []
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Name To Face"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        
    }
}

// MARK: - Create Extension Of ViewController

extension ViewController:UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    // MARK: -  This Section For Data Source.
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "person", for: indexPath) as! PersonCollectionViewCell
        let people = people[indexPath.item]
        cell.textView.text = people.name
        let path = Directory.getDocumentsDirectory().appendingPathComponent(people.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        return cell
    }
    
    // MARK: - This section for colledtionView Delegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let people = people[indexPath.item]
        let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
        ac.addTextField { textField in
            textField.placeholder = "Enter a new name "
        }
        
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else { return }
            people.name = newName
            self?.collectionView.reloadData()
        })
        present(ac, animated: true)
    }
    
    
    // MARK: - Create addNewPerson method to get images from iphone camera.
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true // allow seleted picture to crop
        picker.delegate = self
        present(picker, animated: true)
    }
    
    // MARK: - Crete imagePicker Controll method for seleted Image
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return } // try to get the edited image.
        let imageName = UUID().uuidString // try create unique id for each image so
        let imagePath =  Directory.getDocumentsDirectory().appendingPathComponent(imageName) // Appends the unique image name to that path — this is where the image will be saved.
        if let jepeg = image.jpegData(compressionQuality: 0.8) {
            try? jepeg.write(to: imagePath)
        }
        let person = Person(name: "unknown", image: imageName)
        people.append(person)
        savaData()
        collectionView.reloadData()
        dismiss(animated: true) // dismiss the picker.
    }
     // MARK: -  Create savaData method for save customData.
   func savaData() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(people) {
            UserDefaults.standard.set(data, forKey: "people")
        }
    }
    // MARK: -  Create loadData method for show customData.
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "people") {
            let decoder = JSONDecoder()
            if let loadedPeople = try? decoder.decode([Person].self, from: data) {
                people = loadedPeople
            }
        }
    }
    
}

