enum EnemyType {
  PASSIVE, SHOOTER, MOVER
}

class Enemy {
  boolean isDying = false;
  float fadeAlpha = 255;

  float x, y;
  float hp;
  float maxHp = 100;
  float speed;
  EnemyType type;

  float stopY = 100;
  int moveDir = 1;

  float shootCooldown;
  int lastShotTime = 0;

  boolean isBoss = false;
  float spinAngle = 0;

  int bossPattern = 0;
  int patternTimer = 0;
  boolean warningActive = false;
  int warningTimer = 0;
  boolean beamActive = false;
  int beamTimer = 0;

  Enemy(float x, float y, float hp, float speed, EnemyType type, float stopY, float shootCooldown) {
    this.x = x;
    this.y = y;
    this.hp = hp;
    maxHp = hp;
    this.speed = speed;
    this.type = type;
    this.stopY = stopY;
    this.shootCooldown = shootCooldown;
  }

  void update() {
    if (isDying) {
      fadeAlpha -= 5;
      return;
    }

    move();
    shoot();
  }

  void move() {
    if (isBoss && (warningActive || beamActive)) return;

    if (type == EnemyType.PASSIVE && y < 100) {
      y += speed;
    } else if (type == EnemyType.SHOOTER && y < 100) {
      y += speed;
    } else if (type == EnemyType.MOVER) {
      if (y < stopY) {
        y += speed;
      } else {
        x += speed * moveDir;
        if (x < 0 || x > width - 75) moveDir *= -1;
      }
    }
  }

  void shoot() {
    if (type == EnemyType.PASSIVE) return;

    if (isBoss) {
      updateBossPattern();
      return;
    }

    if (millis() - lastShotTime > shootCooldown) {
      Bullet b = new Bullet(x + 20, y + 40, false);
      enemyBullets.add(b);
      lastShotTime = millis();
    }
  }

  void updateBossPattern() {
    if (!isBoss) return;

    if (beamActive) {
      beamTimer--;
      if (beamTimer <= 0) beamActive = false;
    }

    if (warningActive) {
      warningTimer--;
      if (warningTimer <= 0) {
        warningActive = false;
        fireBreath();
      }
      return;
    }

    patternTimer--;
    if (patternTimer <= 0) {
      bossPattern = (bossPattern + 1) % 4;

      if (bossPattern == 0) {
        warningActive = true;
        warningTimer = 60;
        patternTimer = 180;
      } else if (bossPattern == 1) {
        fireBarrage();
        patternTimer = 180;
      } else if (bossPattern == 2) {
        fireCircleBurst(18, 3);
        patternTimer = 180;
      } else if (bossPattern == 3) {
        fireRotatingCircle(12, 2.5);
        patternTimer = 180;
      }
    }
  }

  void display() {
  if (isBoss) {
    imageMode(CENTER);
    tint(255, fadeAlpha);
    image(bossImg, x + 75, y + 75, 150, 150);
    noTint();

    if (beamActive) {  // 빔이 활성화된 상태일 때
      noStroke();
      float beamCenter = x + 75;  // 보스의 중앙 위치
      float beamWidth = 40;  // 빔의 너비

      // 불 느낌의 빨간 빔을 그리기
      for (int i = 0; i < 4; i++) {
        float offset = i * 4;  // 점점 좁혀지는 빔 효과
        fill(255, 50, 0, 180 - i * 40);  // 불빛 효과, 불투명도 점차 감소
        rect(beamCenter - beamWidth / 2 + offset, y + 150, beamWidth - offset * 2, height);  // 빔 그리기
      }
    }
  } else {
    // 이미지 출력
    imageMode(CENTER);
    tint(255, fadeAlpha);

    if (type == EnemyType.PASSIVE) {
      image(passiveMonsterImg, x + 20, y + 20, 40, 40);
    } else {
      image(activeMonsterImg, x + 20, y + 20, 40, 55);
    }

    noTint();

    // 체력바 표시 (죽는 중 아니고 체력 0 초과일 때만)
    if (!isDying && hp > 0) {
      float barWidth = 40;
      float barHeight = 4;
      float hpRatio = constrain(hp / maxHp, 0, 1);

      float barX = x + 20 - barWidth / 2;
      float barY = y - 8;  // 몬스터 위 위치

      noStroke();
      fill(50);
      rect(barX, barY, barWidth, barHeight);  // 배경
      fill(lerpColor(color(255, 0, 0), color(0, 255, 0), hpRatio));
      rect(barX, barY, barWidth * hpRatio, barHeight);  // 체력
    }
  }
}




  void fireBarrage() {
    for (int i = -3; i <= 3; i++) {
      Bullet b = new Bullet(x + 20, y + 40, false);
      b.dx = i * 0.7;
      b.dy = 3;
      enemyBullets.add(b);
    }
  }

  void fireCircleBurst(int count, float speed) {
    for (int i = 0; i < count; i++) {
      float angle = TWO_PI / count * i;
      float dx = cos(angle) * speed;
      float dy = sin(angle) * speed;
      BossBullet b = new BossBullet(x + 75, y + 75, dx, dy);
      enemyBullets.add(b);
    }
  }

  void fireRotatingCircle(int count, float speed) {
    for (int i = 0; i < count; i++) {
      float angle = TWO_PI / count * i + radians(spinAngle);
      float dx = cos(angle) * speed;
      float dy = sin(angle) * speed;
      BossBullet b = new BossBullet(x + 75, y + 75, dx, dy);
      enemyBullets.add(b);
    }
    spinAngle += 20;
  }

  void fireBreath() {
    beamActive = true;
    beamTimer = 90;
    shakeTimer = 90;
  }

  void checkBeamHit(Player p) {
    if (!isBoss || !beamActive) return;

    float beamX = x + 75;
    float beamW = 40;
  println("Player Y: " + p.y + ", Beam Y Threshold: " + (y + 150));

   
      println("Hit by beam!");
      if (p.y + 25 > y + 150) {
        println("Player hit by beam!");
        // p.hp -= 1;
      }
    
  }
}
