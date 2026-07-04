import 'dart:io';

void main() {
  final svgs = [
    'bronze_1',
    'bronze_2',
    'bronze_3',
    'silver_1',
    'silver_2',
    'silver_3',
    'gold',
    'crystal',
    'diamond',
    'master',
    'champion',
    'legend'
  ];

  final dir = Directory(
      'd:\\DOCUMENTS\\PROGRAMING\\FLutter\\lerno\\assets\\svg\\league');
  if (!dir.existsSync()) {
    dir.createSync(recursive: true);
  }

  for (var svg in svgs) {
    final file = File('${dir.path}/$svg.svg');
    final color = svg.contains('bronze')
        ? '#CD7F32'
        : svg.contains('silver')
            ? '#C0C0C0'
            : svg.contains('gold')
                ? '#FFD700'
                : '#00FFFF';

    file.writeAsStringSync('''
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
  <path d="M50 5 L90 20 L90 60 L50 95 L10 60 L10 20 Z" fill="$color" stroke="#fff" stroke-width="2"/>
  <text x="50" y="55" font-family="Arial" font-size="16" fill="#fff" text-anchor="middle">$svg</text>
</svg>
''');
  }

  // Also create a placeholder for missing badges if any.
  final badgesDir = Directory(
      'd:\\DOCUMENTS\\PROGRAMING\\FLutter\\lerno\\assets\\svg\\badges');
  if (!badgesDir.existsSync()) {
    badgesDir.createSync(recursive: true);
  }
}
