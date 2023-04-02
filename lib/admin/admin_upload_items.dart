import 'dart:convert';
import 'dart:io';

import 'package:boat_shop/admin/admin_login.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../api_connection/api_connection.dart';


class AdminUploadItemsScreen extends StatefulWidget
{

  @override
  State<AdminUploadItemsScreen> createState() => _AdminUploadItemsScreenState();
}

class _AdminUploadItemsScreenState extends State<AdminUploadItemsScreen>
{
  final ImagePicker _picker =ImagePicker();
  XFile? pickedImageXFile;

  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var ratingController = TextEditingController();
  var tagsController = TextEditingController();
  var priceController = TextEditingController();
  var sizesController = TextEditingController();
  var colorsController = TextEditingController();
  var descriptionController = TextEditingController();
  var imageLink = "";


  //defaultScreen methods
  captureImageWithPhoneCamera() async
  {
  pickedImageXFile = await _picker.pickImage(source: ImageSource.camera);
  Get.back();
  setState(() =>pickedImageXFile);
  }

  pickImageFromPhoneGallery() async
  {
    pickedImageXFile = await _picker.pickImage(source: ImageSource.gallery);
    Get.back();
    setState(() =>pickedImageXFile);
  }

  showDialogBoxForImagePickingAndCapturing(){
    return showDialog(
      context:context,
    builder: (context){
        return SimpleDialog(
          backgroundColor: Colors.black87,
          title: const Text(
            "Item Image",
            style: TextStyle(
              color:Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            SimpleDialogOption(
              onPressed: (){
                captureImageWithPhoneCamera();
              },
              child: const Text(
                "Capture with phone camera",
                style: TextStyle(
                  color:Colors.grey,
                ),

              ),
            ),
            SimpleDialogOption(
              onPressed: (){
                pickImageFromPhoneGallery();
              },
              child: const Text(
                "Pick image from phone gallery",
                style: TextStyle(
                  color:Colors.grey,
                ),

              ),
            ),
            SimpleDialogOption(
              onPressed: (){
                Get.back();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(
                  color:Colors.red,
                ),

              ),
            ),
          ],
        );
    }
    );
  }
//defaultScreen methods ends



  Widget defaultScreen()
  {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black54,
                Colors.lightBlue,
              ],
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        title:const Text(
            'Welcome Admin'
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black54,
              Colors.lightBlue,
            ],
          ),
        ),
        child:Center(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              const Icon(
                Icons.add_photo_alternate,
                color:Colors.white54,
                size: 200,
              ),
              Material(
                color:Colors.blueAccent,
                borderRadius: BorderRadius.circular(30),
                child:InkWell(
                  onTap: (){
                    showDialogBoxForImagePickingAndCapturing();
                  },
                  borderRadius: BorderRadius.circular(30),
                  child:const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 28,
                    ),
                    child:Text(
                      "Add New Item",
                      style:TextStyle(
                        color:Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

              ),
            ],
          ),
        ),


      ),
    );
  }

//uploadItemFormScreen methods

  uploadItemImage() async
  {
    var requestImgurApi =http.MultipartRequest(
      "POST",
      Uri.parse("https://api.imgur.com/3/image")
    );
    String imageName=DateTime.now().microsecondsSinceEpoch.toString();
    requestImgurApi.fields['title'] = imageName;
    requestImgurApi.headers['Authorization']="Client-ID " + "358209b2539ce7a";

    var imageFile = await http.MultipartFile.fromPath(
      'image',
      pickedImageXFile!.path,
      filename: imageName,
    );

    requestImgurApi.files.add(imageFile);
    var responseFromImgurApi = await requestImgurApi.send();

    var responseDataFromImgurApi = await responseFromImgurApi.stream.toBytes();
    var resultFromImgurApi = String.fromCharCodes(responseDataFromImgurApi);

    Map<String, dynamic> jsonRes = json.decode(resultFromImgurApi);
    imageLink = (jsonRes["data"]["link"]).toString();
    String deleteHash = (jsonRes["data"]["deletehash"]).toString();

    saveItemInfoToDatabase();

  }

  saveItemInfoToDatabase() async
  {
    List<String> tagsList = tagsController.text.split(',');
    List<String> sizesList = sizesController.text.split(',');
    List<String> colorsList = colorsController.text.split(',');

    try
    {
      var response = await http.post(
        Uri.parse(API.uploadNewBoat),
        body:
        {
          'item_id': '1',
          'name': nameController.text.trim().toString(),
          'rating': ratingController.text.trim().toString(),
          'tags': tagsList.toString(),
          'price': priceController.text.trim().toString(),
          'sizes': sizesList.toString(),
          'colors': colorsList.toString(),
          'description': descriptionController.text.trim().toString(),
          'image': imageLink.toString(),
        },
      );

      if(response.statusCode == 200)
      {
        var resBodyOfUploadItem = jsonDecode(response.body);

        if(resBodyOfUploadItem['success'] == true)
        {
          Fluttertoast.showToast(msg: "New item uploaded successfully");

          setState(() {
            pickedImageXFile=null;
            nameController.clear();
            ratingController.clear();
            tagsController.clear();
            priceController.clear();
            sizesController.clear();
            colorsController.clear();
            descriptionController.clear();
          });

          Get.to(AdminUploadItemsScreen());
        }
        else
        {
          Fluttertoast.showToast(msg: "Item not uploaded. Error, Try Again.");
        }
      }
      else
      {
        Fluttertoast.showToast(msg: "Status is not 200");
      }
    }
    catch(errorMsg)
    {
      print("Error:: " + errorMsg.toString());
    }
  }
  //uploadItemFormScreen ends methods


  Widget uploadItemsFormScreen()
  {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black54,
                Colors.lightBlue,
              ],
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        title: const Text(
          "Upload Form"
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: (){
            setState(() =>pickedImageXFile=null);
            Get.to(AdminUploadItemsScreen());
            setState(() {
              pickedImageXFile=null;
              nameController.clear();
              ratingController.clear();
              tagsController.clear();
              priceController.clear();
              sizesController.clear();
              colorsController.clear();
              descriptionController.clear();
            });

          },
          icon: const Icon(
            Icons.clear,
          ),
        ),
        actions: [
          TextButton(
            onPressed: (){
              Fluttertoast.showToast(msg: "Uploading now...");
              uploadItemImage();
            },
            child:const Text(
              "Done",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          Container(
            height: MediaQuery.of(context).size.height *0.4,
            width: MediaQuery.of(context).size.width *0.8,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(
                  File(pickedImageXFile!.path),
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          //login screen sign in form
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration:const BoxDecoration(
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.all(
                  Radius.circular(60),
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    color: Colors.black26,
                    offset: Offset(0,-3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(30,30,30,8),
                child: Column(
                  children: [
                    //email-password-login button
                    Form(
                        key: formKey,
                        child:Column(
                          children: [
                            //Boat name
                            TextFormField(
                              controller: nameController,
                              validator: (val) => val == "" ? "Please write boat name" : null,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.title,
                                  color:Colors.black,
                                ),
                                hintText: "Boat name...",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  ),
                                ),
                                enabledBorder:OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  ),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                fillColor: Colors.white,
                                filled: true,
                              ),
                            ),

                            const SizedBox(height:18,),

                                //boat ratings
                            TextFormField(
                              controller: ratingController,
                              validator: (val) => val == "" ? "Please give boat rating" : null,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.rate_review,
                                  color:Colors.black,
                                ),
                                hintText: "Boat rating...",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  ),
                                ),
                                enabledBorder:OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  ),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                fillColor: Colors.white,
                                filled: true,
                              ),
                            ),
                            const SizedBox(height:18,),

                            //boat tags
                            TextFormField(
                              controller: tagsController,
                              validator: (val) => val == "" ? "Please write boat tags" : null,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.tag,
                                  color:Colors.black,
                                ),
                                hintText: "Boat tag...",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  ),
                                ),
                                enabledBorder:OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  ),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                fillColor: Colors.white,
                                filled: true,
                              ),
                            ),
                            const SizedBox(height:18,),

                            //boat price
                            TextFormField(
                              controller: priceController,
                              validator: (val) => val == "" ? "Please give boat price" : null,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.price_change_outlined,
                                  color:Colors.black,
                                ),
                                hintText: "Boat price...",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  ),
                                ),
                                enabledBorder:OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  ),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                fillColor: Colors.white,
                                filled: true,
                              ),
                            ),
                            const SizedBox(height:18,),

                            //boat sizes
                            TextFormField(
                              controller: sizesController,
                              validator: (val) => val == "" ? "Please write boat size" : null,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.picture_in_picture,
                                  color:Colors.black,
                                ),
                                hintText: "Boat size...",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  ),
                                ),
                                enabledBorder:OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  ),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                fillColor: Colors.white,
                                filled: true,
                              ),
                            ),
                            const SizedBox(height:18,),

                            //boat color
                            TextFormField(
                              controller: colorsController,
                              validator: (val) => val == "" ? "Please write boat color" : null,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.color_lens,
                                  color:Colors.black,
                                ),
                                hintText: "Boat colors...",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  ),
                                ),
                                enabledBorder:OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  ),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                fillColor: Colors.white,
                                filled: true,
                              ),
                            ),
                            const SizedBox(height:18,),

                            //boat description
                            TextFormField(
                              controller: descriptionController,
                              validator: (val) => val == "" ? "Please write boat description" : null,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.description,
                                  color:Colors.black,
                                ),
                                hintText: "Boat Description...",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  ),
                                ),
                                enabledBorder:OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  ),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: const BorderSide(
                                    color:Colors.white60,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                fillColor: Colors.white,
                                filled: true,
                              ),
                            ),

                            const SizedBox(height:18,),
                            //button
                            Material(
                              color:Colors.black,
                              borderRadius: BorderRadius.circular(30),
                              child:InkWell(
                                onTap: (){
                                  if(formKey.currentState!.validate())
                                  {
                                    Fluttertoast.showToast(msg: "Uploading now...");
                                    uploadItemImage();
                                  }
                                },
                                borderRadius: BorderRadius.circular(30),
                                child:const Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 28,
                                  ),
                                  child:Text(
                                    "Upload Now",
                                    style:TextStyle(
                                      color:Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),

                            ),
                          ],
                        )
                    ),

                    const SizedBox(
                      height: 16,
                    ),







                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return pickedImageXFile==null ? defaultScreen() : uploadItemsFormScreen();
  }
}
