part of google_maps_flutter;

/// Immutable item used in the stroke pattern for a Polyline.
class PatternItem {
  const PatternItem._(this._json);  
  
  static const PatternItem dot = PatternItem._(<dynamic>['dot']);    
  
  /// [length] non-negative.  
  static PatternItem dash(double length) {  
    assert(length >= 0.0);  
    return PatternItem._(<dynamic>['dash', length]);
  }
  
  /// [length] non-negative.
  static PatternItem gap(double length) {    
    assert(length >= 0.0);
    return PatternItem._(<dynamic>['gap', length]);
  }

  final dynamic _json;

  dynamic _toJson() => _json;
}
