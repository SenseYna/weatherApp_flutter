import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutPage extends StatelessWidget {
  @override
  String titleMembers = '     MEMBERS';
  String titleIntroduce = '     INTRODUCE';
  Widget build(BuildContext context) {
    return new ListView(
      shrinkWrap: true,
      children: <Widget>[
        Container(
          color: Colors.white,
          height: 5000.0,
          width: 500.0,
          //  decoration: new BoxDecoration(
          //           color: Colors.white,
          //           borderRadius: BorderRadius.circular(20.0),
          //           boxShadow: [
          //             BoxShadow(blurRadius: 2.0, color: Colors.grey)
          //           ]),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0.0),
                decoration: new BoxDecoration(
                    color: Colors.blue[300],
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(blurRadius: 2.0, color: Colors.grey)
                    ]),
                child: Column(
                  children: <Widget>[
                    new ExpansionTile(
                      title: new Text(this.titleIntroduce,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )),
                      backgroundColor:
                          Theme.of(context).accentColor.withOpacity(0.025),
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Container(
                              alignment: Alignment(0.0, -1.0), //-0.40
                              margin:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              height: 310.0,
                              width: 350.0,
                              decoration: new BoxDecoration(
                                color: Colors.blue[300],
                                //borderRadius: BorderRadius.circular(20.0),
                                // boxShadow: [
                                //   BoxShadow(
                                //       blurRadius: 2.0,
                                //       color: Colors.grey[100])
                                // ]
                              ),
                              child: Text(
                                'Ứng dụng "tên app" (weather/nhietdo....) là sản phẩm của đề tài nghiên cứu khoa học “Ứng dụng công cụ Smartphone trong giám sát và dự báo sự thay đổi nhiệt độ tại Thành phố Hồ Chí Minh.”\n\n'
                                'Ứng dụng được tạo ra nhằm giám sát sự thay đổi nhiệt độ và chỉ số tia UV, bên cạnh đó đưa ra dự báo về nhiệt độ cũng như đánh giá mức độ rủi ro từ chỉ số tia UV tại Thành phố Hồ Chí Minh và các vùng lân cận bằng những cách thức đơn giản nhất để người dùng dễ dàng tiếp cận.\n\n'
                                'Từ ứng dụng này, chúng tôi hy vọng mang đến cho người dùng những trải nghiệm mới về ứng dụng giám sát và dự báo nhiệt độ, từ đó người dùng có thể đưa ra những biện pháp bảo vệ trước những biến đổi của môi trường hiện nay.\n'
                                '\n',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  //fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
                decoration: new BoxDecoration(
                    color: Colors.blue[300],
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(blurRadius: 2.0, color: Colors.grey)
                    ]),
                child: Column(
                  children: <Widget>[
                    new ExpansionTile(
                      title: new Text(this.titleMembers,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          )),
                      backgroundColor:
                          Theme.of(context).accentColor.withOpacity(0.025),
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Container(
                              alignment: Alignment(0.0, 0.0), //-0.40
                              height: 550.0,
                              decoration: new BoxDecoration(
                                //color: Colors.blue[300],
                                borderRadius: BorderRadius.circular(20.0),
                                // boxShadow: [
                                //   BoxShadow(
                                //       blurRadius: 2.0,
                                //       color: Colors.grey[100])
                                // ]
                              ),
                              child: Container(
                                margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                                child: GridView.count(
                                  crossAxisCount: 2,
                                  primary: false,
                                  crossAxisSpacing: 2.0,
                                  mainAxisSpacing: 4.0,
                                  shrinkWrap: true,
                                  children: <Widget>[
                                    _buildCard(
                                        'Đinh Xuân Anh',
                                        'Chủ nhiệm đề tài',
                                        1,
                                        'https://i.imgur.com/3O1WBaF.png',
                                        ' Trường Đh Khoa học xã hội và Nhân văn'),
                                    _buildCard(
                                        'Nguyễn Thị Hồng Hạnh',
                                        'Phó chủ nhiệm',
                                        2,
                                        'https://i.imgur.com/cpeLKt6.png',
                                        'Trường Đh Khoa học xã hội và Nhân văn'),
                                    _buildCard(
                                        'Hồ Trần Thiện Đạt',
                                        'Lập trình viên Android',
                                        3,
                                        'https://i.imgur.com/bucPOYQ.jpg',
                                        'Trường Đh Công nghệ thông tin'),
                                    _buildCard(
                                        'Đào Hữu Duy Quân',
                                        'Lập trình viên Web',
                                        4,
                                        'https://i.imgur.com/GwMjOBI.png',
                                        ' Trường Đh Công nghệ thông tin'),
                                    _buildCard(
                                        'Nguyễn Phương Tính',
                                        'Thiết kế UI/UX',
                                        5,
                                        'https://i.imgur.com/UJnLLgy.png',
                                        ' Trường Đh Công nghệ thông tin'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(1.0, 20.0, 1.0, 0.0),
                height: 230.0,
                width: 500.0,
                decoration: new BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(0.0),
                    boxShadow: [
                      BoxShadow(blurRadius: 1.0, color: Colors.grey)
                    ]),
                child: Column(
                  children: <Widget>[
                    Text(' '),
                    Text(
                      'Contact\n',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.place,
                          color: Colors.blue,
                          size: 24.0,
                        ),
                        Text(' '),
                        const Expanded(
                          child: Text(
                            'Trường Đại học Công nghệ thông tin, khu phố 6, Thủ Đức, TP. Hồ Chí Minh',
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(''),
                    Row(
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.phone,
                          color: Colors.blue,
                          size: 20.0,
                        ),
                        Text(' '),
                        Text(' '),
                        const Expanded(
                          child: Text(
                            '0912950191',
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(''),
                    Row(
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.facebook,
                          color: Colors.blue,
                          size: 24.0,
                        ),
                        Text(' '),
                        const Expanded(
                          child: Text(
                            'https://www.facebook.com/thien.dat.ho.tran',
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(''),
                    Row(
                      children: <Widget>[
                        Icon(
                          FontAwesomeIcons.github,
                          color: Colors.blue,
                          size: 24.0,
                        ),
                        Text(' '),
                        const Expanded(
                          child: Text(
                            'https://github.com/SenseYna/weather_app_flutter',
                            style: TextStyle(
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(''),
                  ],
                ),
              ),
              SizedBox(height: 10.0,),
              Container(
                // margin: EdgeInsets.fromLTRB(1.0, 20.0, 1.0, 0.0),
                height: 50.0,

                decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(0.0),
                  // boxShadow: [
                  //   BoxShadow(blurRadius: 1.0, color: Colors.grey)
                  // ]
                ),
                child: Column(
                  children: <Widget>[
                    Text(''),
                    Text('© 2019 Dat_Ho'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCard(
      String name, String role, int cardIndex, String image, String about) {
    return Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 7.0,
        child: Column(
          children: <Widget>[
            SizedBox(height: 12.0),
            Stack(children: <Widget>[
              Container(
                height: 90.0,
                width: 90.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(45.0),
                    color: Colors.grey[100],
                    image: DecorationImage(image: NetworkImage(image))),
              ),
            ]),
            SizedBox(height: 8.0),
            Text(
              name,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.bold,
                fontSize: 12.0,
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              role,
              style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                  fontSize: 8.0,
                  color: Colors.grey),
            ),
            SizedBox(height: 6.0),
            Text(
              about,
              style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                  fontSize: 8.0,
                  color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 0.0),
          ],
        ),
        margin: cardIndex.isEven
            ? EdgeInsets.fromLTRB(5.0, 0.0, 10.0, 10.0)
            : EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 10.0));
  }
}
