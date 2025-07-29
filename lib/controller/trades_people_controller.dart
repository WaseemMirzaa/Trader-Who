import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:traderwho/models/models.dart';

class TradesPeopleController extends GetxController {
  static const int pageSize = 20;
  RxList<TradesPerson> tradesPeople = <TradesPerson>[].obs;
  RxBool isLoading = true.obs;
  RxBool isLoadingMore = false.obs;
  DocumentSnapshot? lastDoc;
  bool hasMore = true;

  @override
  void onInit() {
    super.onInit();
    fetchTradesPeople();
  }

  Future<void> fetchTradesPeople() async {
    isLoading.value = true;
    try {
      final query =
          await FirebaseFirestore.instance
              .collection('users')
              .where('user_type', isEqualTo: 'tradesperson')
              .orderBy('name')
              .limit(pageSize)
              .get();
      final List<TradesPerson> loaded =
          query.docs
              .map((doc) => TradesPerson.fromDocumentSnapshot(doc))
              .toList();
      tradesPeople.value = loaded;
      if (query.docs.isNotEmpty) {
        lastDoc = query.docs.last;
      }
      hasMore = query.docs.length == pageSize;
    } catch (e) {
      tradesPeople.value = [];
    }
    isLoading.value = false;
  }

  Future<void> fetchMoreTradesPeople() async {
    if (!hasMore || isLoadingMore.value) return;
    isLoadingMore.value = true;
    try {
      Query queryRef = FirebaseFirestore.instance
          .collection('users')
          .where('user_type', isEqualTo: 'tradesperson')
          .orderBy('name')
          .limit(pageSize);
      if (lastDoc != null) {
        queryRef = queryRef.startAfterDocument(lastDoc!);
      }
      final query = await queryRef.get();
      final List<TradesPerson> loaded =
          query.docs
              .map((doc) => TradesPerson.fromDocumentSnapshot(doc))
              .toList();
      if (query.docs.isNotEmpty) {
        lastDoc = query.docs.last;
        tradesPeople.addAll(loaded);
      }
      hasMore = query.docs.length == pageSize;
    } catch (e) {
      // ignore
    }
    isLoadingMore.value = false;
  }

  @override
  void onClose() {
    tradesPeople.clear();
    super.onClose();
  }
}
