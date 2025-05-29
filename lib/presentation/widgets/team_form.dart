import 'dart:io';
import 'package:flutter/material.dart';

class TeamForm extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController locationController;
  final TextEditingController descriptionController;
  final VoidCallback onPickLogo;
  final VoidCallback onGetLocation;
  final VoidCallback onSubmit;
  final bool isLoading;
  final File? logoImageFile;
  final bool openToJoin;
  final ValueChanged<bool?> onOpenToJoinChanged;

  const TeamForm({
    super.key,
    required this.nameController,
    required this.locationController,
    required this.descriptionController,
    required this.onPickLogo,
    required this.onGetLocation,
    required this.onSubmit,
    required this.isLoading,
    required this.logoImageFile,
    required this.openToJoin,
    required this.onOpenToJoinChanged,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Colors.deepPurple.withOpacity(0.2), width: 2),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nombre del equipo',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple),
        ),
        const SizedBox(height: 8),
        Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(16),
          shadowColor: Colors.deepPurple.withOpacity(0.08),
          child: TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Nombre',
              prefixIcon: const Icon(Icons.group, color: Colors.deepPurple),
              border: border,
              enabledBorder: border,
              focusedBorder: border.copyWith(
                borderSide: const BorderSide(color: Colors.deepPurple, width: 2.5),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
            ),
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Ubicación',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(16),
                shadowColor: Colors.deepPurple.withOpacity(0.08),
                child: TextField(
                  controller: locationController,
                  decoration: InputDecoration(
                    labelText: 'Ubicación',
                    prefixIcon: const Icon(Icons.location_on, color: Colors.deepPurple),
                    border: border,
                    enabledBorder: border,
                    focusedBorder: border.copyWith(
                      borderSide: const BorderSide(color: Colors.deepPurple, width: 2.5),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              onPressed: onGetLocation,
              icon: const Icon(Icons.my_location, color: Colors.deepPurple),
              tooltip: 'Usar mi ubicación',
            ),
          ],
        ),
        const SizedBox(height: 18),
        const Text(
          'Descripción',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple),
        ),
        const SizedBox(height: 8),
        Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(16),
          shadowColor: Colors.deepPurple.withOpacity(0.08),
          child: TextField(
            controller: descriptionController,
            maxLines: 4,
            minLines: 2,
            decoration: InputDecoration(
              labelText: 'Descripción',
              prefixIcon: const Icon(Icons.info_outline, color: Colors.deepPurple),
              border: border,
              enabledBorder: border,
              focusedBorder: border.copyWith(
                borderSide: const BorderSide(color: Colors.deepPurple, width: 2.5),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
            ),
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Logo del equipo',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            GestureDetector(
              onTap: onPickLogo,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.deepPurple.withOpacity(0.2)),
                ),
                child: logoImageFile != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(logoImageFile!, fit: BoxFit.cover),
                      )
                    : const Icon(Icons.add_a_photo, color: Colors.deepPurple, size: 32),
              ),
            ),
            const SizedBox(width: 14),
            const Text('Toca para seleccionar logo'),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Checkbox(
              value: openToJoin,
              onChanged: onOpenToJoinChanged,
              activeColor: Colors.deepPurple,
            ),
            const Text(
              'Permitir que cualquiera se una',
              style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 28),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: isLoading ? null : onSubmit,
            icon: const Icon(Icons.sports_soccer, color: Colors.white),
            label: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Text(
                    'Crear equipo',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                      color: Colors.white,
                    ),
                  ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 2,
            ),
          ),
        ),
      ],
    );
  }
}