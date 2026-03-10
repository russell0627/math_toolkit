import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'widgets/algebra_auditorium.dart';

class AlgebraView extends ConsumerStatefulWidget {
  final bool isCompact;
  const AlgebraView({super.key, this.isCompact = false});

  @override
  ConsumerState<AlgebraView> createState() => _AlgebraViewState();
}

class _AlgebraViewState extends ConsumerState<AlgebraView> {
  @override
  Widget build(BuildContext context) {
    return AlgebraAuditorium(isCompact: widget.isCompact);
  }
}
