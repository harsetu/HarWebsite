import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../constants/color_manager.dart';
import '../utils/logger.dart';
import 'base_screen.dart';
import 'base_text_view.dart';

class BaseWebView extends StatefulWidget {
  final String url;
  final String? loadingText;
  final String? title;
  final bool showAppBar;

  const BaseWebView({
    super.key,
    required this.url,
    this.loadingText,
    this.title,
    this.showAppBar = true,
  });

  @override
  State<BaseWebView> createState() => _BaseWebViewState();
}

class _BaseWebViewState extends State<BaseWebView> with BaseScreenMixin {
  bool isLoading = true;
  late final WebViewController _controller;
  bool _isOpeningExternally = false;

  // List of URLs that should open in external browser
  final List<String> _externalUrls = [
    'https://www.linkedin.com/company/elivaas/',
    'https://www.facebook.com/stay.elivaas/',
    'https://www.instagram.com/stay.elivaas/',
  ];

  bool _shouldOpenExternally(String url) {
    return _externalUrls.any((externalUrl) => url.startsWith(externalUrl));
  }

  @override
  void initState() {
    super.initState();

    // Check if the initial URL should be opened externally
    if (_shouldOpenExternally(widget.url)) {
      _isOpeningExternally = true;
      _launchExternalUrl(widget.url);
      return;
    }

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel('FlutterChannel', onMessageReceived: (JavaScriptMessage message) {
        Logger.debug('JavaScript message received: ${message.message}');
        if (mounted) {
          _handleJavaScriptMessage(message.message);
        }
      })
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() => isLoading = progress < 100);
          },
          onPageStarted: (_) => setState(() => isLoading = true),
          onPageFinished: (String url) {
            setState(() => isLoading = false);
            // Inject JavaScript function for back button handling
            _injectBackPressHandler();
          },
          onHttpError: (error) => Logger.debug('HTTP error: ${error.response?.statusCode} - ${error.response?.uri}'),
          onWebResourceError: (error) => Logger.debug('WebView error: ${error.errorCode} - ${error.description}'),
          onNavigationRequest: (NavigationRequest request) async {
            if (_shouldOpenExternally(request.url)) {
              try {
                await launchUrl(Uri.parse(request.url), mode: LaunchMode.externalApplication);
                return NavigationDecision.prevent;
              } catch (e) {
                Logger.debug('Error launching external URL: $e');
                return NavigationDecision.navigate;
              }
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  /// Inject JavaScript function to handle back button press
  void _injectBackPressHandler() {
    const String jsCode = '''
      // Create the mobileBridge interface that JavaScript can call
      window.mobileBridge = {
        exitFromWebView: function() {
          console.log('mobileBridge.exitFromWebView() called from JavaScript');
          // Send message to Flutter through the FlutterChannel
          if (window.FlutterChannel && window.FlutterChannel.postMessage) {
            window.FlutterChannel.postMessage('exit_webview');
            console.log('Message sent to Flutter channel');
          } else {
            console.log('Flutter channel not available');
          }
        }
      };
      
      // Wait for Flutter channel to be available
      setTimeout(function checkChannel() {
        if (window.FlutterChannel && window.FlutterChannel.postMessage) {
          console.log('Flutter channel is ready');
        } else {
          console.log('Waiting for Flutter channel...');
          setTimeout(checkChannel, 100);
        }
      }, 100);
      
      
      console.log('mobileBridge interface created - JavaScript can now call window.mobileBridge.exitFromWebView()');
    ''';

    _controller.runJavaScript(jsCode);
  }

  /// Handle messages from JavaScript
  void _handleJavaScriptMessage(String message) {
    Logger.debug('Handling JavaScript message: $message');

    switch (message) {
      case 'exit_webview':
      case 'back_pressed':
      case 'browser_back':
        // Handle the back navigation
        Navigator.of(context).maybePop();
        break;
      default:
        Logger.debug('Unknown JavaScript message: $message');
    }
  }

  Future<void> _launchExternalUrl(String url) async {
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      // Close the WebView after launching external URL
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      Logger.debug('Error launching external URL: $e');
      // If external launch fails, proceed with normal WebView loading
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {
              setState(() => isLoading = progress < 100);
            },
            onPageStarted: (_) => setState(() => isLoading = true),
            onPageFinished: (_) => setState(() => isLoading = false),
            onHttpError: (error) => Logger.debug('HTTP error: ${error.response?.statusCode} - ${error.response?.uri}'),
            onWebResourceError: (error) => Logger.debug('WebView error: ${error.errorCode} - ${error.description}'),
            onNavigationRequest: (NavigationRequest request) async {
              if (_shouldOpenExternally(request.url)) {
                try {
                  await launchUrl(Uri.parse(request.url), mode: LaunchMode.externalApplication);
                  return NavigationDecision.prevent;
                } catch (e) {
                  Logger.debug('Error launching external URL: $e');
                  return NavigationDecision.navigate;
                }
              }
              return NavigationDecision.navigate;
            },
          ),
        )
        ..loadRequest(Uri.parse(widget.url));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    if (!widget.showAppBar) {
      return _buildWebViewContent();
    }

    return Container(
      color: ColorManager.colorWhite,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: ColorManager.colorWhite,
            elevation: 4,
            shadowColor: ColorManager.colorBlack.withAlpha(63),
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: ColorManager.colorBlack),
              onPressed: handleBack,
            ),
            title: widget.title != null
                ? BaseTextView(
                    text: widget.title!,
                    style: themeData.textTheme.titleMedium,
                  )
                : null,
          ),
          body: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _buildWebViewContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildWebViewContent() {
    if (_isOpeningExternally) {
      return Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              BaseTextView(
                text: "Opening in external browser...",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
        ),
      );
    }

    return Stack(
      children: [
        WebViewWidget(controller: _controller, ),
        if (isLoading)
          Container(
            color: Colors.white,
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  BaseTextView(
                    text: widget.loadingText ?? "Loading..",
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
