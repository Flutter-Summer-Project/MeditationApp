import 'package:meditation_app/session.dart';
import 'package:meditation_app/widgets/session_overview_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/providers/selected_session_provider.dart';
import 'package:meditation_app/localization.dart';

class SessionDurationForm extends ConsumerStatefulWidget {
  @override
  ConsumerState<SessionDurationForm> createState() => _SessionDurationFormState();
}

class _SessionDurationFormState extends ConsumerState<SessionDurationForm> {
  final _formKey = GlobalKey<FormState>();
  int _minutes = 0;
  int _seconds = 10;
  int _repetitions = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: sessionPreferences(),
        ),
      ),
    );
  }

  Row sessionPreferences() {
    return Row(
      children: [
        Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(Localization.of(context)?.translate('time_of_phase') ?? 'Time of a phase'),
                  periodDuration(),
                  Flexible(
                    flex: 1,
                    child: repetitionsForm(),
                  ),
                    const SizedBox(width: 10),
                    submitButton(),
                  ],
              ),
            ),
      ],
    );
  }

  TextFormField repetitionsForm() {
    return TextFormField(
      initialValue: '3',
      decoration:  InputDecoration(
        labelText: Localization.of(context)?.translate('repetitions') ?? 'Number of repetitions',
      ),
      keyboardType: TextInputType.number,
      onChanged: (value) {
        setState(() {
          _repetitions = int.parse(value);
        });
      },
    );
  }

  Padding submitButton() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: ElevatedButton(
        onPressed: () {
          
          if (_formKey.currentState?.validate() == true) {
            Session session = Session(
              Duration(minutes: _minutes, seconds: _seconds) * 2, // 2 phases in a period
              _repetitions,
            );

            ref.read(selectedSessionNotifierProvider.notifier).setSession(session);

            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title:  Text(Localization.of(context)?.translate('session_overview') ?? 'Session overview'),
                    content: const SessionOverviewWidget(),
                    actions: [
                      TextButton(
                        child:  Text(Localization.of(context)?.translate('back') ?? 'Back'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
          }
        },
        child:  Text(Localization.of(context)?.translate('submit') ?? 'Submit'),
      ),
    );
  }

  Padding periodDuration() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 1,
            child: minutesForm(),
          ),
          const SizedBox(width: 10),
          Flexible(
            flex: 1,
            child: secondsForm(),
          ),
      ]
      ),
    );
  }

  TextFormField secondsForm() {
    return TextFormField(
      initialValue: '10',
      decoration:  InputDecoration(  
        labelText: Localization.of(context)?.translate('seconds') ?? 'Seconds',
      ),
      keyboardType: TextInputType.number,
      onChanged: (value) {
        setState(() {
          _seconds = int.parse(value);
        });
      },
    );
  }

  TextFormField minutesForm() {
    return TextFormField(
      initialValue: '0',
      decoration:  InputDecoration(
        labelText: Localization.of(context)?.translate('minutes') ?? 'Minutes',
      ),
      keyboardType: TextInputType.number,
      onChanged: (value) {
        setState(() {
          _minutes = int.parse(value);
        });
      },
    );
  }
}