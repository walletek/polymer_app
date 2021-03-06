/**
 * Created by lejard_h on 24/12/15.
 */

part of polymer_app.cli;

class RoutesManager extends Manager {
  ElementsManager elements;

  RoutesManager(String appName, String libraryPath)
      : super(appName, libraryPath, "routes") {
    appName = "$appName-route";
    elements = new ElementsManager(appName, libraryPath);
  }

  String get libraryTemplate => "library ${toSnakeCase(appName)}.routes;"
      "// export 'route.dart';";

  createRoute(String name, String path,
      {String dartTemplate,
      String htmlTemplate,
      String cssTemplate,
      bool isDefault: false,
      bool isAbstract,
      String redirectTo,
      String parent}) async {
    String routeName = name;
    name = "$name-route";
    if (dartTemplate == null) {
      dartTemplate = routeDartTemplate(name, routeName, path, isDefault,
          isAbstract: isAbstract, parent: parent, redirectTo: redirectTo);
    }
    htmlTemplate = elements.elementHtmlTemplate(name, htmlTemplate ?? "");
    if (cssTemplate == null) {
      cssTemplate = elements.elementCssTemplate(name);
    }

    await writeInDartFile(
        "$libraryPath/${toSnakeCase(name)}/${toSnakeCase(name)}.dart",
        dartTemplate);
    await writeInFile(
        "$libraryPath/${toSnakeCase(name)}/${toSnakeCase(name)}.html",
        htmlTemplate);
    await writeInFile(
        "$libraryPath/${toSnakeCase(name)}/${toSnakeCase(name)}.css",
        cssTemplate);
  }

  addToLibrary(String name, [String path = "."]) {
    super.addToLibrary(name, name);
  }

  _notEmptyButNull(String value ) {
    if (value == null || value.isEmpty) {
      return null;
    }
    return '"$value"';
  }

  routeDartTemplate(String name, String routeName, String path, bool isDefault,
          {bool isAbstract: false, String redirectTo: "", String parent: ""}) =>
      "@HtmlImport('${toSnakeCase(name)}.html')"
      "library ${toSnakeCase(appName)}.elements.${toSnakeCase(name)};"
      "import 'package:polymer/polymer.dart';"
      "import 'package:web_components/web_components.dart' show HtmlImport;"
      'import "package:polymer_app/polymer_app.dart";\n\n'
      '@PolymerRoute("${toCamelCase(routeName)}", "$path", isDefault: $isDefault,'
      'isAbstract: $isAbstract, parent: ${_notEmptyButNull(toCamelCase(parent))}, redirectTo: ${_notEmptyButNull(toCamelCase(redirectTo))})'
      "@PolymerRegister('${toLispCase(name)}')\n"
      "class ${toCamelCase(name)} extends PolymerElement with AutonotifyBehavior, Observable, PolymerAppRouteBehavior { "
      "${toCamelCase(name)}.created() : super.created();\n\n"
      "/// Called when an instance of ${toLispCase(name)} is inserted into the DOM.\n"
      "attached() {"
      "super.attached();"
      "}\n\n"
      "/// Called when an instance of ${toLispCase(name)} is removed from the DOM.\n"
      "detached() {"
      "super.detached();"
      "}\n\n"
      "/// Called when an attribute (such as  a class) of an instance of ${toLispCase(name)} is added, changed, or removed.\n"
      "attributeChanged(String name, String oldValue, String newValue) {"
      "super.attributeChanged(name, oldValue, newValue);"
      "}\n\n"
      "/// Called when ${toLispCase(name)} has been fully prepared (Shadow DOM created, property observers set up, event listeners attached).\n"
      "ready() {"
      "}\n\n"
      "/// Called when PolymerRouter enter on ${toLispCase(name)}\n"
      "enter(RouteEnterEvent event, [Map params]) {}\n\n"
      "}";
}
