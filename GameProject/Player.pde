class Player {
  float x, y;
  float speed = 5;
  float hp = 100;
  int lastShotTime = 0;         // 마지막 발사 시간
  int shotCooldown = 500;       // 쿨타임 (ms), 아이템 먹으면 조절 가능
  int bulletsPerShot = 5;       // 한 번에 나가는 총알 수
  float bulletSpread = 10;      // 총알 간 간격
  int effectTimer = 0;
  color baseColor = color(0, 255, 0);    // 기본색
  color flashColor = color(255, 255, 0); // 강화 시 잠깐 바뀔 색

  Player(float startX, float startY) {
    x = startX;
    y = startY;
    
  }

 

  void move() {
    if (currentDir == 'L') x -= speed;
    else if (currentDir == 'R') x += speed;
  }

void display() {
  imageMode(CENTER);

  if (effectTimer > 0) {
    // 🔁 두 번 반짝임: 30프레임 동안 2번 번쩍
    int phase = effectTimer % 10;
    if (phase < 5) {
      tint(255, 255, 100);  // 밝게
    } else {
      tint(255);            // 원래대로
    }
    effectTimer--;
  } else {
    tint(255);
  }

  image(playerImg, x + 40, y + 40, 80, 80);
  noTint();
}


void shoot(ArrayList<Bullet> playerBullets) {
  if ((mousePressed || spacePressed) && millis() - lastShotTime > shotCooldown) {
    float spacing = bulletSpread;
    float startX = x + 25 - ((bulletsPerShot - 1) * spacing) / 2.0;

    for (int i = 0; i < bulletsPerShot; i++) {
      float bx = startX + i * spacing;
      Bullet b = new Bullet(bx, y, true);
      playerBullets.add(b);
    }

    lastShotTime = millis();
  }
}



  void checkCollision(ArrayList<Bullet> enemyBullets) {
    for (int i = enemyBullets.size() - 1; i >= 0; i--) {
      Bullet b = enemyBullets.get(i);
      if (dist(b.x, b.y, player.x + 40, player.y + 40) < 40) {
        hp -= 10;
        if (player.hp <= 0) {
          gameState = "gameover";
        }
        enemyBullets.remove(i);
      }
    }
  }
}
