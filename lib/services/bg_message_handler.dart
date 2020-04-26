
/* */
Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {

  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
    print('::: un mensaje:::');
    print(data);
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
    print('::: una notificacion:::');
    print(notification);
  }

  // Or do other work.
  return 'Desde el Msg Handler';

}