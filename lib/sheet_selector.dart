import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:googleapis/drive/v3.dart';

class SheetSelector extends StatefulWidget {
  SheetSelector({Key? key, required this.googleSignIn, required this.driveApi})
      : super(key: key);

  final GoogleSignIn googleSignIn;
  final DriveApi driveApi;

  @override
  State<SheetSelector> createState() => _SheetSelector();
}

class _SheetSelector extends State<SheetSelector> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _folderType = "application/vnd.google-apps.folder";
  final _sheetType = "application/vnd.google-apps.spreadsheet";
  int _selectedIndex = 0;
  bool _filesLoaded = false;
  var _listOfFiles;

  late SearchBar searchBar = SearchBar(
      hintText: '[DEFC] Asistencia',
      inBar: false,
      buildDefaultAppBar: buildAppBar,
      setState: setState,
      onSubmitted: onSubmitted,
      onCleared: () {},
      onClosed: () {});

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
      title: Text('Google Drive'),
      actions: [searchBar.getSearchAction(context)],
    );
  }

  void onSubmitted(String value) async {
    print(value);
  }

  Future<void> showFiles(context) async {
    var query = '';
    if (_selectedIndex == 0) {
      query =
          "trashed = false and 'root' in parents and (mimeType = '$_folderType' or mimeType = '$_sheetType')";
    } else {
      query =
          "trashed = false and sharedWithMe and (mimeType = '$_folderType' or mimeType = '$_sheetType')";
    }
    var list = await widget.driveApi.files.list(
        supportsAllDrives: true,
        includeItemsFromAllDrives: true,
        spaces: 'drive',
        q: query);
    _listOfFiles = ListView.builder(
      itemCount: list.files!.length,
      itemBuilder: (context, index) {
        final isFolder = list.files![index].mimeType == _folderType;
        return ListTile(
            leading: Icon(
                isFolder ? Icons.folder : Icons.insert_drive_file_outlined),
            title: Text(list.files![index].name ?? 'Sin nombre'));
      },
    );

    if (!mounted) return;
    setState(() => _filesLoaded = true);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _listOfFiles = null;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle optionStyle =
        TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
    List<Widget> _widgetOptions = <Widget>[
      _listOfFiles ?? Center(child: Text('Cargando archivos...')),
      _listOfFiles ?? Center(child: Text('Cargando archivos...')),
    ];

    var screen = Scaffold(
      appBar: searchBar.build(context),
      key: _scaffoldKey,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.drive_folder_upload_outlined),
            label: 'Mi unidad',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_shared_outlined),
            label: 'Compartido conmigo',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightBlue[300],
        onTap: _onItemTapped,
      ),
    );
    if (_filesLoaded) {
      _filesLoaded = false;
    } else {
      showFiles(context);
    }
    return screen;
  }
}
