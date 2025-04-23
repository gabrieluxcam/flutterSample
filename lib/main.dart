import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/wishlist_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/shell_screen.dart';
import 'screens/products_list_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/checkout_success_screen.dart';
import 'screens/credit_cards_screen.dart';
import 'screens/order_history_screen.dart';
import 'theme.dart';
import 'package:flutter_uxcam/flutter_uxcam.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterUxcam.optIntoSchematicRecordings();
  await FlutterUxcam.startWithConfiguration(
    FlutterUxConfig(
      userAppKey: "djazkur7hg5icjx",
      enableAutomaticScreenNameTagging: false,
      enableIntegrationLogging: true,
    ),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/',
      observers: [FlutterUxcamNavigatorObserver()],
      routes: [
        GoRoute(path: '/', builder: (ctx, state) => const SplashScreen()),
        GoRoute(path: '/login', builder: (ctx, state) => const LoginScreen()),
        GoRoute(
          path: '/order_success/:orderId',
          builder: (ctx, state) {
            final id = state.pathParameters['orderId']!;
            return CheckoutSuccessScreen(orderId: id);
          },
        ),
        ShellRoute(
          builder: (ctx, state, child) => ShellScreen(child: child),
          routes: [
            GoRoute(
              path: '/home/products',
              pageBuilder:
                  (ctx, state) => CustomTransitionPage<void>(
                    key: state.pageKey,
                    child: const ProductsListScreen(),
                    transitionsBuilder:
                        (ctx, anim, secAnim, child) =>
                            FadeTransition(opacity: anim, child: child),
                  ),
              routes: [
                GoRoute(
                  path: ':id',
                  builder: (ctx, state) {
                    final id = state.pathParameters['id']!;
                    return ProductDetailScreen(productId: id);
                  },
                ),
              ],
            ),
            GoRoute(
              path: '/home/cart',
              pageBuilder:
                  (ctx, state) => CustomTransitionPage<void>(
                    key: state.pageKey,
                    child: const CartScreen(),
                    transitionsBuilder:
                        (ctx, anim, secAnim, child) =>
                            FadeTransition(opacity: anim, child: child),
                  ),
              routes: [
                GoRoute(
                  path: 'checkout',
                  builder: (ctx, state) => const CheckoutScreen(),
                ),
              ],
            ),
            GoRoute(
              path: '/home/profile',
              pageBuilder:
                  (ctx, state) => CustomTransitionPage<void>(
                    key: state.pageKey,
                    child: const ProfileScreen(),
                    transitionsBuilder:
                        (ctx, anim, secAnim, child) =>
                            FadeTransition(opacity: anim, child: child),
                  ),
            ),
            GoRoute(
              path: '/home/orders',
              pageBuilder:
                  (ctx, state) => CustomTransitionPage<void>(
                    key: state.pageKey,
                    child: const OrderHistoryScreen(),
                    transitionsBuilder:
                        (ctx, anim, secAnim, child) =>
                            FadeTransition(opacity: anim, child: child),
                  ),
            ),
            GoRoute(
              path: '/home/my-cards',
              pageBuilder:
                  (ctx, state) => CustomTransitionPage<void>(
                    key: state.pageKey,
                    child: const CreditCardsScreen(),
                    transitionsBuilder:
                        (ctx, anim, secAnim, child) =>
                            FadeTransition(opacity: anim, child: child),
                  ),
            ),
          ],
        ),
      ],
      redirect: (ctx, state) {
        final auth = ctx.read<AuthProvider>();
        final loggedIn = auth.isLoggedIn;
        final loggingIn = state.location == '/login';
        if (!loggedIn && !loggingIn) return '/login';
        if (loggedIn && loggingIn) return '/home/products';
        return null;
      },
      refreshListenable: context.read<AuthProvider>(),
    );

    return MaterialApp.router(
      title: 'Flutter E-commerce',
      theme: appTheme,
      routerConfig: router,
    );
  }
}
