import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:transparent_image/transparent_image.dart';

import '../service/api_service.dart';
import 'loading.dart';

class BeImagePicker extends StatefulWidget {
  const BeImagePicker(
      {Key? key,
      required this.onPick,
      this.preloadedImage = "",
      this.imageText = ""})
      : super(key: key);
  final Function onPick;
  final String preloadedImage;
  final String imageText;
  @override
  State<BeImagePicker> createState() => _BeImagePickerState();
}

class _BeImagePickerState extends State<BeImagePicker> {
  bool isLoading = false;

  Image? image;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          widget.imageText.isEmpty ? "Добавить изображение" : widget.imageText,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        const SizedBox(
          height: 15,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isLoading = true;
            });
            setImage();
          },
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black87), color: Colors.grey),
            child: isLoading ? const Loading() : getImage(),
          ),
        ),
      ],
    );
  }

  Widget getImage() {
    if (image != null) {
      return image!;
    } else {
      if (widget.preloadedImage.isNotEmpty) {
        return FadeInImage.memoryNetwork(
          placeholder: kTransparentImage,
          image: widget.preloadedImage,
          fit: BoxFit.cover,
        );
      }
      return const Image(
        image: AssetImage("images/noImage.png"),
      );
    }
  }

  setImage() async {
    html.File? imageFile = await ImagePickerWeb.getImageAsFile();

    if (imageFile != null) {
      APIService service = APIService();
      var imageURL = await service.uploadImage(imageFile);
      image = Image.memory(await imageFile.asBytes(),
          semanticLabel: imageFile.name);
      widget.onPick(image, imageURL);
    }
    setState(() {
      isLoading = false;
    });
  }
}

extension FileModifier on html.File {
  Future<Uint8List> asBytes() async {
    final bytesFile = Completer<List<int>>();
    final reader = html.FileReader();
    reader.onLoad.listen(
        (event) => bytesFile.complete(reader.result as FutureOr<List<int>>?));
    reader.readAsArrayBuffer(this);
    return Uint8List.fromList(await bytesFile.future);
  }
}
