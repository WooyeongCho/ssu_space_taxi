class Item {
  float x, y;
  String type;
  float size = 30;

  Item(float x, float y, String type) {
    this.x = x;
    this.y = y;
    this.type = type;
  }

  void update() {
    y += 2;  // 아래로 떨어짐
  }

  void display() {
    imageMode(CENTER);
    if (type.equals("multishot")) {
      image(increaseImg, x, y, size, size);
    } else if (type.equals("cooldown")) {
      image(reloadImg, x, y, size, size);
    }
  }

  boolean isCollectedBy(Player p) {
    return dist(x, y, p.x + 40, p.y + 40) < 30;
  }
}
