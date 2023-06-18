class FlowTracker {
  final bool? nameDone;
  final bool? emailDone;
  final bool? phoneDone;
  final bool? passwordDone;

  FlowTracker({
    this.nameDone,
    this.emailDone,
    this.phoneDone,
    this.passwordDone,
  });

  FlowTracker copyWith({
    bool? nameDone,
    bool? emailDone,
    bool? phoneDone,
    bool? passwordDone,
  }) {
    return FlowTracker(
      nameDone: nameDone ?? this.nameDone,
      emailDone: emailDone ?? this.emailDone,
      phoneDone: phoneDone ?? this.passwordDone,
      passwordDone: passwordDone ?? this.passwordDone,
    );
  }
}
