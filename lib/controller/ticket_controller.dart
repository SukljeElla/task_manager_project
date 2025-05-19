import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_project/model/ticket.dart';

class TicketController {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createTicket(String text) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) throw Exception("User not logged in.");

      DatabaseReference ticketRef = _database.child("tickets").push();

      Ticket newTicket = Ticket(
        id: ticketRef.key ?? "",
        text: text,
        createdAt: DateTime.now(),
        authorId: user.uid,
        authorName: user.displayName ?? "Unknown User",
      );

      await ticketRef.set(newTicket.toJson());
      print("Ticket created successfully!");
    } catch (e) {
      print("Error creating ticket: $e");
      rethrow;
    }
  }

  Future<List<Ticket>> getAllTickets() async {
    try {
      DatabaseEvent event = await _database.child("tickets").once();
      List<Ticket> tickets = [];

      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> ticketData =
            event.snapshot.value as Map<dynamic, dynamic>;

        ticketData.forEach((key, value) {
          try {
            tickets.add(Ticket.fromJson(Map<String, dynamic>.from(value)));
          } catch (e) {
            print("Error parsing ticket: $e");
          }
        });
      }
      return tickets;
    } catch (e) {
      print("Error fetching tickets: $e");
      return [];
    }
  }

  Future<void> deleteTicket(String ticketId) async {
    try {
      await _database.child("tickets/$ticketId").remove();
      print("Ticket deleted successfully!");
    } catch (e) {
      print("Error deleting ticket: $e");
      rethrow;
    }
  }

  Future<void> updateTicket(String ticketId, String newText) async {
    try {
      await _database.child("tickets/$ticketId/text").set(newText);
      print("Ticket updated successfully!");
    } catch (e) {
      print("Error updating ticket: $e");
      rethrow;
    }
  }
}
