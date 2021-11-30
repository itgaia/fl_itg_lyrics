import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';


var logger = Logger(
  printer: PrettyPrinter(),
);

var loggerNoStack = Logger(
  printer: PrettyPrinter(methodCount: 0),
);

class ShowLogConsole extends StatelessWidget {
  const ShowLogConsole({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    itgLogVerbose('${this.toString()} - start...');
    // getAppMainManager(context);

    return Text('log console');
    // return LogConsole.open(context);
    // LogConsole.init();
    // return LogConsole();
    // return Text(logger.toString());
  }
}

void itgLogMsg(msg, {bool withStack = false}) {
  withStack ?  logger.d(msg) : loggerNoStack.d(msg);
}

void itgLogVerbose(msg, {bool withStack = false}) {
  withStack ?  logger.v(msg) : loggerNoStack.v(msg);
  // print(msg);       // this is printed to browser console - used only when debug release web...!
}

void itgLogInfo(msg, {bool withStack = false}) {
  withStack ?  logger.i(msg) : loggerNoStack.i(msg);
}

// When finish with the debug, replaceAll with Verbose
void itgLogTempInfo(msg, {bool withStack = false}) {
  withStack ?  logger.i(msg) : loggerNoStack.i(msg);
  // Sentry.captureMessage(msg);
}

void itgLogWarning(msg, {bool withStack = false}) {
  withStack ?  logger.w(msg) : loggerNoStack.w(msg);
}

void itgLogError(msg, {bool withStack = false}) {
  withStack ?  logger.e(msg) : loggerNoStack.e(msg);
}