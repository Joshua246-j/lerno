import 'dart:io';

void main() {
  final libDir = Directory('lib');
  final assetsDir = Directory('assets');
  
  if (!libDir.existsSync() || !assetsDir.existsSync()) {
    print('Run this from the project root.');
    return;
  }

  // 1. Collect all asset files
  final allAssets = <String>{};
  final assetFiles = assetsDir.listSync(recursive: true).whereType<File>();
  for (var file in assetFiles) {
    // Normalize path to use forward slashes
    final path = file.path.replaceAll('\\\\', '/');
    allAssets.add(path);
  }

  // 2. Scan all dart files for asset references
  final dartFiles = libDir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));
  final usedAssets = <String>{};
  
  final assetPattern = RegExp(r"assets/[a-zA-Z0-9_/\-\.]+");
  
  for (var file in dartFiles) {
    final content = file.readAsStringSync();
    final matches = assetPattern.allMatches(content);
    for (var match in matches) {
      usedAssets.add(match.group(0)!);
    }
  }

  // 3. Compare
  print('--- ASSET AUDIT REPORT ---');
  print('Total Assets Found: ${allAssets.length}');
  print('Hardcoded Asset References in Code: ${usedAssets.length}');
  
  print('\\n--- POTENTIALLY UNUSED ASSETS ---');
  final unused = allAssets.where((a) {
    // Check if the normalized forward-slash path is in usedAssets
    final normalizedA = a.replaceAll('\\\\', '/');
    return !usedAssets.contains(normalizedA);
  }).toList();
  for (var a in unused) {
    print(a);
  }
}
