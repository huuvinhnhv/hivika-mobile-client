import 'package:flutter/material.dart';
import 'package:mobile_cdtkpm_2023/Views/Event_Screen/DetailEventGame.dart';
import 'package:mobile_cdtkpm_2023/consts/consts.dart';

import '../../consts/lists.dart';
import '../../models/Events.dart';

class EventsScreen extends StatefulWidget {
  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  late Future<EventList> _eventListFuture;  

  @override
  void initState() {
    super.initState();
    _eventListFuture = fetchEventList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(imgBgEventScreen), fit: BoxFit.fill)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Events'),
        ),
        body: Container(          
          padding: const EdgeInsets.all(10),
          child: Center(
            child: FutureBuilder<EventList>(
              future: _eventListFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 0.7,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: snapshot.data!.data.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventDetailScreen(
                                eventId: snapshot.data!.data[index].eventId,
                                indexEvent: index,
                              ),
                            ),
                          );
                        },
                        child: Container(  
                          padding: const EdgeInsets.all(10),                   
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: lightGrey,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.asset(
                                      imgPosterList[index],
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.fill,                                    
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  snapshot.data!.data[index].name,
                                  textAlign: TextAlign.center,                                  
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 19,
                                    color: redColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
