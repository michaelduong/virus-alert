//
//  NewsTableViewController.swift
//  VirusAlert
//
//  Created by Swift Team Six on 4/12/20.
//  Copyright © 2020 Turnt Labs. All rights reserved.
//

import UIKit
import Stevia
import MHWebViewController

final class NewsTableViewController: UITableViewController {
    
    private let cellId = "cellId"
    
    var articles = [NewsArticles]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchNewsArticles()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchNewsArticles()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(hexString: "#f7f9ff")
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.estimatedRowHeight = 240
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(hexString: "#f7f9ff")
    }
    
    private func fetchNewsArticles() {
        WSApi.shared.fetchNewsArticles().then { articles in
            self.articles = articles
        }.onError { e in
            print(e)
        }.finally {
            self.tableView.reloadData()
        }
    }
}

extension NewsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? NewsTableViewCell else { return UITableViewCell() }
        
        let article = articles[indexPath.row]
        cell.render(with: article)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let articleUrl = URL(string: articles[indexPath.row].url) else { return }
        
        present(url: articleUrl)
    }
}

