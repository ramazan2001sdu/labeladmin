import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker_web/image_picker_web.dart';

import '../service/api_service.dart';

class BeVideoPicker extends StatefulWidget {
  const BeVideoPicker({Key? key, required this.onPick}) : super(key: key);

  final Function onPick;

  @override
  State<BeVideoPicker> createState() => _BeVideoPickerState();
}

class _BeVideoPickerState extends State<BeVideoPicker> {
  bool isLoading = false;
  String fileLink = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Select Video",
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
            setVideo();
          },
          child: isLoading
              ? const SpinKitWave(
                  color: Color(0x80808080),
                  size: 40,
                )
              : Container(
                  width: 400,
                  decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.black)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                        fileLink.isNotEmpty ? fileLink : "Click here to select video!",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.ubuntu(fontSize: 16, fontWeight: FontWeight.normal),
                      ),
                    ),
                  )),
        ),
      ],
    );
  }

  setVideo() async {
    html.File? videoFile = await ImagePickerWeb.getVideoAsFile();

    if (videoFile != null) {
      APIService service = APIService();
      var imageURL = await service.uploadVideo(videoFile);
      fileLink = imageURL;
      widget.onPick(imageURL);
    }
    setState(() {
      isLoading = false;
    });
  }
}
