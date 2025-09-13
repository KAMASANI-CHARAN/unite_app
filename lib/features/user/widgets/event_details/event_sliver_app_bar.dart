import 'package:flutter/material.dart';
import 'package:unite/features/organizer/models/event.dart';

class EventSliverAppBar extends StatelessWidget {
  final Event event;
  const EventSliverAppBar({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final String imageUrl =
        event.imageUrl ??
        'https://images.unsplash.com/photo-1501281668745-f7f57925c3b4?auto=format&fit=crop';

    return SliverAppBar(
      expandedHeight: 250.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          event.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: Offset(0, 1),
                blurRadius: 4.0,
                color: Colors.black,
              ),
            ],
          ),
        ),
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: 56.0, bottom: 16.0),
        background: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          errorBuilder:
              (context, error, stackTrace) => Container(
                color: Colors.grey,
                child: const Center(child: Icon(Icons.broken_image, size: 100)),
              ),
        ),
      ),
    );
  }
}
