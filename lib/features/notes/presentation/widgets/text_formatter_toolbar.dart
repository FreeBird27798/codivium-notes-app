import 'package:flutter/material.dart';

enum _DismissDirection { down, left, right }

class TextFormatterToolbar extends StatefulWidget {
  final TextEditingController controller;

  const TextFormatterToolbar({super.key, required this.controller});

  @override
  State<TextFormatterToolbar> createState() => _TextFormatterToolbarState();
}

class _TextFormatterToolbarState extends State<TextFormatterToolbar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<Offset> _slideAnimation;

  bool _isVisible = true;
  _DismissDirection _lastDirection = _DismissDirection.down;

  double _dragDx = 0;
  double _dragDy = 0;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _slideAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0, 1.5)).animate(
          CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
        );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _hide(_DismissDirection direction) {
    setState(() {
      _lastDirection = direction;
      _isVisible = false;
    });

    Offset end;
    switch (direction) {
      case _DismissDirection.down:
        end = const Offset(0, 1.5);
      case _DismissDirection.left:
        end = const Offset(-1.5, 0);
      case _DismissDirection.right:
        end = const Offset(1.5, 0);
    }

    _slideAnimation = Tween<Offset>(begin: Offset.zero, end: end).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );

    _animController.forward(from: 0);
  }

  void _show() {
    _animController.reverse().then((_) {
      setState(() {
        _isVisible = true;
      });
    });
  }

  void _onPanStart(DragStartDetails details) {
    _dragDx = 0;
    _dragDy = 0;
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _dragDx += details.delta.dx;
    _dragDy += details.delta.dy;
  }

  void _onPanEnd(DragEndDetails details) {
    const threshold = 30.0;
    final absDx = _dragDx.abs();
    final absDy = _dragDy.abs();

    if (absDx < threshold && absDy < threshold) return;

    if (absDy >= absDx && _dragDy > 0) {
      _hide(_DismissDirection.down);
    } else if (absDx > absDy && _dragDx < 0) {
      _hide(_DismissDirection.left);
    } else if (absDx > absDy && _dragDx > 0) {
      _hide(_DismissDirection.right);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          if (!_isVisible) _buildHandle(),
          SlideTransition(
            position: _slideAnimation,
            child: GestureDetector(
              onPanStart: _isVisible ? _onPanStart : null,
              onPanUpdate: _isVisible ? _onPanUpdate : null,
              onPanEnd: _isVisible ? _onPanEnd : null,
              child: _buildToolbar(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      height: 48,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButton(Icons.format_bold, () {}),
          _buildButton(Icons.format_italic, () {}),
          _buildButton(Icons.format_underline, () {}),
          _buildButton(Icons.text_fields, () {}),
          _buildDivider(),
          _buildButton(Icons.format_align_left, () {}),
          _buildButton(Icons.format_align_center, () {}),
          _buildButton(Icons.format_align_right, () {}),
          _buildButton(Icons.format_align_justify, () {}),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    Alignment alignment;
    IconData icon;
    switch (_lastDirection) {
      case _DismissDirection.down:
        alignment = Alignment.bottomCenter;
        icon = Icons.keyboard_arrow_up_rounded;
      case _DismissDirection.left:
        alignment = Alignment.centerLeft;
        icon = Icons.keyboard_arrow_right_rounded;
      case _DismissDirection.right:
        alignment = Alignment.centerRight;
        icon = Icons.keyboard_arrow_left_rounded;
    }

    return Align(
      alignment: alignment,
      child: GestureDetector(
        onTap: _show,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: _lastDirection == _DismissDirection.down ? 64 : 28,
            height: _lastDirection == _DismissDirection.down ? 28 : 64,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 20, color: Colors.grey.shade700),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Icon(icon, size: 20, color: Colors.black87),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 20, color: Colors.grey.shade400);
  }
}
