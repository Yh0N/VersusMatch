import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:versus_match/core/providers/appwrite_providers.dart';
import 'package:versus_match/data/models/message_model.dart';
import 'package:versus_match/data/repositories/chat_repository.dart';


final chatControllerProvider = Provider((ref) {
  final repo = ref.read(chatRepositoryProvider);
  return ChatController(repo);
});

class ChatController {
  final ChatRepository _repo;

  ChatController(this._repo);

  Future<void> sendMessage(MessageModel message) {
    return _repo.sendMessage(message);
  }

  Future<List<MessageModel>> getMessages(String chatId) {
    return _repo.getMessagesForChat(chatId);
  }
}
