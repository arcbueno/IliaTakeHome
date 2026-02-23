import 'package:ilia_contacts/core/models/contact_model.dart';
import 'package:flutter/material.dart';
import 'package:ilia_contacts/core/utils/command.dart';
import 'package:ilia_contacts/core/utils/result.dart';

class ContactListItem extends StatefulWidget {
  final Future<Result<void>> Function(String) deleteContact;
  final ContactModel contact;
  const ContactListItem({
    super.key,
    required this.deleteContact,
    required this.contact,
  });

  @override
  State<ContactListItem> createState() => _ContactListItemState();
}

class _ContactListItemState extends State<ContactListItem> {
  // Command to handle contact deletion
  late final deleteContactCommand = Command1(widget.deleteContact);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.contact.name),
      subtitle: Text(widget.contact.email),
      trailing: ListenableBuilder(
        listenable: deleteContactCommand,
        builder: (context, child) {
          if (deleteContactCommand.completed) {
            final result = deleteContactCommand.result;
            if (result != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                result.fold(
                  onOk: (_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Contact deleted successfully'),
                      ),
                    );
                  },
                  onError: (error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to delete contact: $error'),
                      ),
                    );
                  },
                );
                deleteContactCommand.clearResult();
              });
            }
          }
          return deleteContactCommand.running
              ? SizedBox(
                  height: 24,
                  width: 24,
                  child: const CircularProgressIndicator(),
                )
              : child!;
        },
        child: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => deleteContactCommand.execute(widget.contact.id),
        ),
      ),
    );
  }
}
