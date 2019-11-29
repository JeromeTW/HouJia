// TasksVC.swift
// Copyright (c) 2019 Jerome Hsieh. All rights reserved.
// Created by Jerome Hsieh.

import UIKit

struct Task {
  var name: String
}

class TasksVC: BaseViewController, Storyboarded, HasJeromeNavigationBar {
  @IBOutlet var topView: UIView!
  @IBOutlet var statusView: UIView!
  @IBOutlet var navagationView: UIView!
  @IBOutlet var statusViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet var navagationViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet var titleLabel: UILabel! {
    didSet {
    }
  }

  @IBOutlet var tableView: UITableView! {
    didSet {
      tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
      tableView.contentInsetAdjustmentBehavior = .never
      tableView.estimatedRowHeight = orderRowHeight
      tableView.showFooterIndicator()
    }
  }

  private let orderRowHeight = 200.f

  @IBOutlet var searchBar: UISearchBar!
  private var isOnSearching: Bool {
    return searchBar.isFirstResponder == true && searchBar.text != ""
  }

  var observer: NSObjectProtocol?
  private let coreDataConnect = CoreDataConnect()

  private var array: [Task] = [Task(name: "Task No.1")] {
    didSet {
      tableView.reloadData()
    }
  }

  private var filterArray: [Task] = [Task]() {
    didSet {
      tableView.reloadData()
    }
  }

  private var displayedArray: [Task] {
    if isOnSearching {
      return filterArray
    } else {
      return array
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    hideKeyboardWhenTappedAround()
    setupSearchTextField()
  }

  private var isFirst = true
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    guard isFirst else {
      return
    }
    isFirst = false
    setupSearchTextField()
  }

  private func setupSearchTextField() {
    /*
    // IMPORTANT 關掉了預設添加有的沒有的東西，設定 minimal 後 backgroundColor 屬性才有用。同時也刪除了頂端的線條。
    searchBar.searchBarStyle = .minimal
    searchBar.tintColor = R.color.c9White() // 輸入框光標的顏色
    searchBar.backgroundColor = R.color.c1PrimaryBlue()
    searchBar.barTintColor = .red // 輸入框外面的背景顏色
    let searchTextField = searchBar.searchTextField
    searchTextField.borderStyle = .roundedRect
    searchTextField.backgroundColor = R.color.c1PrimaryBlue()
    searchTextField.background = UIImage()
    searchTextField.placeholder = R.string.localizable.enter_ticket_number_to_search()
    searchTextField.layer.cornerRadius = 17
    // clipsToBounds == ture 時 layer.cornerRadius 的設定才有用
    searchTextField.clipsToBounds = true
    searchTextField.textColor = R.color.c9White()
    searchTextField.font = UIFont.systemFont(ofSize: 19, weight: .regular)
    let imageView = UIImageView(image: R.image.ic_search())
    searchTextField.leftView = imageView
    searchTextField.rightViewMode = UITextField.ViewMode.unlessEditing
    // delegate
    searchBar.delegate = self
 */
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tabBarController?.tabBar.isHidden = false
  }
}

// MARK: - UITableViewDataSource

extension TasksVC: UITableViewDataSource {
  func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
    return displayedArray.count
  }

  func tableView(_: UITableView, cellForRowAt _: IndexPath) -> UITableViewCell {
    return UITableViewCell()
//    let cell = (tableView.dequeueReusableCell(withIdentifier: RegistrationRecordsCell.className, for: indexPath) as? RegistrationRecordsCell)!
//    let record = displayedRecordArray[indexPath.row]
//    cell.updateUI(by: record)
//    return cell
  }
}

// MARK: - UITableViewDelegate

extension TasksVC: UITableViewDelegate {
  func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
    return orderRowHeight
  }

  func tableView(_: UITableView, didSelectRowAt _: IndexPath) {
    // TODO: 設計稿還沒出來。
  }

  func tableView(_ tableView: UITableView, willDisplay _: UITableViewCell, forRowAt indexPath: IndexPath) {
    let lastSectionIndex = tableView.numberOfSections - 1
    let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
    if indexPath.section == lastSectionIndex, indexPath.row == lastRowIndex {
      // TODO: Grab new data
      // TODO: did grab data then dimiss spinner
    }
  }
}

// MARK: - UISearchBarDelegate

extension TasksVC: UISearchBarDelegate {
  func searchBarShouldBeginEditing(_: UISearchBar) -> Bool {
    logC("searchBarShouldBeginEditing")
    return true
  }

  func searchBarShouldEndEditing(_: UISearchBar) -> Bool {
    logC("searchBarShouldEndEditing")
    return true
  }

  func searchBarCancelButtonClicked(_: UISearchBar) {
    logC("searchBarCancelButtonClicked")
  }

  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    logC("searchBartextDidChange")
    /*
    let searchTextField = searchBar.searchTextField
    if isOnSearching {
      let imageView = UIImageView(image: R.image.ic_search_active())
      searchTextField.leftView = imageView
    } else {
      let imageView = UIImageView(image: R.image.ic_search())
      searchTextField.leftView = imageView
    }
    guard let searchText = searchBar.text else {
      return
    }*/

    logC("搜尋符合文字# \(searchText) #的檔案")
    // Update the filtered array based on the search text.
    filterArray = array.filter { task -> Bool in
      let lowercasedSearchText = searchText.lowercased()
      return task.name.lowercased().contains(lowercasedSearchText)
    }
    tableView.reloadData()
  }
}
