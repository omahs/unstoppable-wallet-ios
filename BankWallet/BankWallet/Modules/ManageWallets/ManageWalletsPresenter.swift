class ManageWalletsPresenter {
    weak var view: IManageWalletsView?

    private let router: IManageWalletsRouter
    private let appConfigProvider: IAppConfigProvider
    private let walletManager: IWalletManager
    private let accountCreator: IAccountCreator
    private let stateHandler = ManageWalletsStateHandler()

    private var wallets: [Wallet] = [] {
        didSet {
            coins = stateHandler.remainingCoins(allCoins: appConfigProvider.coins, wallets: wallets)
        }
    }
    private var coins: [Coin] = []

    init(router: IManageWalletsRouter, appConfigProvider: IAppConfigProvider, walletManager: IWalletManager, accountCreator: IAccountCreator) {
        self.router = router
        self.appConfigProvider = appConfigProvider
        self.walletManager = walletManager
        self.accountCreator = accountCreator
    }

}

extension ManageWalletsPresenter: IManageWalletsViewDelegate {

    func viewDidLoad() {
        wallets = walletManager.wallets
    }

    func enableCoin(atIndex index: Int) {
        let coin = coins[index]

        if let wallet = walletManager.wallet(coin: coin) {
            wallets.append(wallet)
            view?.updateUI()
        } else {
            view?.showNoAccount(coin: coin)
        }
    }

    func disableWallet(atIndex index: Int) {
        wallets.remove(at: index)
        view?.updateUI()
    }

    func moveWallet(from fromIndex: Int, to toIndex: Int) {
        wallets.insert(wallets.remove(at: fromIndex), at: toIndex)
        view?.updateUI()
    }

    func saveChanges() {
        walletManager.enable(wallets: wallets)
        router.close()
    }

    var walletsCount: Int {
        return wallets.count
    }

    var coinsCount: Int {
        return coins.count
    }

    func wallet(forIndex index: Int) -> Wallet {
        return wallets[index]
    }

    func coin(forIndex index: Int) -> Coin {
        return coins[index]
    }

    func onClose() {
        router.close()
    }

    func didTapManageKeys() {
        router.showManageKeys()
    }

}
