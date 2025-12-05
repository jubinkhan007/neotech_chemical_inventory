/// Dashboard metrics for the chemical inventory.
class DashboardMetrics {
  const DashboardMetrics({
    required this.totalChemicals,
    required this.activeSDSDocuments,
    required this.recentIncidents,
  });

  final int totalChemicals;
  final int activeSDSDocuments;
  final int recentIncidents;

  factory DashboardMetrics.fromJson(Map<String, dynamic> json) {
    return DashboardMetrics(
      totalChemicals: json['totalChemicals'] as int? ?? 0,
      activeSDSDocuments: json['activeSDSDocuments'] as int? ?? 0,
      recentIncidents: json['recentIncidents'] as int? ?? 0,
    );
  }
}
