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

enum UpdateCause { Loading, Products, Error }

class PurchaseCompletedState {
  final List<String> notFoundIds;
  final Map<String, ProductDetails> products;
  final Map<String, PurchaseDetails> purchases;
  final List<String> consumables;
  final bool isAvailable; // = false;
  final bool purchasePending; // = false;
  final bool loading; // = true;
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

  PurchaseCompletedState({
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

  PurchaseCompletedState copyWith(
      {List<String> notFoundIds,
      List<ProductDetails> products,
      List<PurchaseDetails> purchases,
      List<String> consumables,
      bool isAvailable,
      bool purchasePending,
      bool loading,
      String queryProductError,
      UpdateCause updateCause}) {
    return new PurchaseCompletedState(
        notFoundIds: notFoundIds ?? this.notFoundIds,
        products: products ?? this.products,
        purchases: purchases ?? this.purchases,
        consumables: consumables ?? this.consumables,
        isAvailable: isAvailable ?? this.isAvailable,
        purchasePending: purchasePending ?? this.purchasePending,
        loading: loading ?? this.loading,
        queryProductError: queryProductError ?? this.queryProductError,
        updateCause: updateCause ?? this.updateCause);
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
            " acknowledged: " +
            value.billingClientPurchase?.isAcknowledged.toString())
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

  StreamController<PurchaseCompletedState> _purchaseStateStreamController = StreamController.broadcast();
  StreamController<String> _purchaseErrorStreamController = StreamController.broadcast();

  Stream<PurchaseCompletedState> get purchaseStateStream =>
      _purchaseStateStreamController.stream; //.asBroadcastStream();
  Stream<String> get purchaseErrorStream => _purchaseErrorStreamController.stream; //.asBroadcastStream();

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
  /// Из тех, которые указаны в [productIds]
  Future queryProductDetails(Set<String> productIds) async {
    if (!(await _getAvailability())) {
      _emitPurchaseState(_purchaseState.copyWith(isAvailable: false));
      _emitPurchaseMessage("Billing service is unavailable!");
      return;
    }

    ProductDetailsResponse productDetailResponse = await _connection.queryProductDetails(productIds);

    productDetailResponse.productDetails.forEach((ProductDetails pd) {
      _purchaseState.products[pd.id] = pd;
    });

    _emitPurchaseState(_purchaseState);
  }

  /// Проверяются покупки
  /// В [filterIds] передаются идентификаторы покупок, которые нужно проверить
  Future queryPurchases({bool acknowledgePendingPurchases = false}) async {
    if (!(await _getAvailability())) {
      _emitPurchaseState(_purchaseState.copyWith(isAvailable: false));
      _emitPurchaseMessage("Connection error!");
      return;
    }

    /// Unlike [queryPurchaseHistory], This does not make a network request and
    /// does not return items that are no longer owned.
    final QueryPurchaseDetailsResponse purchaseResponse = await _connection.queryPastPurchases();
    if (purchaseResponse.error != null) {
      _emitPurchaseMessage("Query purchases error!");
      return;
    }

    final newState = _purchaseState.copyWith(purchases: purchaseResponse.pastPurchases);

    if (acknowledgePendingPurchases) {
      await Future.forEach(purchaseResponse.pastPurchases, (PurchaseDetails purchasesDetail) async {
        if (purchasesDetail.status == PurchaseStatus.purchased) {
          // Здесь можно проверить receipt или еще какие-то штуки
          if (purchasesDetail.pendingCompletePurchase) {
            await InAppPurchaseConnection.instance.completePurchase(purchasesDetail);
          }
        }
      });
    }

    _emitPurchaseState(newState);
  }

  /// Колбэк отслеживания за изменением состояния покупок
  Future _updatePurchases(List<PurchaseDetails> purchasesDetails, {bool requestStartLoading = true}) async {
    if (!(await _getAvailability())) {
      _emitPurchaseState(_purchaseState.copyWith(isAvailable: false));
      _emitPurchaseMessage("Billing service is unavailable!");
      return;
    }

    await Future.forEach(purchasesDetails, (PurchaseDetails purchasesDetail) async {
      if (purchasesDetail.status == PurchaseStatus.pending) {
        _emitPurchaseMessage("Purchase is pending!");
      } else {
        if (purchasesDetail.status == PurchaseStatus.error) {
          // Ошибка при обновлении статуса покупок
          _emitPurchaseMessage("Error during purchase!");
        } else if (purchasesDetail.status == PurchaseStatus.purchased) {
          bool purchaseConfirmed = false;
          // Здесь можно проверить receipt или еще какие-то штуки
          if (purchasesDetail.pendingCompletePurchase) {
            final completeResult = await InAppPurchaseConnection.instance.completePurchase(purchasesDetail);
            debugPrint("Pending result! $completeResult");

            if (completeResult.responseCode != BillingResponse.ok) {
              debugPrint("Purchase is not acknowledged!");
              _emitPurchaseMessage("Purchase is not acknowledged!");
            } else {
              debugPrint("Purchase is not acknowledged!");
              purchaseConfirmed = true;
            }
          } else {
            purchaseConfirmed = true;
          }

          /*if (purchaseConfirmed) {
            // Занесем покупку в кэш
            await prefs.setBool(purchasesDetail.productID, true);
          }*/

          /*
          При покупке
          I/flutter (19917): Pending result! Instance of 'BillingResultWrapper'
          I/flutter (19917): Pending result is no oK! Instance of 'BillingResultWrapper'
          I/flutter (19917): Purchase is acknowledged!! false and true
          I/flutter (19917): _emitPurchaseState: PurchaseCompletedState{products: {}, purchases: pro_package: PurchaseStatus.purchased pendingCompletePurchase: true acknowledged: false, isAvailable: false, loading: true, queryProductError: null}
          I/flutter (19917): Purchase data in stream builder PurchaseCompletedState{products: {}, purchases: pro_package: PurchaseStatus.purchased pendingCompletePurchase: true acknowledged: false, isAvailable: false, loading: true, queryProductError: null}
           */

          // TODO Здесь isAcknowledged == false, даже если результат прищел true!
          // TODO Но если сделать queryPurchases, то баннер исчезнет!
          //debugPrint(
          //    "Purchase is acknowledged!! ${purchasesDetail.billingClientPurchase.isAcknowledged} and $purchaseConfirmed");
        }
      }

      //_purchaseState.purchases[purchasesDetail.productID] = purchasesDetail; // TODO Не работает!
    });

    await queryPurchases();
  }

  /// Запросить покупку
  /// [sku] - идентификатор покупки
  Future requestPurchase(String sku) async {
    ProductDetailsResponse productDetailResponse = await _connection.queryProductDetails({sku});

    if (productDetailResponse.error != null) {
      _emitPurchaseMessage("Billing service is unavailable!");
      return false;
    }

    final existsProducts = productDetailResponse.productDetails.any((element) => true);
    if (!existsProducts) {
      return false;
    }

    PurchaseParam purchaseParam = PurchaseParam(
        productDetails: productDetailResponse.productDetails
            .where((element) => element.id == sku)
            .first); // applicationUserName: null, sandboxTesting: true);

    _connection.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    await _updatePurchases(purchaseDetailsList);
  }

  _emitPurchaseMessage(String purchaseMessage) {
    debugPrint("Emit Purchase message: $purchaseMessage}");
    _purchaseState = _purchaseState.copyWith(queryProductError: purchaseMessage);
    _purchaseErrorStreamController.sink.add(purchaseMessage);
  }

  _emitPurchaseState(PurchaseCompletedState basePurchaseState) {
    debugPrint("Emit Purchase state: ${basePurchaseState.toString()}");
    _purchaseState = basePurchaseState;
    _purchaseStateStreamController.sink.add(basePurchaseState);
  }

  Future<bool> _getAvailability() async {
    final isAvailability = await _connection.isAvailable();
    return isAvailability;
  }

  dispose() {
    _purchaseStateStreamController?.close();
    _purchaseErrorStreamController?.close();
  }
}