window['ints'] = function(i) {
  var mod = {};
  mod['one'] = i.one;
  mod['zero'] = i.zero;
  mod['eq'] = function(a, b) {
    return i.eq(a)(b);
  };
  mod['lt'] = function(a, b) {
    return i.lt(a)(b);
  };
  mod['add'] = function(a, b) {
    return i.add(a)(b);
  };
  mod['mul'] = function(a, b) {
    return i.mul(a)(b);
  };
  mod['format'] = i.format;
  mod['parse'] = i.parse;
  mod['unsafeToInt'] = function(x) {
    return i.parse(x.toString(2));
  };
  mod['unsafeToNumber'] = function(x) {
    return parseInt(i.format(x), 2);
  };
  return mod;
}(PS.Ints);
