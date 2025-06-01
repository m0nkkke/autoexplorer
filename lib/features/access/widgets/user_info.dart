import 'package:autoexplorer/generated/l10n.dart';
import 'package:flutter/material.dart';

class UserInfoWidget extends StatelessWidget {
  final String lastName;
  final String firstName;
  final String middleName;

  const UserInfoWidget({
    super.key,
    required this.lastName,
    required this.firstName,
    required this.middleName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).accessControl,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildStaticInfoRow(label: S.of(context).lastName, value: lastName),
        _buildStaticInfoRow(label: S.of(context).firstName, value: firstName),
        _buildStaticInfoRow(label: S.of(context).middleName, value: middleName),
      ],
    );
  }

  Widget _buildStaticInfoRow({
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? '—' : value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
