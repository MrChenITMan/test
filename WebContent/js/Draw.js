Draw = (function() {
	Draw.prototype.name = 'Draw';

	Draw.prototype.iconName = 'draw';

  function Draw() {
    this.strokeWidth = 5;
  }

  Draw.prototype.optionsStyle = 'stroke-width';

  Draw.prototype.begin = function(x, y, lc) {
    return this.currentShape = LC.createShape('Line', {
      x1: x,
      y1: y,
      x2: x,
      y2: y,
      strokeWidth: this.strokeWidth,
      color: lc.getColor('primary')
    });
  };

  Draw.prototype["continue"] = function(x, y, lc) {
    this.currentShape.x2 = x;
    this.currentShape.y2 = y;
    return lc.update(this.currentShape);
  };

  Draw.prototype.end = function(x, y, lc) {
    return lc.saveShape(this.currentShape);
  };

  return Draw;

})();
