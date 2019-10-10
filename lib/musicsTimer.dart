
class musicsTimer{
  String _nome;
  int _timer;

  musicsTimer(String nome, int timer);

  String getNome(){
    return _nome;
  }
  void setNome(String nome){
    this._nome = nome;
  }

  int getTimer(){
    return _timer;
  }

  void setTimer(int timer){
    this._timer = timer;
  }

  Map<String, dynamic> toJson() => {
    'nome': _nome,
    'tempo': _timer,
  };
}