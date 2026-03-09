import 'package:flutter/widgets.dart';

class Layer extends StatelessWidget 
{
  final List<Widget>? widgets;
  const Layer({this.widgets, super.key});
  @override
  Widget build(BuildContext context) 
  {
    return PreferredSize(
      preferredSize: Size.infinite, 
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: widgets!.map((w) => Expanded(flex:3, child: w)).toList(),
      ),
    ); 
  }
}