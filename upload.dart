List<String> _tagItems = [
    'quam',
    'elementum',
    'pulvinar',
    'etiam',
    'non',
    'quam',
    'lacus',
    'suspendisse',
    'faucibus',
    'interdum',
    'posuere',
    'lorem',
    'ipsum',
    'dolor',
    'sit',
    'amet',
    'consectetur',
    'adipiscing',
    'elit',
    'duis',
    'tristique',
    'sollicitudin',
    'nibh',
    'sit',
    'amet',
    'commodo',
    'nulla',
    'facilisi',
    'nullam',
    'vehicula',
    'ipsum',
    'a',
    'arcu',
    'cursus',
    'vitae',
    'congue',
    'mauris',
    'rhoncus',
    'aenean',
    'vel',
  ];
          Tags(
            horizontalScroll: true,
            itemCount: _tagItems.length,
            heightHorizontalScroll: 30,
            itemBuilder: (index) => ItemTags(
              title: _tagItems[index],
              index: index,
              splashColor: Colors.grey[800],
              color: Colors.red,
              activeColor: Colors.grey[200],
              textActiveColor: Colors.black87,
              borderRadius: BorderRadius.circular(4),
              elevation: 2,//떠있는 높이. 그림자가 더 많이 나옴

            ),
          ),

      body: ListView(
        children: [
          _captionWithImage(),
          _divider,
          _sectionButton('Tag People'),
          _divider,
          _sectionButton('Add Location'),
          _tags(),
          SizedBox(height: common_s_gap,),
          _divider,
          const SectionSwitch('Facebook'),
          const SectionSwitch('Instagram'),
          const SectionSwitch('Tumblr'),
          _divider,
        ],
      ),
class SectionSwitch extends StatefulWidget {
  final String title;
  const SectionSwitch( this.title,{
    Key key,
  }) : super(key: key);

  @override
  State<SectionSwitch> createState() => _SectionSwitchState();
}

class _SectionSwitchState extends State<SectionSwitch> {
  bool checked = false;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.title,
        style: TextStyle(fontWeight: FontWeight.w400),
      ),
      trailing: CupertinoSwitch( //그냥 switch 써도 되지만 IOS 모양 쓰려면 이걸로
        value: checked,
        onChanged: (onValue){
          setState(() {
            checked = onValue;
          });
        },
      ),
      dense: true,
      contentPadding: EdgeInsets.symmetric(
        horizontal: common_gap,
      ),
    );
  }
}
File getResizedImage(File originImage){
  Image image = decodeImage(originImage.readAsBytesSync());  //오리지날 파일을 바이트로 읽어와서 Image object 로 읽음
  Image resizedImage = copyResizeCropSquare(image, 300); //사이즈 줄임 정사각형으로 만들어줌

  File resizedFile =  File(originImage.path.substring(0, originImage.path.length-3)+"jpg"); // 0 처음 부터 오른쪽에서 -3 곧 png부분 제외하고 가져와서 jpg로 변경
  resizedFile.writeAsBytesSync(encodeJpg(resizedImage, quality: 50)); //퀄리티 줄임
  return resizedFile;
}
class ImageNetworkRepository {
  Future<void> uploadImageNCreateNewPost(File originImage) async {
    try {
      final File resized = await compute(
          getResizedImage, originImage); // compute는 메소드명, 거기에 들어갈 파일? 로 전달해주면됨.
      originImage
          .length()
          .then((value) => print('original image size: $value'));
      resized.length().then((value) => print('resized image size: $value'));
    } catch (e) {}
  }
}

ImageNetworkRepository imageNetworkRepository
          FlatButton(
            onPressed: () async {
              showModalBottomSheet(
                context: context,
                builder: (_) => MyProgressIndicator(),
                //원래 빌더에 ()안에 context가 와야하는데 context를 사용 안하므로 _ 로 해준다
                isDismissible: false,
                //이 창의 바깥 눌렀을때 끝나게 해줄것이냐
                enableDrag: false, //드래그를 하게 해줄 것이냐.
              );
              await imageNetworkRepository.uploadImageNCreateNewPost(imageFile);
              Navigator.of(context).pop(); //await 되고 나면 pop으로 꺼짐짐
            },
            child: Text(
              "Share",
              textScaleFactor: 1.4,
              style: TextStyle(
                color: Colors.blue,
              ),
            ),
          ),
class ImageNetworkRepository {
  Future<void> uploadImageNCreateNewPost(File originImage) async {
    try {
      final File resized = await compute(
          getResizedImage, originImage); // compute는 메소드명, 거기에 들어갈 파일? 로 전달해주면됨.
      originImage
          .length()
          .then((value) => print('original image size: $value'));
      resized.length().then((value) => print('resized image size: $value'));
      await Future.delayed(Duration(seconds: 3,));
    } catch (e) {}
  }
}
class ImageNetworkRepository {
  Future<StorageTaskSnapshot> uploadImageNCreateNewPost(File originImage, {@required String postKey}) async {
    try {
      final File resized = await compute(
          getResizedImage, originImage); // compute는 메소드명, 거기에 들어갈 파일? 로 전달해주면됨.
      final StorageReference storageReference = FirebaseStorage().ref().child(_getImagePathByPostKey(postKey));
      final StorageUploadTask uploadTask = storageReference.putFile(resized);
      return uploadTask.onComplete;
    } catch (e) {
      print(e);
      return null;
    }
  }

  String _getImagePathByPostKey(String postKey) => 'post/$postKey/post.jpg';
}

ImageNetworkRepository imageNetworkRepository
post.dart
  Widget _postImage() {
    Widget progress = MyProgressIndicator(
      containerSize: size.width,
    );
    return FutureBuilder<dynamic>(
      future: imageNetworkRepository
          .getPostImageUrl('1637063370169_QMaZBYr2CwfIH3i8ykqLSBWG83l2'),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return CachedNetworkImage(
            //flutter의 이미지는 캐시를 안함 창이 바뀔때마다 새로 불러옴. 그래서 저장해놓은 이미지를 쓰기 위해서 이걸 씀.
            imageUrl: snapshot.data.toString(),
            placeholder: (BuildContext context, String url) {
              return progress;
            },
            imageBuilder: (BuildContext context, ImageProvider imageProvider) {
              return AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return progress;
        }
      },
    );
  }​
image_network_repository.dart
class ImageNetworkRepository {
  Future<StorageTaskSnapshot> uploadImageNCreateNewPost(File originImage, {@required String postKey}) async {
    try {
      final File resized = await compute(
          getResizedImage, originImage); // compute는 메소드명, 거기에 들어갈 파일? 로 전달해주면됨.
      final StorageReference storageReference = FirebaseStorage().ref().child(_getImagePathByPostKey(postKey));
      final StorageUploadTask uploadTask = storageReference.putFile(resized);
      return uploadTask.onComplete;
    } catch (e) {
      print(e);
      return null;
    }
  }

  String _getImagePathByPostKey(String postKey) => 'post/$postKey/post.jpg';


  Future<dynamic> getPostImageUrl(String postKey){
    return FirebaseStorage().ref().child(_getImagePathByPostKey(postKey)).getDownloadURL();
  }
}

ImageNetworkRepository imageNetworkRepository