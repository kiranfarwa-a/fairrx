import 'models.dart';

/// Edit distance between two strings (how many single-letter changes).
int levenshtein(String a, String b) {
  if (a == b) return 0;
  if (a.isEmpty) return b.length;
  if (b.isEmpty) return a.length;
  var prev = List<int>.generate(b.length + 1, (i) => i);
  for (var i = 1; i <= a.length; i++) {
    final cur = List<int>.filled(b.length + 1, 0);
    cur[0] = i;
    for (var j = 1; j <= b.length; j++) {
      final cost = a[i - 1] == b[j - 1] ? 0 : 1;
      final del = prev[j] + 1;
      final ins = cur[j - 1] + 1;
      final sub = prev[j - 1] + cost;
      var best = del < ins ? del : ins;
      if (sub < best) best = sub;
      cur[j] = best;
    }
    prev = cur;
  }
  return prev[b.length];
}

/// Similarity from 0.0 (different) to 1.0 (same).
double similarity(String a, String b) {
  final x = a.toLowerCase();
  final y = b.toLowerCase();
  final longest = x.length > y.length ? x.length : y.length;
  if (longest == 0) return 1.0;
  return 1.0 - levenshtein(x, y) / longest;
}

/// OCR often reads "l" as "1" and "o" as "0". Fix the common ones.
String cleanToken(String t) {
  return t
      .toLowerCase()
      .replaceAll('0', 'o')
      .replaceAll('1', 'l')
      .replaceAll(RegExp(r'[^a-z]'), '');
}

const Set<String> _skip = {
  'generic', 'tablet', 'tablets', 'capsule', 'capsules', 'syrup', 'drops',
  'injection', 'cream', 'acid', 'plus', 'forte', 'with', 'daily', 'after',
  'before', 'food', 'twice', 'once', 'table', 'tabs', 'caps', 'dose',
};

class MedicineMatcher {
  final List<Medicine> medicines;
  MedicineMatcher(this.medicines);

  /// Search box: contains-match first, then fuzzy match on brand/generic.
  List<Medicine> search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return medicines;
    final scored = <MapEntry<Medicine, double>>[];
    for (final m in medicines) {
      final brand = '${m.brand} ${m.core}'.toLowerCase();
      final gen = m.generic.toLowerCase();
      double score = 0;
      if (brand.contains(q) || gen.contains(q)) {
        score = 1.0;
      } else {
        score = _bestWordSimilarity(q, '$brand $gen');
      }
      if (score >= 0.7) scored.add(MapEntry(m, score));
    }
    scored.sort((a, b) => b.value.compareTo(a.value));
    return scored.map((e) => e.key).toList();
  }

  double _bestWordSimilarity(String q, String text) {
    double best = 0;
    for (final w in text.split(RegExp(r'[\s+]+'))) {
      if (w.length < 3 || w == 'generic') continue;
      final s = similarity(q, w);
      if (s > best) best = s;
    }
    return best;
  }

  /// Read OCR text and return the medicines it seems to mention.
  /// For each word we keep the best matches (ties are all kept, max 6).
  List<Medicine> matchText(String ocrText) {
    final tokens = ocrText
        .split(RegExp(r'[\s,;:/()\-]+'))
        .map(cleanToken)
        .where((t) => t.length >= 4 && !_skip.contains(t))
        .toSet();
    final found = <String, Medicine>{};
    for (final token in tokens) {
      double bestScore = 0;
      var bestMeds = <Medicine>[];
      for (final m in medicines) {
        double mScore = 0;
        for (final name in [m.core, m.generic]) {
          for (final word in name.split(RegExp(r'[\s+]+'))) {
            final w = word.toLowerCase();
            if (w.length < 4 || _skip.contains(w)) continue;
            final s = similarity(token, w);
            if (s > mScore) mScore = s;
          }
        }
        if (mScore > bestScore + 0.0001) {
          bestScore = mScore;
          bestMeds = [m];
        } else if ((mScore - bestScore).abs() <= 0.0001 && mScore > 0) {
          bestMeds.add(m);
        }
      }
      if (bestScore >= 0.78) {
        // Prefer tablets and capsules first, then the shortest brand text.
        bestMeds.sort((a, b) {
          final sa = (a.form == 'Tablet' || a.form == 'Capsule') ? 0 : 1;
          final sb = (b.form == 'Tablet' || b.form == 'Capsule') ? 0 : 1;
          if (sa != sb) return sa.compareTo(sb);
          return a.brand.length.compareTo(b.brand.length);
        });
        for (final m in bestMeds.take(6)) {
          found[m.id] = m;
        }
      }
    }
    return found.values.toList();
  }

  /// Same salt, strength and form, cheapest first (excluding the medicine
  /// itself). Liquids are compared only when the pack size is the same.
  List<Medicine> alternatives(Medicine med) {
    if (!med.comparable) return [];
    final solid = med.form == 'Tablet' || med.form == 'Capsule';
    final list = medicines
        .where((m) =>
            m.comparable &&
            m.saltKey == med.saltKey &&
            m.id != med.id &&
            (solid || m.pack.replaceAll(' ', '').toLowerCase() ==
                med.pack.replaceAll(' ', '').toLowerCase()))
        .toList();
    list.sort((a, b) => a.price.compareTo(b.price));
    return list;
  }
}
