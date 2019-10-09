import 'dart:async';

import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
 

main(){
  runApp(MaterialApp(home: Home()));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int timerTick = 90;
  final tick1 = "tick1.mp3";
  Timer timer;
  static AudioCache player = AudioCache();
  bool started = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Arena Metronomo"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlatButton(
                  child: Text("<"),
                  onPressed: (){
                    setState(() {
                      timerTick--;
                    });
                  },
                ),
                Text("$timerTick", style: TextStyle(fontSize: 80),),
                FlatButton(
                  child: Text(">"),
                  onPressed: (){
                    setState(() {
                      timerTick++;
                    });
                  },
                ),
                ],
              ),
              Slider(
                max: 180,
                min: 10,
                onChanged: (c){
                  setState(() {
                    timerTick = c.toInt();
                    if(started){
                      timer.cancel();
                      timer = Timer.periodic(Duration(milliseconds: 1010 - timerTick), (Timer time){
                          player.play(tick1);
                      });
                    }
                  });
                },
                value: timerTick.toDouble()
              ),
              IconButton(
                icon: Icon(started ? Icons.pause : Icons.play_arrow),
                onPressed: (){
                  setState(() {
                    started = !started;
                    if(started){
                      timer = Timer.periodic(Duration(milliseconds: 1010 - timerTick), (Timer timer){
                        player.play(tick1);
                      });
                    }
                    else{
                      if(timer != null){
                        timer.cancel();
                      }
                    }
                  });
                },
              ),
            ],
          ),
        )
      ),
    );
  }
}