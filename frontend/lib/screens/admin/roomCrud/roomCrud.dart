import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class RoomCrud extends StatelessWidget {
  const RoomCrud({super.key});

  @override
  Widget build(BuildContext context) {
    return RoomCrudPage();
  }
}

class RoomCrudPage extends StatefulWidget {
  const RoomCrudPage({super.key});

  @override
  State<RoomCrudPage> createState() => _RoomCrudPageState();
}

class _RoomCrudPageState extends State<RoomCrudPage> {
  File? _image;

  Future getImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      // final imageTemporary = File(image.path);
      final imagePermanent = await saveFilePermanently(image.path);

      setState(() {
        this._image = imagePermanent;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<File> saveFilePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'OpenSans'),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 55, 154, 255),
          title: Text('Room CRUD'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 40),
              _image != null
                  ? Image.file(
                      _image!,
                      width: 250,
                      height: 250,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      'https://cf.bstatic.com/xdata/images/hotel/max1024x768/194624742.jpg?k=12804e9c2e1f8764ed2fdc14ccbee39542aaeb301f9feaab00547498d0d8a41a&o=&hp=1'),
              SizedBox(height: 40),
              CustomButton(
                title: 'Pick from Gallery',
                icon: Icons.image_outlined,
                onClick: () => getImage(ImageSource.gallery),
              ),
              CustomButton(
                title: 'Pick from Camera',
                icon: Icons.camera,
                onClick: () => getImage(ImageSource.camera),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

CustomButton({
  required String title,
  required IconData icon,
  required VoidCallback onClick,
}) {
  return Container(
    width: 280,
    child: ElevatedButton(
      onPressed: () {},
      child: Row(
        children: [
          Icon(Icons.image_outlined),
          SizedBox(width: 20),
          Text("Pick an image"),
        ],
      ),
    ),
  );
}
