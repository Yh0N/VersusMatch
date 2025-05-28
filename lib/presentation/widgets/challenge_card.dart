import 'package:flutter/material.dart';

class ChallengeCard extends StatelessWidget {
  final String fromTeamName;
  final String toTeamName;
  final DateTime date;
  final String status; // "pending", "accepted", "rejected"
  final bool canRespond;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const ChallengeCard({
    required this.fromTeamName,
    required this.toTeamName,
    required this.date,
    required this.status,
    this.canRespond = false,
    this.onAccept,
    this.onReject,
    super.key,
  });

  Color _statusColor(String status, BuildContext context) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return Colors.green[400]!;
      case 'rejected':
        return Colors.red[400]!;
      case 'pending':
        return Colors.orange[400]!;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  IconData _statusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      case 'pending':
        return Icons.hourglass_top;
      default:
        return Icons.help_outline;
    }
  }

  String _statusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pendiente';
      case 'accepted':
        return 'Aceptado';
      case 'rejected':
        return 'Rechazado';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
        child: Row(
          children: [
            // Status icon
            CircleAvatar(
              backgroundColor: _statusColor(status, context).withOpacity(0.15),
              radius: 26,
              child: Icon(
                _statusIcon(status),
                color: _statusColor(status, context),
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$fromTeamName vs $toTeamName',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}',
                        style: TextStyle(color: Colors.grey[700], fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(_statusIcon(status),
                          size: 16,
                          color: _statusColor(status, context)),
                      const SizedBox(width: 4),
                      Text(
                        _statusText(status),
                        style: TextStyle(
                          color: _statusColor(status, context),
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  // Botones solo si el equipo retado puede responder y el estado es pending
                  if (canRespond && status.toLowerCase() == 'pending')
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(Icons.check),
                            label: const Text('Aceptar'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            onPressed: onAccept,
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.close),
                            label: const Text('Rechazar'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                            onPressed: onReject,
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, color: Colors.deepPurple),
              onPressed: () {
                // Navegar a los detalles del desafío (opcional)
              },
            ),
          ],
        ),
      ),
    );
  }
}