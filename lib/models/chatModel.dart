class ChatModel {
  final int? id;
  final String? name;
  final String? lastmsg;
  final List<String?> msglist;

  ChatModel({
    required this.id,
    required this.lastmsg,
    required this.name,
    required this.msglist,
  });
}

List messages = [
  ChatModel(
      id: 1,
      name: 'Dil Ajbar',
      lastmsg: 'hloo',
      msglist: ['hii', 'how are u', 'fine']),
  ChatModel(
      id: 2,
      name: 'Sameer',
      lastmsg: 'come',
      msglist: ['hii', 'how are u', 'fine']),
  ChatModel(
      id: 3,
      name: 'Abhijith',
      lastmsg: 'have anice ',
      msglist: ['hii', 'how are u', 'fine']),
  ChatModel(
      id: 4,
      name: 'Sumesh',
      lastmsg: 'kloo',
      msglist: ['hii', 'how are u', 'fine']),
  ChatModel(
      id: 5,
      name: 'Ragav',
      lastmsg: 'have anice ',
      msglist: ['hii', 'how are u', 'fine']),
];
