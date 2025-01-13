import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stockzen/screens/profile/edit_profile/widgets/text_form.dart';

class SaleFormFields extends StatelessWidget {
  final TextEditingController dateController;
  final TextEditingController customerNameController;
  final TextEditingController customerNumberController;

  const SaleFormFields({
    super.key,
    required this.dateController,
    required this.customerNameController,
    required this.customerNumberController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextFormField(
          controller: dateController,
          labelText: 'Date',
          icon: Icons.calendar_month,
          readOnly: true,
          onTap: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            if (pickedDate != null) {
              dateController.text = DateFormat('dd-MMM-yyyy').format(pickedDate);
            }
          },
        ),
        const SizedBox(height: 20),
        CustomTextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: customerNameController,
          icon: Icons.person,
          labelText: 'Customer Name',
          hintText: 'Enter Customer Name',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter customer's name";
            }
            return null;
          },
        ),
        const SizedBox(height: 20),
        CustomTextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: customerNumberController,
          icon: Icons.phone,
          labelText: 'Mobile Number',
          hintText: "Enter customer's number",
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter customer's number";
            }
            return null;
          },
        ),
      ],
    );
  }
}