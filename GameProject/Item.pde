class Item {
  float x, y;
  float speed = 2;
  String type;

  Item(float x, float y, String type) {
    this.x = x;
    this.y = y;
    this.type = type;
  }

  void update() {
    y += speed;
  }

  void display() {
    if (type.equals("multishot")) fill(0, 255, 255);
    else if (type.equals("rapidfire")) fill(255, 255, 0);
    else fill(255);

    ellipse(x, y, 20, 20);
  }

  boolean isCollectedBy(Player p) {
    return dist(x, y, p.x + 25, p.y + 25) < 30;
  }
}