//
//  LocationSettingViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/01/05.
//

import MapKit
import UIKit

import RxCocoa
import RxSwift
import YDS

final class LocationSettingViewController: BaseViewController {
    private let contentView: LocationSettingView = .init()

    private var searchCompleter = MKLocalSearchCompleter()
    private var searchRegion: MKCoordinateRegion = .init(MKMapRect.world)
    private var searchResults = [MKLocalSearchCompletion]() {
        didSet {
            contentView.tableView.reloadData()
        }
    }

    private var places: MKMapItem? {
        didSet {
            contentView.tableView.reloadData()
        }
    }

    private var localSearch: MKLocalSearch? {
        willSet {
            places = nil
            localSearch?.cancel()
        }
    }

    private let from: From

    enum From {
        case onboarding
        case `default`
    }

    override func loadView() {
        view = contentView
    }

    init(from: From) {
        self.from = from
        super.init()
        title = "위치 설정"
        bindTextField()
        setTableView()
        setSearchCompleter()
        hideKeyboardWhenTappedAround()
    }

    private func bindTextField() {
        contentView.searchTextField.rx.text
            .compactMap { $0 }
            .withUnretained(self)
            .subscribe(onNext: { owner, text in
                if text.isEmpty {
                    owner.searchResults.removeAll()
                }
                owner.searchCompleter.queryFragment = text
            })
            .disposed(by: disposeBag)
    }

    private func setTableView() {
        contentView.tableView.rowHeight = 52
        contentView.tableView.dataSource = self
        contentView.tableView.delegate = self
    }

    private func setSearchCompleter() {
        searchCompleter.delegate = self
        searchCompleter.resultTypes = .address
        searchCompleter.region = searchRegion
    }
}

extension LocationSettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedResult = searchResults[indexPath.row]
        let searchRequest = MKLocalSearch.Request(completion: selectedResult)
        let search = MKLocalSearch(request: searchRequest)

        search.start { [weak self] response, error in
            guard
                let self = self,
                error == nil
            else {
                return
            }
            guard let placemark = response?.mapItems[0].placemark else { return }
            var address = ""
            if let locality = placemark.locality {
                address += locality
            }
            if let name = placemark.name {
                address += " "
                address += name
            }
            self.navigationController?.pushViewController(
                self.factory.makeConfirmLocationViewController(
                    locality: address,
                    latitude: placemark.coordinate.latitude,
                    longitude: placemark.coordinate.longitude,
                    from: self.from
                ),
                animated: true
            )
        }
    }
}

extension LocationSettingViewController: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
    }

    func completer(
        _ completer: MKLocalSearchCompleter,
        didFailWithError error: Error
    ) {
        guard let error = error as NSError? else { return }
        print("MKLocalSearchCompleter encountered an error: \(error.localizedDescription). The query fragment is: \"\(completer.queryFragment)\"")
    }
}

extension LocationSettingViewController: UITableViewDataSource {
    func tableView(
        _: UITableView,
        numberOfRowsInSection _: Int
    ) -> Int {
        return searchResults.count
    }

    func tableView(
        _: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = UITableViewCell()
        let searchResult = searchResults[indexPath.row]

        cell.textLabel?.font = YDSFont.body2
        cell.textLabel?.textColor = YDSColor.textSecondary
        cell.backgroundColor = .clear
        cell.textLabel?.text = searchResult.title
        cell.selectedBackgroundView = UIView().then { $0.backgroundColor = YDSColor.bgPressed }
        cell.separatorInset = .init(top: 0, left: 12, bottom: 0, right: 12)

        return cell
    }
}
