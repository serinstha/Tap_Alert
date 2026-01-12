import 'package:college_project/applications/permission_utils/contact_permission.dart';
import 'package:college_project/contact/contact_repository/contact_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class EmergencyContactPage extends StatefulWidget {
  final String uid;
  const EmergencyContactPage({super.key, required this.uid});

  @override
  State<EmergencyContactPage> createState() => _EmergencyContactPageState();
}

class _EmergencyContactPageState extends State<EmergencyContactPage> {
  final perm = PermissionService();
  final repo = ContactRepository();

  List<Map<String, dynamic>> contacts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initContactStream();
  }

  void _initContactStream() {
    repo
        .streamContacts(widget.uid)
        .listen(
          (list) {
            if (mounted) {
              setState(() {
                contacts = list;
                isLoading = false;
              });
            }
          },
          onError: (error) {
            if (mounted) {
              setState(() => isLoading = false);
              _showSnackBar(
                'Error loading contacts: $error',
                backgroundColor: Colors.redAccent,
              );
            }
          },
        );
  }

  void _showSnackBar(String message, {Color? backgroundColor}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> pickAndSave() async {
    try {
      // Request permission
      if (!await perm.requestContactPermission()) {
        _showSnackBar(
          'Contact access denied. Please enable in settings.',
          backgroundColor: Colors.orange[700],
        );
        return;
      }

      // Open system contact picker
      final selected = await FlutterContacts.openExternalPick();

      if (selected != null) {
        // Show loading
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 16),
                  Text('Saving contact...'),
                ],
              ),
              duration: Duration(seconds: 2),
            ),
          );
        }

        // Get full contact details
        final full = await FlutterContacts.getContact(
          selected.id,
          withProperties: true,
        );

        if (full != null) {
          await repo.saveContact(uid: widget.uid, contact: full);
          _showSnackBar(
            'Contact saved successfully',
            backgroundColor: Colors.green[700],
          );
        }
      }
    } catch (e) {
      _showSnackBar(
        'Error saving contact: $e',
        backgroundColor: Colors.redAccent,
      );
    }
  }

  Future<void> deleteOne(String id, String name) async {
    try {
      await repo.deleteContact(widget.uid, id);
      _showSnackBar(
        '$name deleted successfully',
        backgroundColor: Colors.green[700],
      );
    } catch (e) {
      _showSnackBar(
        'Error deleting contact: $e',
        backgroundColor: Colors.redAccent,
      );
    }
  }

  Future<bool?> _showDeleteDialog(String name) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Delete Contact?'),
        content: Text('Are you sure you want to delete $name?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget buildContactCard(Map<String, dynamic> c) {
    final name = c['name'] ?? 'No Name';
    final phone = c['P_number'] ?? 'No Phone Number';
    final photo = c['photo'];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: Colors.indigo[100],
          backgroundImage: photo != null ? MemoryImage(photo) : null,
          child: photo == null
              ? Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                )
              : null,
        ),
        title: Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            phone,
            style: TextStyle(color: Colors.grey[700], fontSize: 15),
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red[400]),
          tooltip: 'Delete contact',
          onPressed: () async {
            final confirmed = await _showDeleteDialog(name);
            if (confirmed == true && mounted) {
              deleteOne(c['id'], name);
            }
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.contact_phone_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No Emergency Contacts',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button below to add\nemergency contacts',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Emergency Contacts',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : contacts.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: contacts.length,
              itemBuilder: (_, i) => buildContactCard(contacts[i]),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: pickAndSave,
        backgroundColor: Colors.indigo[300],
        tooltip: 'Add Contact',
        child: const Icon(Icons.add),
      ),
    );
  }
}
