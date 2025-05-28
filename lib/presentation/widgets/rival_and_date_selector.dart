import 'package:flutter/material.dart';
import 'package:versus_match/data/models/team_model.dart';


class RivalAndDateSelector extends StatelessWidget {
  final List<TeamModel> equiposRivales;
  final String? selectedTeamId;
  final DateTime? selectedDate;
  final ValueChanged<String?> onTeamChanged;
  final ValueChanged<DateTime?> onDateChanged;
  final bool loadingEquipos;

  const RivalAndDateSelector({
    super.key,
    required this.equiposRivales,
    required this.selectedTeamId,
    required this.selectedDate,
    required this.onTeamChanged,
    required this.onDateChanged,
    this.loadingEquipos = false,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: BorderSide(color: Colors.deepPurple.withOpacity(0.2), width: 2),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 12, top: 8, bottom: 4),
          child: Text(
            'Equipo rival',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.deepPurple,
            ),
          ),
        ),
        Material(
          elevation: 6,
          borderRadius: BorderRadius.circular(18),
          shadowColor: Colors.deepPurple.withOpacity(0.08),
          child: DropdownButtonFormField<String>(
            value: selectedTeamId,
            isExpanded: true,
            items: equiposRivales
                .map((team) => DropdownMenuItem(
                      value: team.id,
                      child: Row(
                        children: [
                          const Icon(Icons.groups, color: Colors.deepPurple),
                          const SizedBox(width: 8),
                          Text(team.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ))
                .toList(),
            onChanged: loadingEquipos ? null : onTeamChanged,
            decoration: InputDecoration(
              labelText: 'Selecciona equipo rival',
              labelStyle: const TextStyle(color: Colors.deepPurple),
              border: border,
              enabledBorder: border,
              focusedBorder: border.copyWith(
                borderSide: BorderSide(color: Colors.deepPurple, width: 2.5),
              ),
              prefixIcon: const Icon(Icons.sports_soccer, color: Colors.deepPurple),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 22, horizontal: 18),
            ),
            icon: const Icon(Icons.arrow_drop_down, color: Colors.deepPurple),
            dropdownColor: Colors.white,
          ),
        ),
        const SizedBox(height: 22),
        const Padding(
          padding: EdgeInsets.only(left: 12, bottom: 4),
          child: Text(
            'Fecha del reto',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.deepPurple,
            ),
          ),
        ),
        Material(
          elevation: 6,
          borderRadius: BorderRadius.circular(18),
          shadowColor: Colors.deepPurple.withOpacity(0.08),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (picked != null) onDateChanged(picked);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.deepPurple.withOpacity(0.2), width: 2),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.deepPurple),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      selectedDate == null
                          ? 'Selecciona fecha'
                          : '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(6.0),
                      child: Icon(Icons.edit_calendar, color: Colors.deepPurple),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}