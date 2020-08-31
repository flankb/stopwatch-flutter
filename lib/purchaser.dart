import 'dart:async';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

// TODO https://stackoverflow.com/questions/63098352/flutter-in-app-purchase-what-should-i-include-in-verifypurchase

class InheritedPurchaserBlocProvider extends InheritedWidget {
  final Widget child;
  final PurchaserBloc bloc;

  InheritedPurchaserBlocProvider({Key key, @required this.child, @required this.bloc}) : super(key: key, child: child);

  static PurchaserBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedPurchaserBlocProvider>().bloc;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}

abstract class Bloc {
  void dispose();
}

enum UpdateCause {
  Loading,
  Products,
  Error
}

class PurchaseCompletedState  {
  final List<String> notFoundIds;
  final Map<String, ProductDetails> products;
  final Map<String, PurchaseDetails> purchases;
  final List<String> consumables;
  final bool isAvailable; // = false;
  final bool purchasePending; // = false;
  final bool loading;// = true;
  final UpdateCause updateCause;

  @deprecated
  String queryProductError;

  factory PurchaseCompletedState.empty() {
    return PurchaseCompletedState(
        notFoundIds: [],
        products: {},
        purchases: {},
        consumables: [],
        isAvailable: false,
        purchasePending: false,
        loading: true,
        queryProductError: null,
        updateCause: UpdateCause.Loading);
  }

  PurchaseCompletedState( {
    @required this.notFoundIds,
    @required this.products,
    @required this.purchases,
    @required this.consumables,
    @required this.isAvailable,
    @required this.purchasePending,
    @required this.loading,
    @required this.queryProductError,
    @required this.updateCause,
  });

  PurchaseCompletedState copyWith({
    List<String> notFoundIds,
    List<ProductDetails> products,
    List<PurchaseDetails> purchases,
    List<String> consumables,
    bool isAvailable,
    bool purchasePending,
    bool loading,
    String queryProductError,
    UpdateCause updateCause
  }) {
    return new PurchaseCompletedState(
      notFoundIds: notFoundIds ?? this.notFoundIds,
      products: products ?? this.products,
      purchases: purchases ?? this.purchases,
      consumables: consumables ?? this.consumables,
      isAvailable: isAvailable ?? this.isAvailable,
      purchasePending: purchasePending ?? this.purchasePending,
      loading: loading ?? this.loading,
      queryProductError: queryProductError ?? this.queryProductError,
      updateCause: updateCause ?? this.updateCause
    );
  }

  bool skuIsAcknowledged(String sku) {
    if (!purchases.containsKey(sku)) {
      return false;
    }

    final pd = purchases[sku];

    if (Platform.isAndroid) {
      return (pd.status == PurchaseStatus.purchased && pd.billingClientPurchase.isAcknowledged);
    }

    return (pd.status == PurchaseStatus.purchased);
  }

  @override
  String toString() {
    final purchasesStr = purchases.values
        .map((value) =>
            value.productID.toString() +
            ": " +
            value.status.toString() +
            " pendingCompletePurchase: " +
            value.pendingCompletePurchase.toString() +
            " acknowledged: " + value.billingClientPurchase?.isAcknowledged.toString())
        .join("\n ");

    return 'PurchaseCompletedState{products: $products, '
        'purchases: $purchasesStr, isAvailable: $isAvailable, loading: $loading,'
        ' queryProductError: $queryProductError}';
  }
}

class PurchaserBloc implements Bloc {
  InAppPurchaseConnection _connection; // = InAppPurchaseConnection.instance;
  StreamSubscription<List<PurchaseDetails>> _subscription;

  PurchaseCompletedState _purchaseState;
  PurchaseCompletedState get purchaseState => _purchaseState;

  StreamController<PurchaseCompletedState> purchaseStateStreamController = StreamController();
  StreamController<String> purchaseErrorStreamController = StreamController();

  PurchaserBloc() {
    _purchaseState = PurchaseCompletedState.empty();
  }

  enablePendingPurchases() {
    InAppPurchaseConnection.enablePendingPurchases();
  }

  enableConnection() {
    _connection = InAppPurchaseConnection.instance;
  }

  listenPurchaseUpdates() {
    Stream purchaseUpdated = InAppPurchaseConnection.instance.purchaseUpdatedStream;
    _subscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription?.cancel();
    }, onError: (error) {
      // handle error here.
    });
  }

  /// Выдать список доступных продуктов
  /// Из тех, которые указаны в [skus]
  Future queryProductDetails(Set<String> skus) async {
    if (!(await _getAvailability())) {
      _emitPurchaseState(_purchaseState.copyWith(isAvailable: false));
      _emitError("Billing service is unavailable!");
      return;
    }

    ProductDetailsResponse productDetailResponse = await _connection.queryProductDetails(skus);

    productDetailResponse.productDetails.forEach((ProductDetails pd) {
      _purchaseState.products[pd.id] = pd;
    });

    _emitPurchaseState(_purchaseState);
  }

  /// Проверяются покупки
  /// В [filterIds] передаются идентификаторы покупок, которые нужно проверить
  Future queryPurchases({Set<String> filterIds}) async {
    if (!(await _getAvailability())) {
      _emitPurchaseState(_purchaseState.copyWith(isAvailable: false));
      return;
    }

    /// Unlike [queryPurchaseHistory], This does not make a network request and
    /// does not return items that are no longer owned.
    final QueryPurchaseDetailsResponse purchaseResponse = await _connection.queryPastPurchases();
    if (purchaseResponse.error != null) {
      _emitError("Connection error!");
      return;
    }

    if (filterIds != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // В этом же методе можно выявлять возвращенные покупки, т.е. делать запрос на список всех покупок и выявлять такие покупки
      await Future.forEach(filterIds, (String element) async {
        final cached = prefs.getBool(element) ?? false;

        // Удалим закэшированную покупку, если она исчезла из кэша BillingApi
        if (cached && !purchaseResponse.pastPurchases.map((PurchaseDetails pd) => pd.productID).contains(element)) {
          await prefs.setBool(element, false);
        }
      });
    }

    await _querySelectedPurchases(purchaseResponse.pastPurchases, requestStartLoading: false);
  }

  /// Когда нужно проверить только несколько покупок
  Future _querySelectedPurchases(List<PurchaseDetails> purchasesDetails, {bool requestStartLoading = true}) async {
    if (!(await _getAvailability())) {
      _emitPurchaseState(_purchaseState.copyWith(isAvailable: false));
      _emitError("Billing service is unavailable!");
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();

    await Future.forEach(purchasesDetails, (PurchaseDetails purchasesDetail) async {
      if (purchasesDetail.status == PurchaseStatus.pending) {
        // Информируем потребителя о том, что покупка отложена
        _emitError("Purchase is pending!");
      } else {
        if (purchasesDetail.status == PurchaseStatus.error) {
          // Ошибка при обновлении статуса покупок
          _emitError("Error during purchase!");
        } else if (purchasesDetail.status == PurchaseStatus.purchased) {
          bool purchaseConfirmed = false;
          // Здесь можно проверить receipt или еще какие-то штуки
          if (purchasesDetail.pendingCompletePurchase) {
            final completeResult = await InAppPurchaseConnection.instance.completePurchase(purchasesDetail);

            if (completeResult.responseCode != BillingResponse.ok) {
              _emitError("Purchase is not acknowledged!");
            } else {
              purchaseConfirmed = true;
            }
          } else {
            purchaseConfirmed = true;
          }

          if (purchaseConfirmed) {
            // Занесем покупку в кэш
            await prefs.setBool(purchasesDetail.productID, true);
          }
        }
      }

      _purchaseState.purchases[purchasesDetail.productID] = purchasesDetail;
    });

    _emitPurchaseState(_purchaseState);
  }

  /// Запросить покупку
  /// [sku] - идентификатор покупки
  Future requestPurchase(String sku) async {
    ProductDetailsResponse productDetailResponse = await _connection.queryProductDetails({sku});

    if (productDetailResponse.error != null) {
      _emitError("Billing service is unavailable!");
      return false;
    }

    PurchaseParam purchaseParam = PurchaseParam(
        productDetails: productDetailResponse.productDetails
            .where((element) => element.id == sku)
            .first); // applicationUserName: null, sandboxTesting: true);

    _connection.buyNonConsumable(purchaseParam: purchaseParam);
  }

  /// Проверить покупки из кэша
  /// [sku] - идентификатор покупки, [thenCheckFromStore] - запустить проверку с помощью сервиса Google Play
  @Deprecated('По-хорошему избавиться от этого метода (т.к. кэш дублирует функциионал Google Play Api)')
  Future<bool> queryPurchasesFromCache(String sku, {bool thenCheckFromStore = false}) async {
    // Проверяем кэш
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool purchased = prefs.getBool(sku) ?? false;

    if (thenCheckFromStore) {
      queryPurchases();
    }

    return purchased;
  }

  Future _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    await _querySelectedPurchases(purchaseDetailsList);
  }

  _emitError(String error) {
    _purchaseState = _purchaseState.copyWith(queryProductError: error);
    purchaseErrorStreamController.add(error);
  }

  _emitPurchaseState(PurchaseCompletedState basePurchaseState, {bool errorEmit = false}) {
    _purchaseState = basePurchaseState;

    debugPrint("_emitPurchaseState: ${basePurchaseState.toString()}");
    purchaseStateStreamController.sink.add(basePurchaseState);
  }

  Future<bool> _getAvailability() async {
    final isAvailability = await _connection.isAvailable();
    return isAvailability;
  }

  dispose() {
    purchaseStateStreamController?.close();
    purchaseErrorStreamController?.close();
  }
}