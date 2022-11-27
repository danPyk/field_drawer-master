import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoundedButton extends StatefulWidget {
  final String text;
  final Function onPressed;
  final double? minWidth;

  const RoundedButton(this.text, this.onPressed, {Key? key, this.minWidth})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _RoundedButtonState();
}

class _RoundedButtonState extends State<RoundedButton>
    with SingleTickerProviderStateMixin {
  double? _scale;
  AnimationController? _controller;
  final bool _isElevated = true;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 50,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1.0 - _controller!.value;
    return GestureDetector(
      onTap: _onTap,
      child: Transform.scale(
        scale: _scale,
        child: _animatedButton(),
      ),
    );
  }

  Widget _animatedButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: widget.minWidth,
        height: MediaQuery.of(context).size.height * 0.045,
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF0F9D58),
          borderRadius: BorderRadius.circular(50),
          boxShadow: _isElevated ? selectButtonTheme() : null,
        ),
      ),
    );
  }

  List<BoxShadow> selectButtonTheme() {
    return [
      BoxShadow(
        color: Colors.black.withGreen(50),
        offset: const Offset(1, 1),
        blurRadius: 10,
        spreadRadius: 1,
      ),
      BoxShadow(
        color: Colors.lightGreen.shade200,
        offset: const Offset(-1, -1),
        blurRadius: 10,
        spreadRadius: 1,
      ),
    ];
  }

  Future<void> _onTap() async {
    _controller?.forward();
    await Future.delayed(const Duration(milliseconds: 50));
    _controller?.reverse();
    widget.onPressed();
  }
}
