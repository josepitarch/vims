enum OrderItem {
  average('Average'),
  year('Year'),
  random('Random');

  const OrderItem(this._value);
  final String _value;
  String get value => _value;
}
