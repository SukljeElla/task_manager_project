import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_project/controller/ticket_controller.dart';
import 'package:task_manager_project/model/ticket.dart';
import 'package:task_manager_project/controller/user_controller.dart';

class AdminTicketsView extends StatefulWidget {
  const AdminTicketsView({Key? key}) : super(key: key);

  @override
  _AdminTicketsViewState createState() => _AdminTicketsViewState();
}

class _AdminTicketsViewState extends State<AdminTicketsView> {
  final TicketController _ticketController = TicketController();
  List<Ticket> _tickets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  Future<void> _loadTickets() async {
    List<Ticket> tickets = await _ticketController.getAllTickets();
    setState(() {
      _tickets = tickets;
      _isLoading = false;
    });
  }

  Future<void> _deleteTicket(String ticketId) async {
    bool confirmDelete = await _showConfirmDialog();
    if (confirmDelete) {
      await _ticketController.deleteTicket(ticketId);
      _loadTickets();
    }
  }

  Future<bool> _showConfirmDialog() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Ticket"),
        content: const Text(
          "Are you sure you want to delete this ticket? This action cannot be undone.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
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
          "Manage Tickets",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(175, 8, 71, 87),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 86, 174, 201), Color(0xFF23233B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _tickets.isEmpty
                  ? const Center(
                      child: Text(
                        "No tickets found",
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _tickets.length,
                      padding: const EdgeInsets.all(10),
                      itemBuilder: (context, index) {
                        Ticket ticket = _tickets[index];
                        return Card(
                          color: Colors.white.withOpacity(0.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            leading: CircleAvatar(
                              backgroundColor:
                                  const Color.fromARGB(255, 30, 146, 176),
                              child: Text(
                                ticket.authorName[0].toUpperCase(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text(
                              ticket.text,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "User ID: ${ticket.authorId.hashCode}",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Created: ${_formatDate(ticket.createdAt)}",
                                  style: const TextStyle(
                                      color:
                                          Color.fromARGB(255, 195, 215, 222)),
                                ),
                                const SizedBox(height: 5),
                                Text("Ticket ID: ${ticket.id.hashCode}",
                                    style: const TextStyle(
                                        color:
                                            Color.fromARGB(54, 255, 255, 255))),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Color.fromARGB(236, 255, 255, 255)),
                              onPressed: () => _deleteTicket(ticket.id),
                            ),
                          ),
                        );
                      },
                    ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}  ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }
}
