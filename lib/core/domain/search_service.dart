// import 'package:rxdart/rxdart.dart';
// import 'package:whatsapp_ui/auth/domain/user_model.dart';
// import 'package:whatsapp_ui/auth/infrastructure/auth_repository.dart';
// import 'package:whatsapp_ui/chat/domain/chat_contact.dart';
// import 'package:whatsapp_ui/chat/infrastructure/chat_repository.dart';
// import 'package:whatsapp_ui/group/domain/group_model.dart';
// import 'package:whatsapp_ui/group/infrastructure/group_repository.dart';

// class SearchStream {
//   late final ChatRepository? _chatRepository;
//   late final AuthRepository? _authRepository;
//   late final GroupRepository? _groupRepository;

//   SearchStream._(this._chatRepository, this._authRepository, this._groupRepository) {
//     if (_chatRepository != null) {
//       _resultsChat = _searchChatsTerms.debounceTime(const Duration(milliseconds: 500)).switchMap(
//         (query) async* {
//           yield* _chatRepository!.search(query.trim());
//         },
//       );
//     }
//   }

//   factory SearchStream.chat(ChatRepository chatRepository) {
//     return SearchStream._(chatRepository, null, null);
//   }

//   factory SearchStream.group(GroupRepository groupRepository) {
//     return SearchStream._(null, null, groupRepository);
//   }

//   factory SearchStream.user(AuthRepository authRepository) {
//     return SearchStream._(null, authRepository, null);
//   }

//   final _searchChatsTerms = BehaviorSubject<String>();
//   void searchChats(String query) => _searchChatsTerms.add(query);

//   late Stream<List<ChatContact>> _resultsChat;
//   Stream<List<ChatContact>> get resultsChat => _resultsChat;

//   final _searchUsersTerms = BehaviorSubject<String>();
//   void searchUsers(String query) => _searchUsersTerms.add(query);

//   late Stream<UserModel> _resultsUser;
//   Stream<UserModel> get resultsUser => _resultsUser;

//   final _searchGroupsTerms = BehaviorSubject<String>();
//   void searchGroups(String query) => _searchGroupsTerms.add(query);

//   late Stream<GroupModel> _resultsGroup;
//   Stream<GroupModel> get resultsGroup => _resultsGroup;

//   void dispose() {
//     _searchChatsTerms.close();
//     _searchGroupsTerms.close();
//     _searchUsersTerms.close();
//   }
// }
