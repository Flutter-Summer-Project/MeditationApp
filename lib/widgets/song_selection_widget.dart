import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meditation_app/localization.dart';
import 'package:meditation_app/providers/selected_song_provider.dart';

class SongSelectionWidget extends ConsumerStatefulWidget {
  const SongSelectionWidget({super.key});

  @override
  ConsumerState<SongSelectionWidget> createState() => _SongSelectionWidgetState();
}

class _SongSelectionWidgetState extends ConsumerState<SongSelectionWidget> {
  int _selectedSongIndex = 0;

  @override
  Widget build(BuildContext context) {
      return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300),
        child: Column(
        children: [
           Text(Localization.of(context)?.translate('select_song') ?? 'Select a song:'),
          ...List.generate(
            3,
            (index) => RadioListTile<int>(
              title: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                  )
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      getButtonName(index),
                      style: const TextStyle(
                        fontSize: 20,
                      ),
                      ),
                    const SizedBox(width:8),
                    Image.asset(
                      getIconPath(index),
                      width: 50,
                      height: 50,
                    ),
                  ],
                ),
              ),
              value: index,
              groupValue: _selectedSongIndex,
              onChanged: (value) {
                setState(() {
                  _selectedSongIndex = value!;
                  ref.read(selectedSongProvider.notifier).state = getSongPath(index);
                  print(getSongPath(index));
                });
              },
              dense: true,
            ),
          ),
        ],
            ),
      );
  }

  String getButtonName(int buttonNumber) {
    final buttonNames = [Localization.of(context)?.translate('beach') ?? 'Beach', Localization.of(context)?.translate('birds') ?? 'Birds', Localization.of(context)?.translate('flute') ?? 'Flute'];
    return buttonNames[buttonNumber];
  }

  String getSongPath(int songNumber) {
    final songNames = ['sea_sound', 'birds', 'flute'];
    return "./assets/audio/${songNames[songNumber]}.mp3";
  }

  String getIconPath(int iconNumber) {
    final iconNames = ['beach_icon', 'bird_icon', 'flute_icon'];
    return "./assets/icons/${iconNames[iconNumber ]}.png";
  }
}
