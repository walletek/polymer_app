/**
 * Created by lejard_h on 30/12/15.
 */

part of polymer_app;

@behavior
abstract class PolymerRouter {
  List<Page> _pages = [];

  static List<Page> pagesRouter = [];

  @Property(notify: true) List<Page> get pages => _pages;
  set pages(List<Page> value) {
    _pages = value;
    notifyPath("pages", value);
  }

  static attached(PolymerRouter instance) async {
    await init.run(typeFilter: [PolymerRoute]);
    instance.pages = pagesRouter;
  }

  static goToDefault(
          {Map parameters,
          Route startingFrom,
          bool replace: false,
          Map queryParameters,
          bool forceReload: false}) =>
      PolymerRouterBehavior.goToDefault(
          parameters: parameters,
          startingFrom: startingFrom,
          replace: replace,
          queryParameters: queryParameters,
          forceReload: forceReload);

  static goToName(String name,
          {Map parameters,
          Route startingFrom,
          bool replace: false,
          Map queryParameters,
          bool forceReload: false}) =>
      PolymerRouterBehavior.goToName(name,
          parameters: parameters,
          startingFrom: startingFrom,
          replace: replace,
          queryParameters: queryParameters,
          forceReload: forceReload);
}

Object getAnnotation(Type element, Type annotation) {
  TypeMirror mir = jsProxyReflectable.reflectType(element);
  for (var dec in mir.metadata) {
    if (dec.runtimeType == annotation) {
      return dec;
    }
  }

  return null;
}

class PolymerRoute implements init.Initializer<Type> {
  final String name;
  final String path;
  final bool isDefault;
  final bool isAbstract;
  final String redirectTo;
  final String parent;

  const PolymerRoute(this.name, this.path,
      {this.isDefault: false,
      this.parent,
      this.redirectTo,
      this.isAbstract});

  initialize(Type element) {
    PolymerRegister reg = getAnnotation(element, PolymerRegister);
    if (reg != null) {
      PolymerAppRouteBehavior routeElem =
          new Element.tag(reg.tagName) as PolymerAppRouteBehavior;
      PolymerRouter.pagesRouter.add(new Page(name, path,
          element: routeElem,
          isDefault: isDefault,
          isAbstract: isAbstract,
          redirectTo: redirectTo,
          parent: parent));
    }
  }
}
