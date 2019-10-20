//
//  RepositoryListViewController.swift
//  DummyApp
//
//  Created by Vicentiu Petreaca on 20/10/2019.
//  Copyright © 2019 Vicentiu Petreaca. All rights reserved.
//

import UIKit

class RepositoryListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var repositories = [Repository]() {
        
        // setting this observer may come in handy as we don't have to manually reload the table when data arrives
        didSet {
            
            // nicely animating the new data
            tableView.beginUpdates()
            tableView.reloadSections([0], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    var presenter: RepositoryListPresenter!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // before the view appears we'll start fetching our repositories
        presenter.fetchRepositories(limit: 10) { [weak self] repos, error in
            DispatchQueue.main.async {
                
                // when the Promise gets filled, we get the 10 repositories that we'll show on our tableview
                self?.repositories = repos
                
                // also we should stop the spinner from spinning
                self?.activityIndicator.stopAnimating()
            }
        }
    }
}

extension RepositoryListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // just dequeue a RepositoryTableViewcell
        let cell = tableView
            .dequeueReusableCell(withIdentifier: "repositoryCell", for: indexPath) as? RepositoryTableViewCell
        
        // grab the current repository which needs displaying
        let currentRepo = repositories[indexPath.row]
        
        // configure the cell based on the current repo
        cell?.configure(imageUrlString: currentRepo.owner.avatarUrl,
                        title: currentRepo.name + " (\(currentRepo.stars) ★)",
                        description: currentRepo.desc)
        
        // return the configured cell
        return cell ?? UITableViewCell()
    }
}
