import 'package:flutter_test/flutter_test.dart';
import 'package:kanban_app/models/project.dart';

void main() {
  group('Project Model', () {
    test('fromJson should return correct Project object', () {
      final json = {
        'guid': "1",
        'name': 'Test Project',
        'description': 'Test Description'
      };

      final project = Project.fromJson(json);

      expect(project.id, "1");
      expect(project.name, 'Test Project');
      expect(project.description, 'Test Description');
    });

    test('toJson should return correct map', () {
      final project = Project(
          id: "2", name: 'Another Project', description: 'More Details');

      final json = project.toJson();

      expect(json['guid'], "2");
      expect(json['name'], 'Another Project');
      expect(json['description'], 'More Details');
    });
  });
}
