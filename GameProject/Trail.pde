class Trail {
  float x, y;
  float alpha;
  float size;

  Trail(float x, float y) {
    this.x = x;
    this.y = y;
    alpha = 100;      // 🔻 더 연하게 시작
    size = 80;
  }

  void update() {
    alpha -= 8;       // ⏳ 더 빠르게 사라지게
  }

  void display() {
    tint(255, alpha);
    image(playerImg, x + 40, y + 40, size, size);
    noTint();
  }

  boolean isDead() {
    return alpha <= 0;
  }
}
