//
//  ViewController.swift
//  PhotoApplication
//
//  Created by Константин Малков on 24.09.2022.
//

import UIKit

class PhotosCollectionViewController: UICollectionViewController, UINavigationBarDelegate, UIGestureRecognizerDelegate{
  
    private var result: [Result] = [] //struct inherit data from api
    private var selectImage = [UIImage]() // variable with array of choosen photos
    private var timer: Timer? //timer for async schedule
    private var imageModels = [CustomCollectionViewCell]()
    
    //sizes for collectionViewLayout
    private let itemRow: CGFloat = 2
    private let sectionInserts = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    private var numberOfSelectedPhotos: Int {
        return collectionView.indexPathsForSelectedItems?.count ?? 0
    }
    //nav button to setupVC
    private lazy var navigationSettingButton: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(systemName: "gear")
                               , style: .plain
                               , target: self
                               , action: #selector(didTapSetting))
    }()
    //nav button refresh the page
    private lazy var navigationUpdateButton: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(systemName: "house")
                               , style: .done
                               , target: self
                               , action: #selector(didTapRefresh))
    }()
    //nav button to share collection of photos
    private lazy var navigationShareButton: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .action
                               , target: self
                               , action: #selector(didTapShare))
    }()
    //setup searchbar
    private let searchBar: UISearchController = {
        let search = UISearchController()
        search.searchBar.backgroundColor = .systemFill
        search.searchBar.placeholder = "Enter your request"
        search.hidesNavigationBarDuringPresentation = false
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.becomeFirstResponder()
        search.automaticallyShowsScopeBar = true
        return search
    }()
    //including all necessary func
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        trendData()
        setupNavigationBar()
        setupCollectionView()
        updateNavigation()
        setupGesture()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
    }
    
    //MARK: - Target methods
    //func for saving images in FavouritesVC
    @objc private func didTapSetting(){
        let vc = UIStoryboard(name: "Main", bundle: nil)
        let view = vc.instantiateViewController(withIdentifier: "SetupViewController") as! SetupViewController
        show(view, sender: nil)
    }
    //target func for refresh page
    @objc private func didTapRefresh(){
        refresh()
        trendData()
        self.title = "Photos"
        self.collectionView.reloadData()
        self.searchBar.searchBar.text = nil
        dismiss(animated: true)
    }
    //func for opening gestured photo
    @objc private func didTapGesture(gesture: UILongPressGestureRecognizer) {
        if gesture.state != .began {
            let p = gesture.location(in: collectionView)
            if let indexPath = collectionView?.indexPathForItem(at: p){
                let cell = collectionView.cellForItem(at: indexPath) as! CustomCollectionViewCell
                guard let image = cell.photoImageView.image else {
                    return
                }
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                guard let secondVC = storyboard.instantiateViewController(withIdentifier: "PushUpViewController") as? PushUpViewController else {
                    return
                }
                secondVC.selectedImage = image
                secondVC.resultFromLastView = result[indexPath.row].urls.full
                DispatchQueue.main.async {
                    secondVC.collectionView.reloadData()
                }
                show(secondVC, sender: nil)
            }
        }
    }
    //func for sharing photo or photos
    @objc private func didTapShare(sender: UIBarButtonItem){
        let shareController = UIActivityViewController(activityItems: selectImage, applicationActivities: nil)
        shareController.completionWithItemsHandler = { _, success, _ , _ in
            if success {
                self.refresh()
            }
        }
        shareController.popoverPresentationController?.barButtonItem = sender
        shareController.popoverPresentationController?.permittedArrowDirections = .any
        present(shareController, animated: true, completion: nil)
    }
    //func for clear view before refreshing
    @objc private func clearView(){
        imageModels.removeAll()
        searchBar.searchBar.text = nil
        trendData()
    }
    //MARK: - Setup methods
    
    private func setupSearchBar(){
        view.addSubview(searchBar.searchBar)
        searchBar.searchBar.delegate = self
    }
    
    
    private func setupGesture() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(didTapGesture(gesture: )))
        gesture.minimumPressDuration = 0.5
        gesture.delegate = self
        gesture.delaysTouchesBegan = true
        collectionView.addGestureRecognizer(gesture)
    }
    
    private func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: CustomCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .systemFill
        collectionView.contentInsetAdjustmentBehavior = .automatic
        collectionView.allowsMultipleSelection = true
    }
    
    private func setupNavigationBar() {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 26, weight: .semibold)
        navigationItem.title = "Photos"
        let apperance = UINavigationBarAppearance()
        apperance.backgroundColor = .systemFill
        navigationItem.standardAppearance = apperance
        navigationItem.scrollEdgeAppearance = apperance
        navigationItem.searchController = searchBar
        navigationController?.navigationBar.backgroundColor = .systemFill
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = navigationUpdateButton
        navigationItem.leftBarButtonItems = [navigationSettingButton ,navigationShareButton]
    }
    
    private func refresh() {
        self.selectImage.removeAll()
        self.collectionView.selectItem(at: nil, animated: true, scrollPosition: [])
        updateNavigation()
    }
    //setup for enable and disable share button
    private func updateNavigation() {
        navigationShareButton.isEnabled = numberOfSelectedPhotos > 0
    }
    
    //MARK: - Trend and Search photos
    //download api data
    private func trendData() {
        let apiKey = "https://api.unsplash.com/search/photos?page=1&per_page=30&query=swift&client_id=JIqBed144ExXZYwfHCmlMSMMbzOj0AAZz2bnEoR8Fk4"
        guard let url = URL(string: apiKey) else {
            return
        }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let jsonResult = try JSONDecoder().decode(APIResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.result = jsonResult.results
                    self?.collectionView.reloadData()
                }
            } catch {
                print("ошибка загрузки фото трендов из API")
            }
        }.resume()
        print("API загружен успешно!")
        
    }
    //download api data by search request
    private func searchData(query: String) {
        let searchWord = "https://api.unsplash.com/search/photos?page=1&per_page=30&query=\(query)&client_id=JIqBed144ExXZYwfHCmlMSMMbzOj0AAZz2bnEoR8Fk4"
        guard let url = URL(string: searchWord) else {
            return
        }
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let jsonResult = try JSONDecoder().decode(APIResponse.self, from: data)
                DispatchQueue.main.async {
                    self?.result = jsonResult.results
                    self?.collectionView.reloadData()
                }
            } catch {
                print("ошибка загрузки фото из API при поиске")
            }
        }.resume()
        print("Выполнение запроса пользоателя - :\(query)")
        
    }
    //MARK: - CollectionView Datasources & Delegates
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return result.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionViewCell.identifier, for: indexPath) as! CustomCollectionViewCell
        if !result.isEmpty {
            let urlString = result[indexPath.row].urls.regular
            cell.configure(with: urlString)
            cell.backgroundColor = randomColor()
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateNavigation()
        let cell = collectionView.cellForItem(at: indexPath) as! CustomCollectionViewCell
        guard let image = cell.photoImageView.image else {
            return
        }
        selectImage.append(image)
        
    }
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        updateNavigation()
        let cell = collectionView.cellForItem(at: indexPath) as! CustomCollectionViewCell
        guard let image = cell.photoImageView.image else {
            return
        }
        if let index = selectImage.firstIndex(of: image) {
            selectImage.remove(at: index)
        }
    }
    
    func random () -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
    
    func randomColor () -> UIColor {
        return UIColor(red: random(), green: random(), blue: random(), alpha: 1.0)
    }
}
    //MARK: - SearchBarDelegates and CollectionView
extension PhotosCollectionViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: { _ in
            searchBar.resignFirstResponder()
            if let text = searchBar.text {
                self.searchData(query: text)
                self.result.removeAll()
                self.result = []
                self.title = "Search page"
                self.collectionView?.reloadData()
                self.refresh()
            }
        })
    }
}
//extension view collection view layouts for images
extension PhotosCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let image = result[indexPath.item]
        let space = sectionInserts.left * (itemRow+1)
        let availableWidth = view.frame.width - space
        let widthPerItem = availableWidth / itemRow
        let height = CGFloat(image.height) * widthPerItem / CGFloat(image.width)
        return CGSize(width: widthPerItem, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
}

