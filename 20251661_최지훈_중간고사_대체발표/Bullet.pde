class Bullet {
  float x, y;
  float speed = 5;
  color bulletColor;
  boolean isPlayerBullet;
  float dx = 0;
  float dy = 5;
  Bullet(float startX, float startY, boolean isPlayer) {
    x = startX;
    y = startY;
    isPlayerBullet = isPlayer;
    bulletColor = isPlayer ? color(0, 255, 0) : color(255, 0, 0);
  }

  void move() {
  if (isPlayerBullet) {
    y -= speed;  // 위로 날아감
  } else {
    x += dx;
    y += dy;
  }
}
void display() {
  if (isPlayerBullet) {
    // 🟦 플레이어 총알 커스텀 모양
    float bulletSize = 5;
    float cx = x;
    float cy = y;
    
    float bodyWidth = bulletSize;
    float bodyHeight = bulletSize;
    float bottomBarWidth = bulletSize * 0.5;
    float bottomBarHeight = bulletSize * 1.5;
    float topBarWidth = bulletSize * 0.3;
    float topBarHeight = bulletSize * 0.75;
    float centerCircleSize = bulletSize * 0.5;

    noStroke();

    // 하단 빨간 막대
    fill(255, 0, 0);
    rect(cx - bottomBarWidth / 2, cy, bottomBarWidth, bottomBarHeight);

    // 중간 파란 본체
    fill(0, 0, 255);
    rect(cx - bodyWidth / 2, cy - bodyHeight, bodyWidth, bodyHeight);

    // 중심 흰색 원
    fill(255);
    ellipse(cx, cy, centerCircleSize, centerCircleSize);

    // 상단 파란 막대
    fill(0, 0, 255);
    rect(cx - topBarWidth / 2, cy - bodyHeight - topBarHeight, topBarWidth, topBarHeight);

  } else {
    // 🔴 적의 총알은 기존 원 형태
    imageMode(CENTER);
    image(enemyBulletImg, x, y, 10, 30);  // 원하는 크기로 조절 가능
  }
}



  boolean offScreen() {
    return y > height || y < 0;
  }
}
