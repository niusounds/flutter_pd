import 'dart:math';

import 'package:flutter/material.dart';

const name = 'Fluttone';
const rows = 16;
const cols = 5;

// String assetForNote(int n) => 'sound/note$n.ogg';

class Fluttone extends StatefulWidget {
  @override
  State<Fluttone> createState() => _FluttoneState();
}

class _FluttoneState extends State<Fluttone>
    with SingleTickerProviderStateMixin {
  late List<List<bool>> _notes;
  late AnimationController _anim;
  int _beat = 0;
  bool get _playing => _anim.isAnimating;

  @override
  void initState() {
    super.initState();

    _anim = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _anim.addListener(() {
      setState(() {
        _beat = (_anim.value * rows).floor();
      });
    });

    _randomize();
  }

  void _randomize() => _notes = List.generate(
      rows, (i) => List.generate(cols, (i) => Random().nextInt(i + 2) < 1));

  void _clear() =>
      _notes = List.generate(rows, (i) => List.filled(cols, false));

  void _playPause() {
    if (_playing) {
      _anim.stop();
      _anim.reset();
    } else {
      _anim.repeat();
    }
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(name),
        actions: <Widget>[
          IconButton(
            tooltip: 'Random',
            onPressed: () => setState(_randomize),
            icon: Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: 'Clear',
            onPressed: () => setState(_clear),
            icon: Icon(Icons.delete),
          ),
          IconButton(
            tooltip: _playing ? 'Pause' : 'Play',
            onPressed: () => setState(_playPause),
            icon: Icon(_playing ? Icons.pause : Icons.play_arrow),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: GridView.builder(
              reverse: true,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 4 / 5,
                crossAxisCount: rows,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4,
              ),
              itemCount: rows * cols,
              itemBuilder: _buildBox,
            ),
          ),
          Bar(beat: _anim.value * rows),
        ],
      ),
    );
  }

  Widget _buildBox(BuildContext context, int i) {
    int beat = i % rows;
    int note = i ~/ rows;
    bool enable = _notes[beat][note];
    return Box(
      enable: enable,
      noteOn: enable && _playing && beat == _beat,
      onTap: () => setState(() => _toggle(beat, note)),
      onPlay: () => _play(note + 1),
    );
  }

  void _toggle(int beat, int note) {
    _notes[beat][note] = !_notes[beat][note];
  }

  _play(int note) async {
    // int id = await audioEngine.createSoundObject(assetForNote(note));
    // audioEngine.playSound(id);
  }
}

class Bar extends StatelessWidget {
  final double beat;

  const Bar({
    Key? key,
    required this.beat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: beat / rows * MediaQuery.of(context).size.width),
      child: SizedBox(
        width: 4,
        child: Container(decoration: BoxDecoration(color: Colors.black)),
      ),
    );
  }
}

class Box extends StatefulWidget {
  final bool enable;
  final bool noteOn;
  final VoidCallback onTap;
  final VoidCallback onPlay;

  const Box({
    Key? key,
    required this.enable,
    required this.noteOn,
    required this.onTap,
    required this.onPlay,
  }) : super(key: key);

  @override
  State<Box> createState() => _BoxState();
}

class _BoxState extends State<Box> {
  @override
  void didUpdateWidget(Box oldWidget) {
    if (!oldWidget.noteOn && widget.noteOn) {
      widget.onPlay();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: _color,
        ),
        margin: EdgeInsets.all(widget.noteOn ? 2 : 4),
      ),
    );
  }

  Color get _color => widget.enable
      ? widget.noteOn
          ? Colors.yellowAccent
          : Colors.green
      : Colors.white;
}
