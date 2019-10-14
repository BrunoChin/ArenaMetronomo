import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:path_provider/path_provider.dart';

import 'musicsTimer.dart';

main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    //theme: ThemeData.dark(),
    home: Home(),
  ));
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
  int timerCount = 1;
  List musicas = [];
  musicsTimer musica;

  final _controlerNome = TextEditingController();

  starteMetronomo() {
    timer = Timer.periodic(
        Duration(milliseconds: (60000 / timerTick).roundToDouble().toInt()),
        (Timer time) {
      player.play(tick1);
      if (timerCount < 4) {
        setState(() {
          timerCount++;
        });
      } else {
        setState(() {
          timerCount = 1;
        });
      }
    });
  }

  _add() {
    setState(() {
      Map<String, dynamic> _tomapmusic = Map();
      _tomapmusic['name'] = _controlerNome.text;
      _tomapmusic['time'] = timerTick;
      musicas.add(_tomapmusic);
      _salarArquivo();
    });
  }

  @override
  void initState() {
    super.initState();
    __lerArquivo().then((dados) {
      setState(() {
        musicas = json.decode(dados);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                _add();
              },
            ),
            IconButton(
              icon: Icon(Icons.save),
              onPressed: (){},
            )
          ],
          backgroundColor: Colors.orange,
          title: Text("Arena Metronomo"),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _controlerNome,
                style: TextStyle(color: Colors.orange),
                cursorColor: Colors.orange,
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange)),
                    labelText: "Musica: ",
                    labelStyle: TextStyle(color: Colors.orange),
                    enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.orange, width: 1))),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    child: Text(
                      "<",
                      style: TextStyle(color: Colors.orange, fontSize: 30),
                    ),
                    onPressed: () {
                      setState(() {
                        timerTick--;
                      });
                    },
                  ),
                  Text(
                    "$timerTick",
                    style: TextStyle(color: Colors.orange, fontSize: 80),
                  ),
                  FlatButton(
                    child: Text(
                      ">",
                      style: TextStyle(color: Colors.orange, fontSize: 30),
                    ),
                    onPressed: () {
                      setState(() {
                        timerTick++;
                      });
                    },
                  ),
                ],
              ),
              Slider(
                  activeColor: Colors.orange,
                  max: 180,
                  min: 10,
                  onChanged: (c) {
                    setState(() {
                      timerTick = c.toInt();
                      if (started) {
                        timer.cancel();
                        starteMetronomo();
                      }
                    });
                  },
                  value: timerTick.toDouble()),
              IconButton(
                icon: Icon(
                  started ? Icons.pause : Icons.play_arrow,
                  color: Colors.orange,
                ),
                onPressed: () {
                  setState(() {
                    started = !started;
                    if (started) {
                      starteMetronomo();
                    } else {
                      if (timer != null) {
                        timer.cancel();
                      }
                    }
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    timerCount == 1 ? Icons.brightness_1 : Icons.adjust,
                    color: Colors.orange,
                  ),
                  Icon(
                    timerCount == 2 ? Icons.brightness_1 : Icons.adjust,
                    color: Colors.orange,
                  ),
                  Icon(
                    timerCount == 3 ? Icons.brightness_1 : Icons.adjust,
                    color: Colors.orange,
                  ),
                  Icon(
                    timerCount == 4 ? Icons.brightness_1 : Icons.adjust,
                    color: Colors.orange,
                  ),
                ],
              )
            ],
          ),
        )),
        drawer: Drawer(
          child: Container(
            color: Colors.black87,
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(7.0, 25.0, 0.0, 10.0),
                  child: Text(
                    "Musicas",
                    style: TextStyle(fontSize: 30, color: Colors.orange),
                  ),
                ),
                Divider(color: Colors.orange,),
                // Container(
                //   //padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
                //   child: ListView.builder(
                //     //padding: EdgeInsets.fromLTRB(10, 1.0, 10.0, 0),
                //     itemCount: musicas.length,
                //     itemBuilder: (context, index) {
                //       return ListTile(
                //         title: Text(musicas[index]['name']),
                //       );
                //     },
                //   ),
                // ),
                
              ],
            ),
          ),
        ));
  }

  Future<File> _pegarArquivo() async {
    final diretorio = await getApplicationDocumentsDirectory();
    print("${musicas.length}");
    return File("${diretorio.path}/arquico.json");
  }

  Future<File> _salarArquivo() async {
    String dados = json.encode(musicas);
    final file = await _pegarArquivo();
    print("ok");
    return file.writeAsString(dados);
  }

  Future<String> __lerArquivo() async {
    try {
      final file = await _pegarArquivo();
      return file.readAsString();
    } catch (Exception) {
      print(":(");
      return null;
    }
  }
}
