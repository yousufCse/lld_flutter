enum NamedRoute {
  splash(routeName: 'splash', routePath: '/');

  final String routeName;
  final String routePath;

  const NamedRoute({required this.routeName, required this.routePath});
}
