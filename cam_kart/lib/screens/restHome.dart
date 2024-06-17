import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


import '../constant/loader.dart';
import '../model/restInfo.dart';
import '../screens/cart.dart';
import '../services/restaurantServ.dart';
import '../widgets/my_drawer.dart';
import '../widgets/restCard.dart';

// late var restaurants=[];
String s = '';

class RestHome extends StatefulWidget {
  RestHome({Key? key}) : super(key: key);
  @override
  State<RestHome> createState() => _RestHomeState();
}

class _RestHomeState extends State<RestHome>
    with SingleTickerProviderStateMixin {
  Map<String,RestInfo> allRest={};
  List filtername = ['Open Now'];
  List filterselected = [false];
  List<RestInfo>? restaur;
  final RestaurantServ restServ = RestaurantServ();
  fetchallrest() async {
    restaur = await restServ.fetchAllRestaurants(context);
    for (int i = 0; i < restaur!.length; i++) {
      allRest[restaur![i].id] = restaur![i];
    }
    debugPrint(' abfbghjhj $restaur');
    setState(() {});
  }

  fetchopenrest() async {
    restaur = await restServ.fetchOpenRestaurants(context);
    setState(() {});
  }

  fetchsearchedrest(String s) async {
    if(s!='') {
      restaur = await restServ.fetchSearchRestaurants(context, s);
    }
    else{
      fetchallrest();
    }
    debugPrint('$restaur');
    setState(() {});
  }



  var textEditingController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchallrest();
    debugPrint('restaurant $restaur');
    s = '';
    fetchsearchedrest(s);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),

      body: CustomScrollView(physics: const BouncingScrollPhysics(), slivers: <
          Widget>[
        SliverAppBar(
          pinned: true,
          floating: true,
          // expandedHeight: 100,
          flexibleSpace:  FlexibleSpaceBar(
            title: Text('CARTLY',style: GoogleFonts.aBeeZee(textStyle: TextStyle(fontSize:32,color: Colors.white )),),
            centerTitle: true,
          ),
         // backgroundColor: Theme.of(context).primaryColor,
          //pinned: false,
          //floating: false,
          actions: [
            badges.Badge(
              position: badges.BadgePosition.topEnd(top: 3, end: 3),
              badgeContent: const Text(''),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => const cart()));
                },

                icon: const Icon(Icons.shopping_cart,color: Colors.white,),
                //alignment: Alignment(x, y),
                tooltip: 'Cart',
              ),
            )
          ],
        ),
        restaur == null
            ? const SliverToBoxAdapter(child: Loader())
            : SliverList(
          delegate: SliverChildListDelegate([
            // const SearchBar(),
            Container(
              margin: const EdgeInsets.all(10),
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        fillColor: Colors.white10,
                        filled: true,
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Search for restaurants...',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),borderSide: const BorderSide(width: 5,color: Colors.white)),
                        alignLabelWithHint: false,
                      ),
                      onSubmitted: (value) async {
                        s = value;
                        await fetchsearchedrest(s);
                        setState(() {});
                      },

                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.search, size: 30),
                    onPressed: () async {
                      s = textEditingController.text;
                      await fetchsearchedrest(s);
                      setState(() {});
                    },
                  ),

                ],
              ),
            ),
            // Filters(),
            Container(
              height: 25,
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListView.separated(
                itemCount: filtername.length,
                padding: const EdgeInsets.only(left: 16),
                physics: const BouncingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    width: 16,
                  );
                },
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: Container(
                      height: 20,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      width: 100,
                      decoration: BoxDecoration(
                          color: (filterselected[index])
                              ? const Color(0xFF6200EE)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black)),
                      child: Center(
                        child: Text(
                          filtername[index],
                          style: TextStyle(
                            color: (filterselected[index])
                                ? Colors.white
                                : Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        if (index == 0) {
                          // s = '';
                          fetchopenrest();
                        } else {
                          s = '';
                          fetchsearchedrest(s);
                        }
                        filterselected[index] = !filterselected[index];

                      });
                    },
                  );
                },
              ),
            ),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    width: MediaQuery.of(context).size.width,
                    child: const Text(
                      'Top Picks',
                      style: TextStyle(
                        // color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),

                  ListView.separated(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 16),
                      itemBuilder: (context, index) {
                        return RestCard(data: restaur![index]);
                      },
                      shrinkWrap: true,
                      //scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 16,
                        );
                      },
                      itemCount: restaur!.length),
                ])
          ]),

        ),
      ]),
    );
  }
}