class BossBullet extends Bullet {

  BossBullet(float x, float y, float dx, float dy) {
    super(x, y, false);  // false → isPlayerBullet 아님 (적 탄)
    this.dx = dx;
    this.dy = dy;
  }

  // 보스탄 외형을 다르게 표시하려면 display 오버라이드
  @Override
  void display() {
    fill(255, 100, 0);  // 주황색 계열로 표시
    ellipse(x, y, 20, 20);  // 더 크고 둥글게
  }
}