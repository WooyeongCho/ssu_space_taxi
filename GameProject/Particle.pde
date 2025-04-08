class Particle {
  float x, y;
  float size;
  float alpha;

  Particle(float x, float y) {
    this.x = x;
    this.y = y;
    size = random(12, 20);  // 🎯 더 크게 시작
    alpha = 255;
  }

  void update() {
    y += 0.3;       // 살짝 아래로 흐름
    size *= 0.96;   // 점점 작아짐
    alpha -= 4;     // 점점 투명해짐
  }

  void display() {
    noStroke();
    fill(200, 200, 200, alpha);  // 연기 느낌 회색
    ellipse(x, y, size, size);
  }

  boolean isDead() {
    return alpha <= 0 || size < 1;
  }
}
