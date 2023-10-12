/*import 'package:flutter/material.dart';
import 'package:flutter_application_testingfirebase/services/crud/notes_service.dart';
import '../../services/auth/auth_service.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({Key? key}) : super(key: key);

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
  DatabaseNote? _note;
  late final NotesService _notesService;
  //to take control of the text in the text field notes
  late final TextEditingController _textController;

  @override
  void initState() {
    //ensurring that we are creating an instance of NotesService and TextEditingController
    _notesService = NotesService();
    _textController = TextEditingController();
    super.initState();
  }

  // take the current note and update in the database
  void _textControllerListener() async {
    // final text = _textController.text;
    // print(text);
    // final note = text;

    final note = _note;
    // print('_textControllerListener is Called');

    if (note == null) {
      return;
    }
    final text = _textController.text;
    // print(text);
    await _notesService.updateNote(
      note: note,
      text: text,
    );
    // Refresh the list of notes after updating.
  }

  // it first removes the listener from our text editing controller if it
  // is already added and then adds it again
  void _setupTextControllerListener() {
    print("_setupTextControllerListener is Called");
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<DatabaseNote?> createNewNote() async {
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }

    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email!;
    final owner = await _notesService.getUser(email: email);
    return await _notesService.createNote(
      owner: owner,
    );
    // Assign the new note to _note
    // _note = await _notesService.createNote(owner: owner);
    // Setup the text listener when a new note is created.
    // _setupTextControllerListener();
    //  return _note;
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      _notesService.deleteNote(id: note.id);
    }
  }

/*
  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;

    if (text.isNotEmpty) {
      if (note == null) {
        // If note is null, create a new one
        final currentUser = AuthService.firebase().currentUser!;
        final email = currentUser.email!;
        final owner = await _notesService.getUser(email: email);
        _note = await _notesService.createNote(owner: owner);

        // Setup the text listener when a new note is created.
        _setupTextControllerListener();
      }

      // Update the note with the new text
      await _notesService.updateNote(
        note: _note!,
        text: text,
      );
    }
  }
*/

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    // print('_note value in saveNoteIfTextNotEmpty is $note');

    final text = _textController.text;
    // print('calling text in save text =  $text');

    if (note != null && text.isNotEmpty) {
      await _notesService.updateNote(
        note: note,
        text: text,
      );
      // print(text);
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Note'),
      ),
      body: FutureBuilder(
        future: createNewNote(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _note = snapshot.data; // as DatabaseNote;
              //  print('_value of _note inside futureBuilder is  $_note');
              _setupTextControllerListener();
              return TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Start typing your note here...',
                ),
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

*/

import 'package:flutter/material.dart';
import '../../services/auth/auth_service.dart';
import '../../services/crud/notes_service.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({Key? key}) : super(key: key);
  @override
  _NewNoteViewState createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
  DatabaseNote? _note;
  late final NotesService _notesService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _notesService = NotesService();
    _textController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final text = _textController.text;

    print(text);
    final note = _note;
    if (note == null) {
      return;
    }

    await _notesService.updateNote(
      note: note,
      text: text,
    );
  }

  void _setupTextControllerListener() {
    // _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<DatabaseNote> createNewNote() async {
    print("Called");
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    print(currentUser);
    print("Line number 214");
    final email = currentUser.email!;
    final owner = await _notesService.getUser(email: email);
    print("Line number 216");
    print('Owner $owner');

    final db_note = await _notesService.createNote(owner: owner);

    print('Note $db_note');
    return db_note;
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      _notesService.deleteNote(id: note.id);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    if (note != null && text.isNotEmpty) {
      await _notesService.updateNote(
        note: note,
        text: text,
      );
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Note'),
      ),
      // body: const Text('Write your new note here...'),
      body: FutureBuilder(
        future: createNewNote(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _note = snapshot.data as DatabaseNote?;
              print(_note);
              _setupTextControllerListener();
              return TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Start typing your note...',
                ),
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
