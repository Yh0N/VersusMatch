import 'package:appwrite/appwrite.dart';
import 'package:versus_match/core/constants/appwrite_constants.dart';
import 'package:versus_match/data/models/message_model.dart';


class ChatRepository {
  final Databases _db;

  ChatRepository(this._db);

  Future<void> sendMessage(MessageModel message) async {
    await _db.createDocument(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.matchesCollectionId,
      documentId: ID.unique(),
      data: message.toMap(),
    );
  }

  Future<List<MessageModel>> getMessagesForChat(String chatId) async {
    final result = await _db.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.matchesCollectionId,
      queries: [
        Query.equal('chatId', chatId),
        Query.orderAsc('timestamp'),
      ],
    );

    return result.documents
        .map((doc) => MessageModel.fromMap(doc.data))
        .toList();
  }
}
