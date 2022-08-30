enum OrderItem {
  average({'en': 'Average', 'es': 'Puntación'}),
  year({'en': 'Year', 'es': 'Año'}),
  random({'en': 'Random', 'es': 'Aleatorio'});

  const OrderItem(this._value);
  final Map<String, String> _value;
  Map<String, String> get value => _value;
}
