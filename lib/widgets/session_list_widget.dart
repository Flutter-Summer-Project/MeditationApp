import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:meditation_app/localization.dart';
import 'package:meditation_app/boxes.dart';


class SessionListWidget extends ConsumerStatefulWidget {
  const SessionListWidget({super.key});

  @override
  ConsumerState<SessionListWidget> createState() => _SessionListWidgetState();
}

class _SessionListWidgetState extends ConsumerState<SessionListWidget> {

  @override
  Widget build(BuildContext context) {
     const int sessionsDisplayed = 3;
        return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      
      child: ValueListenableBuilder(
        valueListenable: sessionsBox.listenable(),
        builder: (context, Box<String> box, widget) {
          List<String> sessions = box.values.toList();

          if (sessions.length > sessionsDisplayed) {
            sessions = sessions.reversed.take(sessionsDisplayed).toList().reversed.toList();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (sessions.isNotEmpty) 
                 Text(
                Localization.of(context)?.translate('session_list') ?? 'Session list',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              
              const SizedBox(height: 10),

              ListView.builder(
                shrinkWrap: true,
                itemCount: sessions.length >= sessionsDisplayed ? sessionsDisplayed : sessions.length,
                itemExtent: 95,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.all(3),
                    constraints: const BoxConstraints.tightFor(
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[300]
                  ),
                    child: Center(child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        sessions[index]
                        ),
                    ),
                    )
                  );
                }
                
              ),

            ],
          );
        },
      ),
    );
  }
}
