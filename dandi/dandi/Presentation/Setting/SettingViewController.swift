//
//  SettingViewController.swift
//  dandi
//
//  Created by 김윤서 on 2023/04/12.
//

import UIKit

import MessageUI
import RxSwift
import SafariServices
import SnapKit
import YDS

final class SettingViewController: BaseViewController {
    override var hidesBottomBarWhenPushed: Bool {
        get { navigationController?.topViewController == self }
        set { super.hidesBottomBarWhenPushed = newValue }
    }

    private let tableView = UITableView()

    enum Section: CaseIterable {
        case info
        case docs
        case auth

        init(rawValue: Int) {
            switch rawValue {
            case 0: self = .info
            case 1: self = .docs
            case 2: self = .auth
            default:
                fatalError("유효하지 않은 section 값")
            }
        }
    }

    enum InfoItem: String, CaseIterable {
        case location = "지역 변경"
        case appVersion = "앱 버전"
        case team = "DANDI를 만든 사람들"

        init(rawValue: Int) {
            switch rawValue {
            case 0: self = .location
            case 1: self = .appVersion
            case 2: self = .team
            default:
                fatalError("유효하지 않은 item 값")
            }
        }
    }

    enum DocsItem: String, CaseIterable {
        case policy = "개인정보 처리방침"
        case term = "서비스 이용약관"
        case eula = "EULA"
        case contact = "문의하기"

        init(rawValue: Int) {
            switch rawValue {
            case 0: self = .policy
            case 1: self = .term
            case 2: self = .eula
            case 3: self = .contact
            default:
                fatalError("유효하지 않은 item 값")
            }
        }
    }

    enum AuthItem: String, CaseIterable {
        case logout = "로그아웃"
        case withdraw = "탈퇴하기"

        init(rawValue: Int) {
            switch rawValue {
            case 0: self = .logout
            case 1: self = .withdraw
            default:
                fatalError("유효하지 않은 item 값")
            }
        }
    }

    override init() {
        super.init()
        setDelegation()
        setProperties()
        setLayouts()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setProperties() {
        tableView.register(cell: SettingTableViewCell.self)
        tableView.separatorStyle = .none

        view.backgroundColor = .white
    }

    private func setDelegation() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func setLayouts() {
        view.addSubviews(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.bottom.trailing.equalToSuperview()
        }
    }
}

extension SettingViewController: UITableViewDelegate {
    // swiftlint:disable cyclomatic_complexity
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch Section(rawValue: indexPath.section) {
        case .info:
            switch InfoItem(rawValue: indexPath.item) {
            case .location:
                let vc = factory.makeLocationSettingViewController(from: .default)
                present(YDSNavigationController(rootViewController: vc), animated: true)
            case .team:
                navigationController?.pushViewController(UIViewController(), animated: true)
            default:
                break
            }
        case .docs:
            switch DocsItem(rawValue: indexPath.item) {
            case .policy:
                guard
                    let encodingScheme = URLConstant.policy.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                    let url = URL(string: encodingScheme.trimmingSpace()), UIApplication.shared.canOpenURL(url)
                else { return }
                let safariViewController = SFSafariViewController(url: url)
                present(safariViewController, animated: true)

            case .eula:
                guard
                    let encodingScheme = URLConstant.eula.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                    let url = URL(string: encodingScheme.trimmingSpace()), UIApplication.shared.canOpenURL(url)
                else { return }
                let safariViewController = SFSafariViewController(url: url)
                present(safariViewController, animated: true)

            case .term:
                guard
                    let encodingScheme = URLConstant.term.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                    let url = URL(string: encodingScheme.trimmingSpace()), UIApplication.shared.canOpenURL(url)
                else { return }

                let safariViewController = SFSafariViewController(url: url)
                present(safariViewController, animated: true)

            case .contact:
                guard
                    MFMailComposeViewController.canSendMail()
                else {
                    return
                }

                let compseVC = MFMailComposeViewController()
                compseVC.mailComposeDelegate = self
                compseVC.setToRecipients(["ezidayzi@gmail.com"])
                present(compseVC, animated: true, completion: nil)
            }
        case .auth:
            switch AuthItem(rawValue: indexPath.item) {
            case .logout:
                let actions: [LogoutAlertType] = [.logout]
                rx.makeAlert(
                    title: "정말로 로그아웃 하시겠어요?",
                    message: "로그아웃 하게 되면 Dandi에서 내 기록들을 확인할 수 없어요. 돌아오실거죠?",
                    actions: actions,
                    closeAction: LogoutAlertType.cancel
                )

                //                .flatMap { _ in NetworkService.shared.user.withdraw() }
                //                .filter { $0.statusCase == .okay }
                .bind { _ in
                    UserDefaultHandler.shared.removeAll()
                    RootSwitcher.update(.splash)
                }
                .disposed(by: disposeBag)

            case .withdraw:
                let actions: [WithdrawAlertType] = [.withdraw]
                rx.makeAlert(
                    title: "정말로 탈퇴 하시겠어요?",
                    message: "탈퇴하게 되면 내 옷 기록들을 영원히 다시 볼 수 없어요. 신중히 선택해주세요.",
                    actions: actions,
                    closeAction: WithdrawAlertType.cancel
                )

                //                .flatMap { _ in NetworkService.shared.user.withdraw() }
                //                .filter { $0.statusCase == .okay }
                .bind { _ in
                    UserDefaultHandler.shared.removeAll()
                    RootSwitcher.update(.splash)
                }
                .disposed(by: disposeBag)
            }
        }
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 55
    }

    func tableView(_: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if Section(rawValue: section) == .auth {
            return nil
        }
        let footer = UIView()
        let seperator = UIView()
        seperator.backgroundColor = YDSColor.borderNormal
        footer.addSubview(seperator)
        seperator.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        return footer
    }

    func tableView(_: UITableView, heightForFooterInSection _: Int) -> CGFloat {
        return 1
    }
}

extension SettingViewController: UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return Section.allCases.count
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .info:
            return InfoItem.allCases.count
        case .docs:
            return DocsItem.allCases.count
        case .auth:
            return AuthItem.allCases.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SettingTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        var text = ""
        switch Section(rawValue: indexPath.section) {
        case .info:
            text = InfoItem(rawValue: indexPath.item).rawValue
        case .docs:
            text = DocsItem(rawValue: indexPath.item).rawValue
        case .auth:
            text = AuthItem(rawValue: indexPath.item).rawValue
        }

        guard
            Section(rawValue: indexPath.section) == .info,
            InfoItem(rawValue: indexPath.item) == .appVersion
        else {
            if Section(rawValue: indexPath.section) == .info,
               InfoItem(rawValue: indexPath.item) == .team
            {
                cell.configure(text: text)
                return cell
            }
            cell.configure(text: text)
            return cell
        }

        let label = UILabel()
        label.text = Bundle.appVersion
        label.textColor = YDSColor.textSecondary
        label.font = .systemFont(ofSize: 14)
        cell.configure(text: text, rightItem: label)
        return cell
    }
}

extension SettingViewController: MFMailComposeViewControllerDelegate {}
