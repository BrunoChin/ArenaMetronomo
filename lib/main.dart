import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:path_provider/path_provider.dart';

main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
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
  final ticker1 = "ticker1.wav";
  final ticker2 = "ticker2.wav";
  int idMusica;
  Timer timer;
  static AudioCache player = AudioCache();
  bool started = false;
  int timerCount = 1;
  List musicas = [];

  final _controlerNome = TextEditingController();

  starterdMetronomo() {
    timer = Timer.periodic(
        Duration(milliseconds: (60000 / timerTick).roundToDouble().toInt()),
        (Timer time) {
      if (timerCount < 4) {
        setState(() {
          player.play(ticker2);
          timerCount++;
        });
      } else if (timerCount == 1 || timerCount == 4) {
        setState(() {
          timerCount = 1;
          player.play(ticker1);
        });
      }
    });
  }

  _add() {
    if (_controlerNome.text == null || _controlerNome.text == "") {
      _showDialog();
    } else {
      setState(() {
        print(":(");
        Map<String, dynamic> _tomapmusic = Map();
        _tomapmusic['name'] = _controlerNome.text;
        _tomapmusic['time'] = timerTick;
        musicas.add(_tomapmusic);
        idMusica = musicas.length - 1;
        _salarArquivo();
      });
    }
  }

  _save() {
    if (idMusica != null) {
      musicas[idMusica]['name'] = _controlerNome.text;
      musicas[idMusica]['time'] = timerTick;
    }
  }

  _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Erro X("),
            content: Text("Nome da Musicas Vazio"),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
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
              onPressed: () {
                _save();
              },
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
                        if (started) {
                          timer.cancel();
                          starterdMetronomo();
                        }
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
                        if (started) {
                          timer.cancel();
                          starterdMetronomo();
                        }
                      });
                    },
                  ),
                ],
              ),
              Slider(
                  activeColor: Colors.orange,
                  max: 250,
                  min: 80,
                  onChanged: (c) {
                    setState(() {
                      timerTick = c.toInt();
                      if (started) {
                        timer.cancel();
                        starterdMetronomo();
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
                      starterdMetronomo();
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
                Divider(
                  color: Colors.orange,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: musicas.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(
                          musicas[index]['name'],
                          style:
                              TextStyle(color: Colors.orange, fontSize: 30.0),
                        ),
                        subtitle: Text(
                          musicas[index]['time'].toString(),
                          style: TextStyle(
                              color: Colors.orangeAccent, fontSize: 20.0),
                        ),
                        onTap: () {
                          setState(() {
                            _controlerNome.text = musicas[index]['name'];
                            timerTick = musicas[index]['time'];
                            idMusica = index;
                          });
                        },
                        onLongPress: () {
                          setState(() {
                            musicas.remove(musicas[index]);
                            _salarArquivo();
                          });
                        },
                      );
                    },
                  ),
                ),
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
