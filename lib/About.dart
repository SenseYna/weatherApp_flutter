import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {

  
  @override
  String titleMembers = 'Members';
  Widget build(BuildContext context) {
    return new ListView(
          shrinkWrap: true,
          children: <Widget>[
            new ExpansionTile(
              title: new Text(
                this.titleMembers,
                textAlign: TextAlign.center,
              ),
              backgroundColor: Theme.of(context).accentColor.withOpacity(0.025),
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                      alignment: Alignment(0.0, 0.0), //-0.40
                      height: 600.0,
                      color: Colors.grey[200],
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
                                'Trưởng nhóm',
                                1,
                                'assets/images/xuananh.png',
                                ' Trường Đh Khoa học xã hội và Nhân văn'),
                            _buildCard(
                                'Nguyễn Thị Hồng Hạnh',
                                'Nghiên cứu địa lý',
                                2,
                                'assets/images/honghanh.png',
                                'Trường Đh Khoa học xã hội và Nhân văn'),
                            _buildCard(
                                'Hồ Trần Thiện Đạt',
                                'Dev App',
                                3,
                                'assets/images/dat.jpg',
                                'Trường Đh Công nghệ thông tin'),
                            _buildCard(
                                'Đào Hữu Duy Quân',
                                'Dev Web',
                                4,
                                'assets/images/quan.png',
                                ' Trường Đh Công nghệ thông tin'),
                            _buildCard(
                                'Nguyễn Phương Tính',
                                'Designer',
                                5,
                                'assets/images/tinh.png',
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
                    // image: DecorationImage(image: NetworkImage(image))),
                    image: DecorationImage(image: AssetImage(image))
                )
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
            ? EdgeInsets.fromLTRB(2.0, 0.0, 25.0, 10.0)
            : EdgeInsets.fromLTRB(25.0, 0.0, 5.0, 10.0));
  }
}
