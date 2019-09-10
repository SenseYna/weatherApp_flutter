import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new ListView(
      
        shrinkWrap: true,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                alignment: Alignment(0.0, -0.60),
                height: 100.0,
                color: Colors.white,
                child: Text(
                  'Something about us',
                  style: TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                
                margin: EdgeInsets.fromLTRB(25.0, 45.0, 25.0, 0.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(blurRadius: 2.0, color: Colors.grey)
                    ]),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(25.0, 25.0, 5.0, 5.0),
                          child: Text(
                            'WE HAVE',
                            style: TextStyle(
                                color: Colors.grey,
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(25.0, 40.0, 5.0, 25.0),
                          child: Text(
                            ' 4',
                            style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.bold,
                                fontSize: 40.0),
                          ),
                        )
                      ],
                    ),
                    SizedBox(width: 10.0),
                    Container(
                      
                      // decoration: BoxDecoration(
                      //     color: Colors.greenAccent[100].withOpacity(0.5),
                      //     borderRadius: BorderRadius.circular(10.0)),
                      child: Center(
                        child: Text('Members',
                            style: TextStyle(
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.bold,
                                fontSize: 45.0,
                                color: Colors.black)),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: 20.0), // bên dưới Member
          Container(
              padding: EdgeInsets.only(left: 25.0, right: 25.0),
              color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'MY COACHES',
                    style: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0),
                  ),
                  Text(
                    'VIEW PAST SESSIONS',
                    style: TextStyle(
                        color: Colors.green,
                        fontFamily: 'Quicksand',
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0),
                  )
                ],
              )),
          SizedBox(height: 10.0),
          GridView.count(
            
            crossAxisCount: 2,
            primary: false,
            crossAxisSpacing: 2.0,
            mainAxisSpacing: 4.0,
            shrinkWrap: true,
            children: <Widget>[
              _buildCard('Thầy Long', 'Giáo viên hướng dẫn', 1, 'https://img.thuthuatphanmem.vn/uploads/2018/09/28/beautiful-dragons_024751662.jpg','- Sinh viên năm 3 \n- Trường Đh Công nghệ thông tin\n- Khoa Công nghệ Phần mềm\n- Thành tích: Hổ báo trường mẫu giáo'),
              _buildCard('Đinh Xuân Anh', 'Trưởng nhóm', 2, 'https://i.imgur.com/3O1WBaF.png','- Sinh viên năm 3 \n- Trường Đh Khoa học xã hội và Nhân văn\n- Khoa Địa lý\n- Thành tích: Hổ báo trường mẫu giáo'),
              _buildCard('Nguyễn Thị Hồng Hạnh', 'Nghiên cứu địa lý', 3, 'https://i.imgur.com/cpeLKt6.png','- Sinh viên năm 3 \n- Trường Đh Khoa học xã hội và Nhân văn\n- Khoa Địa lý\n- Thành tích: Hổ báo trường mẫu giáo'),
              _buildCard('Hồ Trần Thiện Đạt', 'Dev App', 4, 'https://i.imgur.com/bucPOYQ.jpg','- Sinh viên năm 3 \n- Trường Đh Công nghệ thông tin\n- Khoa Công nghệ Phần mềm\n- Thành tích: Hổ báo trường mẫu giáo'),
              _buildCard('Đào Hữu Duy Quân', 'Dev Web', 5, 'https://i.imgur.com/GwMjOBI.png','- Sinh viên năm 3 \n- Trường Đh Công nghệ thông tin\n- Khoa Công nghệ Phần mềm\n- Thành tích: Hổ báo trường mẫu giáo'),
              _buildCard('Nguyễn Phương Tính', 'Designer', 6  , 'https://i.imgur.com/UJnLLgy.png','- Sinh viên năm 3 \n- Trường Đh Công nghệ thông tin\n- Khoa Công nghệ Phần mềm\n- Thành tích: Hổ báo trường mẫu giáo'),
              

            ],
          )
        ],
      );

  }
  Widget _buildCard(String name, String status, int cardIndex, String url, String about) {
    return Card( 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0)
      ),
      elevation: 7.0,
      child: Column(
        children: <Widget>[
          SizedBox(height: 24.0),
          Stack(
            children: <Widget>[
              Container(
                height: 60.0,
                width: 60.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.green,
                  image: DecorationImage(
                    image: NetworkImage(
                      url,
                    )
                  )
                ),
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
                status,
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold,
                  fontSize: 10.0,
                  color: Colors.grey
                ),
              ),
              SizedBox(height: 8.0),
              Expanded(
                child: Container(
                  width: 175.0,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only
                    (
                      bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0)
                  ),
                ),
                child: Center(
                  child: Text('Detail',
                  style: TextStyle(
                    color: Colors.white, fontFamily: 'Quicksand', fontSize: 15.0,
                  ),
                ),
              )
              )
              )
            ],
          ),
      margin: cardIndex.isEven? EdgeInsets.fromLTRB(10.0, 0.0, 25.0, 10.0):EdgeInsets.fromLTRB(25.0, 0.0, 5.0, 10.0)
     );
  }
}
