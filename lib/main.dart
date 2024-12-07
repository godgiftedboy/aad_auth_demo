import 'package:aad_auth_demo/webview_home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePageWeb(),
      navigatorKey: navigatorKey,
    );
  }
}




// class MyHomePage extends StatefulWidget {
//   MyHomePage({super.key, required this.title});
//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   static final Config config = Config(
//     tenant: 'f050df82-ae31-4d3f-934f-39d283ab1e32',
//     clientId: '202e5f68-95ec-4d43-8cc5-cf5b102f790b',
//     scope: 'openid offline_access',
//     navigatorKey: navigatorKey,
//     customAuthorizationUrl:
//         "https://swohum.b2clogin.com/swohum.onmicrosoft.com/b2c_1_signup_signin_test_mobile/oauth2/v2.0/authorize",
//     redirectUri:
//         "msauth://com.example.aad_auth_demo/1%2Bc2k5Kax7x7tA4mqg6C9OOMbE8%3D",
//     customTokenUrl:
//         "https://swohum.b2clogin.com/swohum.onmicrosoft.com/b2c_1_signup_signin_test_mobile/oauth2/v2.0/token",
//     isB2C: true,
//     loader: const SizedBox(),
//     appBar: AppBar(
//       title: const Text('AAD OAuth Demo'),
//     ),
//     onPageFinished: (String url) {
//       log('onPageFinished: $url');
//     },
//     webUseRedirect: true,
//   );
//   final AadOAuth oauth = AadOAuth(config);

//   @override
//   Widget build(BuildContext context) {
//     var kIsWeb2 = kIsWeb;
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: ListView(
//         children: <Widget>[
//           ListTile(
//             title: Text(
//               'AzureAD OAuth',
//               style: Theme.of(context).textTheme.headlineSmall,
//             ),
//           ),
//           ListTile(
//             leading: Icon(Icons.launch),
//             title: Text('Login${kIsWeb2 ? ' (web popup)' : ''}'),
//             onTap: () {
//               login(false);
//             },
//           ),
//           // if (kIsWeb)
//           //   ListTile(
//           //     leading: Icon(Icons.launch),
//           //     title: Text('Login (web redirect)'),
//           //     onTap: () {
//           //       login(true);
//           //     },
//           //   ),
//           ListTile(
//             leading: Icon(Icons.data_array),
//             title: Text('HasCachedAccountInformation'),
//             onTap: () => hasCachedAccountInformation(),
//           ),
//           ListTile(
//             leading: Icon(Icons.logout),
//             title: Text('Logout'),
//             onTap: () {
//               logout();
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   void showError(dynamic ex) {
//     showMessage(ex.toString());
//   }

//   void showMessage(String text) {
//     var alert = AlertDialog(content: Text(text), actions: <Widget>[
//       TextButton(
//           child: const Text('Ok'),
//           onPressed: () {
//             Navigator.pop(context);
//           })
//     ]);
//     showDialog(context: context, builder: (BuildContext context) => alert);
//   }

//   void login(bool redirect) async {
//     log("$redirect");
//     config.webUseRedirect = redirect;
//     final result = await oauth.login();
//     result.fold(
//       (l) => showError(l.toString()),
//       (r) => showMessage('Logged in successfully, your access token: $r'),
//     );
//     var accessToken = await oauth.getAccessToken();
//     if (accessToken != null) {
//       ScaffoldMessenger.of(context).hideCurrentSnackBar();
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text(accessToken)));
//     }
//   }

//   void hasCachedAccountInformation() async {
//     var hasCachedAccountInformation = await oauth.hasCachedAccountInformation;
//     ScaffoldMessenger.of(context).hideCurrentSnackBar();
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content:
//             Text('HasCachedAccountInformation: $hasCachedAccountInformation'),
//       ),
//     );
//   }

//   void logout() async {
//     await oauth.logout();
//     showMessage('Logged out');
//   }
// }
