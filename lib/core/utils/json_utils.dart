List<String> jsonStrings(Object? value) =>
    value is List ? value.whereType<String>().toList() : const [];
