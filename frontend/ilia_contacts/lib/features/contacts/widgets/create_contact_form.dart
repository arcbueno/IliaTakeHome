import 'package:flutter/material.dart';

// Using StatefulWidget to maintain state on keyboard resize and form input
class CreateContactForm extends StatefulWidget {
  final Function(String) onNameChanged;
  final Function(String) onEmailChanged;
  final Function(String?) onPhoneChanged;
  final Function(String?) onValidateName;
  final Function(String?) onValidateEmail;
  final VoidCallback onSubmit;
  final GlobalKey<FormState> formKey;
  const CreateContactForm({
    super.key,
    required this.onNameChanged,
    required this.onEmailChanged,
    required this.onPhoneChanged,
    required this.onSubmit,
    required this.formKey,
    required this.onValidateName,
    required this.onValidateEmail,
  });

  @override
  State<CreateContactForm> createState() => _CreateContactFormState();
}

class _CreateContactFormState extends State<CreateContactForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Form(
              key: widget.formKey,
              child: SingleChildScrollView(
                child: Column(
                  spacing: 8,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Name'),
                      onChanged: widget.onNameChanged,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => widget.onValidateName(value),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Email'),
                      onChanged: widget.onEmailChanged,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) => widget.onValidateEmail(value),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Phone'),
                      onChanged: widget.onPhoneChanged,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: widget.onSubmit,
                  child: const Text('Create'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
