// Reminder scheduler: mobile (local notifications) vs web/stub no-op.
export 'notification_stub.dart'
    if (dart.library.io) 'notification_io.dart';
