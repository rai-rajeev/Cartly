
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/dishInfo.dart';
import '../theme_provider.dart';
class MenuCard extends StatefulWidget {
  final DishInfo dish;
  final int freq;
  const MenuCard({Key? key, required this.dish,required this.freq}) : super(key: key);

  @override
  State<MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<MenuCard> {

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Card(
      //color: Colors.blueGrey.shade200,
      elevation: 0.0,
      // shadowColor: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(width: 10,),
                Image(
                  height: 70,
                  width: 70,
                  image:
                  NetworkImage(widget.dish.pic!),
                  fit: BoxFit.fitHeight,

                ),
                const SizedBox(width: 20,),

                SizedBox(
                  width: 110,
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [

                      RichText(
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        text:
                        TextSpan(
                            text: widget.dish.name,
                            style:  TextStyle(
                              fontWeight: FontWeight.bold,fontSize: 18,color: (themeProvider.isDarkMode)?Colors.white:Colors.black,)),

                      ),
                      RichText(
                        maxLines: 1,
                        text:
                        TextSpan(
                            text:
                            'Rate: ₹${widget.dish.price}\n',
                            style:  TextStyle(
                              fontWeight:
                              FontWeight.w200,fontSize: 15,color: (themeProvider.isDarkMode)?Colors.white:Colors.black,)),

                      ),
                  ]

                ),
                )
              ],
            ),


          ],

        ),

      ),


    );

  }
}