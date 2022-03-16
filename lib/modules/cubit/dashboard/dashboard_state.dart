part of 'dashboard_cubit.dart';

abstract class DashboardState {}

class UnknownDashboardState extends DashboardState {}

class Unauthenticated extends DashboardState {}

class Authenticated extends DashboardState {}
