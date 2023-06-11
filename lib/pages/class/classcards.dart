import 'package:flutter/material.dart';

class CardClass extends StatefulWidget {
  const CardClass({Key? key , required this.classdata}) : super(key: key);
  final Map classdata;
  @override
  State<CardClass> createState() => _CardClassState();
}

class _CardClassState extends State<CardClass> {
  late Map classdata;
  @override
  void initState() {
    classdata = widget.classdata;
    // print('classdata');
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4.0,
        color: Colors.purpleAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: const DecorationImage(
              image: AssetImage('assets/5556661.jpg'),fit: BoxFit.cover,
            )
          ),
          height: 200,
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 22.0),
          child: Column(
            /*2*/
            crossAxisAlignment: CrossAxisAlignment.start,
            /*3*/
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Image(image: AssetImage('assets/5556661.jpg'),fit: BoxFit.fill,),
              /* Here we are going to place the _buildLogosBlock */
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(classdata['classname'],style: TextStyle(
                        shadows: [
                          Shadow(
                            offset: const Offset(15,15),
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 15
                          )
                        ],
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold
                    ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(classdata['id'],style: TextStyle(
                        shadows: [
                          Shadow(
                              offset: const Offset(15,15),
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 15
                          )
                        ],
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w400
                    ),),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(classdata['subjectname'],
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      shadows: [
                        Shadow(
                            offset: const Offset(15,15),
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 15
                        )
                      ],
                    ),),
                  Text(classdata['trainername'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      shadows: [
                        Shadow(
                            offset: const Offset(15,15),
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 15
                        )
                      ],
                    ),),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
