import 'package:flutter/material.dart';
import 'package:myapp/service/petService.dart';
class Showpet extends StatefulWidget {
  const Showpet({super.key, required this.image, required this.exp});
  final String image;
  final int exp;

  @override
  State<Showpet> createState() => _ShowpetState();
}

class _ShowpetState extends State<Showpet> {
  PetService ps = PetService();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future:  ps.getImage(widget.image, widget.exp),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.hasData){
            return Image.network(
              snapshot.data,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Column(
                    children: [
                      Icon(Icons.error_outline, color: Colors.grey, size: 50),
                      Text("No Image"),
                    ],
                  ),
                );
              },
            );
          }
          return Text("loading...");
        }
    );
  }
}
