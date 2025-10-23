import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:traderwho/models/chat_model.dart';
import 'package:traderwho/models/message_model.dart';
import 'package:traderwho/models/user_model.dart';

class ChatController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // List of chats for the current user
  RxList<ChatModel> chats = <ChatModel>[].obs;

  // List of messages for the selected chat
  RxList<MessageModel> messages = <MessageModel>[].obs;

  static const int chatPageSize = 20;
  static const int messagePageSize = 30;
  DocumentSnapshot? lastChatDoc;
  DocumentSnapshot? lastMessageDoc;
  StreamSubscription? chatSubscription;
  StreamSubscription? messageSubscription;

  // Live paginated chat fetch
  void listenToChats(String userId, {bool reset = false}) {
    chatSubscription?.cancel();
    if (reset) {
      chats.clear();
      lastChatDoc = null;
    }
    Query query = _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .limit(chatPageSize);
    if (lastChatDoc != null) {
      query = query.startAfterDocument(lastChatDoc!);
    }
    chatSubscription = query.snapshots().listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        lastChatDoc = snapshot.docs.last;
        final newChats =
            snapshot.docs
                .map(
                  (doc) => ChatModel.fromMap(
                    doc.data() as Map<String, dynamic>,
                    doc.id,
                  ),
                )
                .toList();
        if (reset) {
          chats.value = newChats;
        } else {
          chats.addAll(newChats);
        }
      }
    });
  }

  // Fetch next page of chats
  Future<void> fetchMoreChats(String userId) async {
    Query query = _firestore
        .collection('chats')
        .where('participants', arrayContains: userId)
        .orderBy('lastMessageTime', descending: true)
        .limit(chatPageSize);
    if (lastChatDoc != null) {
      query = query.startAfterDocument(lastChatDoc!);
    }
    final snapshot = await query.get();
    if (snapshot.docs.isNotEmpty) {
      lastChatDoc = snapshot.docs.last;
      final newChats =
          snapshot.docs
              .map(
                (doc) => ChatModel.fromMap(
                  doc.data() as Map<String, dynamic>,
                  doc.id,
                ),
              )
              .toList();
      chats.addAll(newChats);
    }
  }

  // Live paginated messages fetch
  void listenToMessages(String chatId, {bool reset = false}) {
    messageSubscription?.cancel();
    if (reset) {
      messages.clear();
      lastMessageDoc = null;
    }
    Query query = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('sentAt', descending: true)
        .limit(messagePageSize);
    if (lastMessageDoc != null) {
      query = query.startAfterDocument(lastMessageDoc!);
    }
    messageSubscription = query.snapshots().listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        lastMessageDoc = snapshot.docs.last;
        final newMessages =
            snapshot.docs
                .map(
                  (doc) => MessageModel.fromMap(
                    doc.data() as Map<String, dynamic>,
                    doc.id,
                  ),
                )
                .toList();
        if (reset) {
          messages.value = newMessages;
        } else {
          messages.addAll(newMessages);
        }
      }
    });
  }

  // Fetch next page of messages
  Future<void> fetchMoreMessages(String chatId) async {
    Query query = _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('sentAt', descending: true)
        .limit(messagePageSize);
    if (lastMessageDoc != null) {
      query = query.startAfterDocument(lastMessageDoc!);
    }
    final snapshot = await query.get();
    if (snapshot.docs.isNotEmpty) {
      lastMessageDoc = snapshot.docs.last;
      final newMessages =
          snapshot.docs
              .map(
                (doc) => MessageModel.fromMap(
                  doc.data() as Map<String, dynamic>,
                  doc.id,
                ),
              )
              .toList();
      messages.addAll(newMessages);
    }
  }

  @override
  void onClose() {
    chatSubscription?.cancel();
    messageSubscription?.cancel();
    super.onClose();
  }

  // Send a message
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    final messageData = MessageModel(
      id: '',
      chatId: chatId,
      senderId: senderId,
      receiverId: receiverId,
      message: message,
      sentAt: Timestamp.now(),
      isRead: false,
    );
    final messageRef =
        _firestore.collection('chats').doc(chatId).collection('messages').doc();
    await messageRef.set(messageData.toMap());

    // Update chat metadata
    await _firestore.collection('chats').doc(chatId).set({
      'lastMessage': message,
      'lastMessageSentBy': senderId,
      'lastMessageTime': Timestamp.now(),
      'senderUnreadCount': FieldValue.increment(senderId == receiverId ? 0 : 0),
      'receiverUnreadCount': FieldValue.increment(
        senderId == receiverId ? 0 : 1,
      ),
    }, SetOptions(merge: true));
  }

  // Create or get chatId for two users
  // For order-based chats, includes the orderId to create unique chat per booking
  String getChatId(String senderId, String receiverId, {String? orderId}) {
    final ids = [senderId, receiverId]..sort();
    if (orderId != null && orderId.isNotEmpty) {
      // Order-based chat: include orderId in the chat ID
      return '${ids[0]}_${ids[1]}_order_$orderId';
    }
    // Regular chat: just use user IDs
    return '${ids[0]}_${ids[1]}';
  }

  // Create chat document if not exists
  Future<void> createChatIfNotExists(
    String senderId,
    String receiverId,
    bool isOrderChat,
    String? orderId, {
    String? orderCategory,
    String? orderService,
  }) async {
    final chatId = getChatId(senderId, receiverId, orderId: orderId);
    final chatRef = _firestore.collection('chats').doc(chatId);
    final doc = await chatRef.get();
    if (!doc.exists) {
      await chatRef.set({
        'senderId': senderId,
        'receiverId': receiverId,
        'participants': [senderId, receiverId],
        'lastMessage': '',
        'lastMessageSentBy': '',
        'lastMessageTime': Timestamp.now(),
        'senderUnreadCount': 0,
        'receiverUnreadCount': 0,
        'isOrderChat': isOrderChat,
        'orderId': orderId,
        'orderCategory': orderCategory,
        'orderService': orderService,
      });
    }
  }

  // Mark all messages as read for a user in a chat
  Future<void> markMessagesAsRead(String chatId, String userId) async {
    final query =
        await _firestore
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .where('receiverId', isEqualTo: userId)
            .where('isRead', isEqualTo: false)
            .get();
    for (final doc in query.docs) {
      await doc.reference.update({'isRead': true});
    }
    // Reset unread count
    await _firestore.collection('chats').doc(chatId).update({
      userId == chats.first.senderId
              ? 'senderUnreadCount'
              : 'receiverUnreadCount':
          0,
    });
  }

  // Fetch user details by userId
  Future<UserModel?> fetchUserById(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (doc.exists) {
      return UserModel.fromFirestore(doc);
    }
    return null;
  }
}
