import 'package:flutter/material.dart';

enum ToastPos { top, bottom }

enum ToastDuration { short, medium, long }

const int _shortAnimation = 3;

const int _mediumAnimation = 6;

const int _longAnimation = 9;

const int _lagFactor = 1;

Duration _durationOfToast(ToastDuration duration, {bool isToast = true}) {
  int time = isToast ? 2 : 0;

  switch (duration) {
    case ToastDuration.short:
      time += _shortAnimation;
      break;
    case ToastDuration.medium:
      time += _mediumAnimation;
      break;
    case ToastDuration.long:
      time += _longAnimation;
      break;
    default:
      time += _mediumAnimation;
      break;
  }

  return Duration(seconds: time);
}

class AnimetedToast {
  static final AnimetedToast _singleton = AnimetedToast._internal();

  factory AnimetedToast() {
    return _singleton;
  }

  AnimetedToast._internal();

  static OverlayState _overlayState;
  static OverlayEntry _overlayEntry;

  static bool _isOpen = false;

  static void createToast(
    BuildContext context, {
    String title,
    String description,
    Color color,
    ToastPos pos = ToastPos.bottom,
    ToastDuration duration = ToastDuration.medium,
    @required Tween<double> variableRange,
    @required void Function(double) updateVariable,
    double initialValue,
  }) {
    _overlayState = Navigator.of(context).overlay;

    if (!_isOpen) {
      _isOpen = true;

      _overlayEntry = OverlayEntry(builder: (context) {
        return _Toast(
          title: title,
          description: description,
          variableRange: variableRange,
          color: color ?? Theme.of(context).primaryColor,
          updateVaribale: updateVariable,
          duration: duration,
          pos: pos,
          initialValue: initialValue,
        );
      });

      _overlayState.insert(_overlayEntry);
    }
  }

  static dismiss() async {
    if (_isOpen) {
      _overlayEntry?.remove();
      _isOpen = false;
    }
  }
}

class _Toast extends StatefulWidget {
  final String title;
  final String description;
  final ToastDuration duration;
  final ToastPos pos;
  final Color color;
  final Tween<double> variableRange;
  final void Function(double) updateVaribale;
  final double initialValue;

  const _Toast(
      {Key key,
      this.title,
      this.duration = ToastDuration.medium,
      this.pos = ToastPos.bottom,
      this.color,
      this.description,
      this.variableRange,
      this.updateVaribale,
      this.initialValue})
      : super(key: key);

  @override
  __ToastState createState() => __ToastState();
}

class __ToastState extends State<_Toast> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Tween<Offset> _offsetTween;
  Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 750));

    if (widget.pos == ToastPos.bottom) {
      _offsetTween = Tween<Offset>(begin: Offset(0, 1), end: Offset.zero);
    } else {
      _offsetTween = Tween<Offset>(begin: Offset(0, -1), end: Offset.zero);
    }

    _offsetAnimation = _offsetTween.animate(
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));

    _controller.forward();

    _initialValue();

    _controller.addStatusListener((listener) async {
      if (listener == AnimationStatus.completed) {
        await Future.delayed(_durationOfToast(widget.duration));
        _controller.reverse();
        await Future.delayed(Duration(milliseconds: 750));
        if (widget.initialValue != null) {
          widget.updateVaribale(widget.initialValue);
        }
        AnimetedToast.dismiss();
      }
    });
  }

  void _initialValue() async {
    await Future.delayed(Duration(milliseconds: 500));
    widget.updateVaribale(widget.variableRange.begin);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double bottomHeight = MediaQuery.of(context).padding.bottom;
    return Positioned(
      top: widget.pos == ToastPos.top ? 0 : null,
      bottom: widget.pos == ToastPos.bottom ? 0 : null,
      child: SlideTransition(
        position: _offsetAnimation,
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: widget.color,
            boxShadow: [BoxShadow(blurRadius: 4)],
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(10),
            ),
          ),
          padding: EdgeInsets.fromLTRB(
              20,
              widget.pos == ToastPos.top
                  ? statusBarHeight + 20
                  : bottomHeight + 20,
              20,
              widget.pos == ToastPos.top ? 20 : 35),
          child: _OverlayToast(
            title: widget.title,
            description: widget.description,
            variableRange: widget.variableRange,
            changeDuration: _durationOfToast(widget.duration, isToast: false),
            updateVariable: widget.updateVaribale,
          ),
        ),
      ),
    );
  }
}

class _OverlayToast extends StatefulWidget {
  _OverlayToast({
    Key key,
    @required this.title,
    @required this.description,
    @required this.variableRange,
    @required this.changeDuration,
    @required this.updateVariable,
  }) : super(key: key);

  final String title;
  final String description;
  final Tween<double> variableRange;
  final Duration changeDuration;
  final void Function(double) updateVariable;

  @override
  __OverlayToastState createState() => __OverlayToastState();
}

class __OverlayToastState extends State<_OverlayToast>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  int count = 0;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: widget.changeDuration);
    _animation = widget.variableRange
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

    _controller.addListener(() {
      count++;
      if (count % _lagFactor == 0) {
        setState(() {
          widget.updateVariable(_animation.value);
        });
        count = 0;
      }
    });

    _startChange();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startChange() async {
    await Future.delayed(Duration(seconds: 1));
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Row(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(right: 15)),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              widget.title == null
                  ? Container()
                  : Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        widget.title,
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                    ),
              widget.description == null
                  ? Container()
                  : Text(
                      widget.description +
                          " ${_animation.value.toStringAsFixed(2)}",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    )
            ],
          )),
        ],
      ),
    );
  }
}
