import 'package:flutter_test/flutter_test.dart';
import 'package:juejin_trae_solo_guitar_flutter/models/scales.dart';

void main() {
  group('Note tests', () {
    test('Note.fromPitch should create correct note', () {
      // C4 is pitch 60
      final note = Note.fromPitch(60);
      expect(note.name, 'C');
      expect(note.octave, 4);
      expect(note.pitch, 60);
    });

    test('Note.fromName should create correct note', () {
      final note = Note.fromName('A', 4);
      expect(note.name, 'A');
      expect(note.octave, 4);
      expect(note.pitch, 69); // A4 is pitch 69
    });

    test('Note.nextHalfStep should return correct note', () {
      final note = Note.fromName('C', 4);
      final nextNote = note.nextHalfStep();
      expect(nextNote.name, 'C#');
      expect(nextNote.pitch, 61);
    });

    test('Note.previousHalfStep should return correct note', () {
      final note = Note.fromName('C', 4);
      final prevNote = note.previousHalfStep();
      expect(prevNote.name, 'B');
      expect(prevNote.octave, 3);
      expect(prevNote.pitch, 59);
    });

    test('Note.toString should return correct string', () {
      final note = Note.fromName('C', 4);
      expect(note.toString(), 'C4');
    });
  });

  group('Scale tests', () {
    test('C Major scale should have correct notes', () {
      final rootNote = Note.fromName('C', 4);
      final scale = Scale.major(rootNote);

      expect(scale.name, 'C Major');
      expect(scale.type, ScaleType.major);
      expect(scale.rootNote, rootNote);
      expect(scale.notes.length, 8); // 7 notes + root note an octave higher

      // C Major scale notes: C D E F G A B C
      expect(scale.notes[0].name, 'C');
      expect(scale.notes[1].name, 'D');
      expect(scale.notes[2].name, 'E');
      expect(scale.notes[3].name, 'F');
      expect(scale.notes[4].name, 'G');
      expect(scale.notes[5].name, 'A');
      expect(scale.notes[6].name, 'B');
      expect(scale.notes[7].name, 'C');
      expect(scale.notes[7].octave, 5);
    });

    test('G Major scale should have correct notes', () {
      final rootNote = Note.fromName('G', 4);
      final scale = Scale.major(rootNote);

      expect(scale.name, 'G Major');
      expect(scale.type, ScaleType.major);
      expect(scale.notes.length, 8);

      // G Major scale notes: G A B C D E F# G
      expect(scale.notes[0].name, 'G');
      expect(scale.notes[1].name, 'A');
      expect(scale.notes[2].name, 'B');
      expect(scale.notes[3].name, 'C');
      expect(scale.notes[4].name, 'D');
      expect(scale.notes[5].name, 'E');
      expect(scale.notes[6].name, 'F#');
      expect(scale.notes[7].name, 'G');
    });

    test('D Major scale should have correct notes', () {
      final rootNote = Note.fromName('D', 4);
      final scale = Scale.major(rootNote);

      expect(scale.name, 'D Major');
      expect(scale.type, ScaleType.major);
      expect(scale.notes.length, 8);

      // D Major scale notes: D E F# G A B C# D
      expect(scale.notes[0].name, 'D');
      expect(scale.notes[1].name, 'E');
      expect(scale.notes[2].name, 'F#');
      expect(scale.notes[3].name, 'G');
      expect(scale.notes[4].name, 'A');
      expect(scale.notes[5].name, 'B');
      expect(scale.notes[6].name, 'C#');
      expect(scale.notes[7].name, 'D');
    });

    test('C Pentatonic Major scale should have correct notes', () {
      final rootNote = Note.fromName('C', 4);
      final scale = Scale.pentatonicMajor(rootNote);

      expect(scale.name, 'C Pentatonic Major');
      expect(scale.type, ScaleType.pentatonicMajor);
      expect(scale.notes.length, 6); // 5 notes + root note an octave higher

      // C Major Pentatonic scale notes: C D E G A C
      expect(scale.notes[0].name, 'C');
      expect(scale.notes[1].name, 'D');
      expect(scale.notes[2].name, 'E');
      expect(scale.notes[3].name, 'G');
      expect(scale.notes[4].name, 'A');
      expect(scale.notes[5].name, 'C');
      expect(scale.notes[5].octave, 5);
    });

    test('G Pentatonic Major scale should have correct notes', () {
      final rootNote = Note.fromName('G', 4);
      final scale = Scale.pentatonicMajor(rootNote);

      expect(scale.name, 'G Pentatonic Major');
      expect(scale.type, ScaleType.pentatonicMajor);
      expect(scale.notes.length, 6);

      // G Major Pentatonic scale notes: G A B D E G
      expect(scale.notes[0].name, 'G');
      expect(scale.notes[1].name, 'A');
      expect(scale.notes[2].name, 'B');
      expect(scale.notes[3].name, 'D');
      expect(scale.notes[4].name, 'E');
      expect(scale.notes[5].name, 'G');
    });

    test('A Pentatonic Minor scale should have correct notes', () {
      final rootNote = Note.fromName('A', 4);
      final scale = Scale.pentatonicMinor(rootNote);

      expect(scale.name, 'A Pentatonic Minor');
      expect(scale.type, ScaleType.pentatonicMinor);
      expect(scale.notes.length, 6); // 5 notes + root note an octave higher

      // A Minor Pentatonic scale notes: A C D E G A
      expect(scale.notes[0].name, 'A');
      expect(scale.notes[1].name, 'C');
      expect(scale.notes[2].name, 'D');
      expect(scale.notes[3].name, 'E');
      expect(scale.notes[4].name, 'G');
      expect(scale.notes[5].name, 'A');
      expect(scale.notes[5].octave, 5);
    });

    test('E Pentatonic Minor scale should have correct notes', () {
      final rootNote = Note.fromName('E', 4);
      final scale = Scale.pentatonicMinor(rootNote);

      expect(scale.name, 'E Pentatonic Minor');
      expect(scale.type, ScaleType.pentatonicMinor);
      expect(scale.notes.length, 6);

      // E Minor Pentatonic scale notes: E G A B D E
      expect(scale.notes[0].name, 'E');
      expect(scale.notes[1].name, 'G');
      expect(scale.notes[2].name, 'A');
      expect(scale.notes[3].name, 'B');
      expect(scale.notes[4].name, 'D');
      expect(scale.notes[5].name, 'E');
    });

    test('D Pentatonic Minor scale should have correct notes', () {
      final rootNote = Note.fromName('D', 4);
      final scale = Scale.pentatonicMinor(rootNote);

      expect(scale.name, 'D Pentatonic Minor');
      expect(scale.type, ScaleType.pentatonicMinor);
      expect(scale.notes.length, 6);

      // D Minor Pentatonic scale notes: D F G A C D
      expect(scale.notes[0].name, 'D');
      expect(scale.notes[1].name, 'F');
      expect(scale.notes[2].name, 'G');
      expect(scale.notes[3].name, 'A');
      expect(scale.notes[4].name, 'C');
      expect(scale.notes[5].name, 'D');
    });

    test('Scale.toString should return correct string', () {
      final rootNote = Note.fromName('C', 4);
      final scale = Scale.major(rootNote);
      expect(scale.toString(), startsWith('C Major'));
    });
  });
}
