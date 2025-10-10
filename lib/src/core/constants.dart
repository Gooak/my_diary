import 'package:flutter_dotenv/flutter_dotenv.dart';

final googleServerClientId = dotenv.env['GOOGLE_SERVER_CLIENT_ID'];
final googleClientId = dotenv.env['GOOGLE_CLIENT_ID'];

final googleAdDebugFrontId = dotenv.env['GOOGLE_AD_DEBUG_FRONT_ID'];
final googleAdReleaseFrontId = dotenv.env['GOOGLE_AD_RELEASE_FRONT_ID'];

final googleAdDebugBannerId = dotenv.env['GOOGLE_AD_DEBUG_BANNER_ID'];
final googleAdReleaseBannerId = dotenv.env['GOOGLE_AD_RELEASE_BANNER_ID'];

final appStoreUrl = dotenv.env['APP_STORE_URL'];

final privacyPolicy = dotenv.env['PROVACY_POLICY'];

final termsOfUse = dotenv.env['TERMS_OF_USE'];

final googleDriveFolder = dotenv.env['GOOGLE_DRIVE_FOLDER'];
final googleDriveFields = dotenv.env['GOOGLE_DRIVE_FIELDS'];

final dirPath = 'my_diary_files';

final backupFileName = 'my_diary_backup.zip';

final hiveFileNames = [
  'mytodo.lock',
  'mytodo.hive',
  'apptheme.lock',
  'apptheme.hive',
  'tododaycount.lock',
  'tododaycount.hive',
];
