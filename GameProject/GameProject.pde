
ArrayList<Bullet> playerBullets;
ArrayList<Bullet> enemyBullets;
ArrayList<Enemy> enemies;
ArrayList<Item> items;
ArrayList<Star> stars;
Player player;
ArrayList<Particle> particles = new ArrayList<Particle>();
ArrayList<Trail> trails = new ArrayList<Trail>();
ArrayList<Ranking> rankings = new ArrayList<Ranking>();
PImage increaseImg, reloadImg;
PImage playerImg;
PImage bossImg;
PImage backgroundImage;

PImage star1Img;
PImage star2Img;
PImage star3Img;
PImage ssuBodyImg;

PImage logoImage;
PImage startImage;
PImage ssuTaxiImage;
PFont neodgm;
PImage passiveMonsterImg;
PImage activeMonsterImg;
PImage enemyBulletImg;

PImage phoneImg;


float xTemp = 0;
float yTemp = 0;
String gameState = "prologue";
int score = 0;
int stageLevel = 0;
PFont font;
char currentDir = ' ';
String effectText = "";
int effectTextTimer = 0;
int stageAnnounceTimer = 0;
String currentStageText = "";
boolean spacePressed = false;
float shakeX = 0;
float shakeY = 0;
int shakeTimer = 0;
float shakeStrength = 5;
String playerName = "";
boolean typingName = true;  // 입력 중
int cursorBlinkTimer = 0;
boolean showCursor = true;
String warningText = "";
int warningTimer = 0;

int prologueIndex = 0;

String[] prologueText = {
  "슝슝이가 평화롭게 기조실 과제를 하던 어느 날이었어요.",
  "밤을 새며 게임을 만들던 슝슝이는 그만 잠에 들고 말았어요.",
  "그런데 갑자기",
  "GYU라는 이름의 외계인이 나타나 슝슝이를 납치해갔어요!",
  "외계인 GYU는 자신이 살고 있는 GYU-00 행성에 슝슝이를 데려갔어요",
  "슝슝이는 GYU-00 행성에서 탈출하기 위해 우주택시를 호출했어요",
  "하지만 GYU-00 행성은 위험천만한 곳이어서 괴물들을 무찌르며 나아가야 해요",
  "슝슝이가 안전하게 SSU-25 행성까지 갈 수 있도록 도와주세요!"
};

void setup() {
  size(800, 600);
  noSmooth();
  loadRankings();
  playerImg = loadImage("Images/Player.png");
  bossImg = loadImage("Images/Boss.png");
  font = createFont("Malgun Gothic", 24);
  backgroundImage = loadImage("Images/background.png"); // 배경 이미지 로드
  logoImage = loadImage("Images/logo.png"); // 로고 이미지 로드
  startImage = loadImage("Images/start.png"); // 시작 이미지 로드
  ssuTaxiImage = loadImage("Images/Player.png"); // SSU 택시 이미지 로드
  neodgm = createFont("Images/neodgm.ttf", 20); // 폰트 로드
  passiveMonsterImg = loadImage("Images/Monster.png");
  activeMonsterImg = loadImage("Images/Monster2.png");
  enemyBulletImg = loadImage("Images/tnfqud.png");
  star1Img = loadImage("Images/star1.png");
  star2Img = loadImage("Images/star2.png"); 
  star3Img = loadImage("Images/star3.png");
  increaseImg = loadImage("Images/Increase.png");
  reloadImg = loadImage("Images/Reload.png");
  phoneImg = loadImage("Images/phone.png");
  ssuBodyImg = loadImage("Images/ssu_body.png");
  textFont(font);
  playerBullets = new ArrayList<Bullet>();
  enemyBullets = new ArrayList<Bullet>();
  enemies = new ArrayList<Enemy>();
  items = new ArrayList<Item>();
  player = new Player(width / 2, height - 100);
  stars = new ArrayList<Star>();

  for (int i = 0; i < 20; i++) {
    float x = random(width);
    float y = random(height);
    float speed = random(0.2, 2);
    int size = int(random(1, 3));
    int opacity = int(random(50, 255)); // 투명도 설정
    stars.add(new Star(x, y, speed, size, opacity));
  }

  frameRate(60);
}

void draw() {
  background(0);
  if (shakeTimer > 0) {
    shakeX = random(-shakeStrength, shakeStrength);
    shakeY = random(-shakeStrength, shakeStrength);
    translate(shakeX, shakeY);
    shakeTimer--;
  }

  if (gameState.equals("prologue")) {
    drawBackground();
    
    textFont(neodgm);
    fill(255);
    textAlign(CENTER);
    text(prologueText[prologueIndex], width/2, height/2);
    //imageMode(CENTER);
    //image(phoneImg, width / 2, height / 2, 600, 600);
  }

  if (gameState.equals("playing")) {
    runGame();
    if (enemies.size() == 0) {
      stageLevel++;
      setupStage(stageLevel);
    }
  } else if (gameState.equals("menu")) {
    drawMenu();
  } else if (gameState.equals("gameover")) {
    drawGameOver();
  }else if(gameState.equals("ranking")) {
    drawRanking();
  }

  if (player.hp <= 0) {
    gameState = "gameover";
  }

  if (frameCount % 60 == 0) {
    //println("FPS: " + frameRate);
  }

  for (int i = items.size() - 1; i >= 0; i--) {
    Item item = items.get(i);
    item.update();
    item.display();
    if (item.isCollectedBy(player)) {
      applyItemEffect(item.type);
      items.remove(i);
    }
  }

  if (effectTextTimer > 0) {
    fill(255);
    textAlign(CENTER);
    textSize(16);
    text(effectText, player.x + 25, player.y - 10);
    effectTextTimer--;
  }
  for (int i = particles.size() - 1; i >= 0; i--) {
    Particle p = particles.get(i);
    p.update();
    p.display();
    if (p.isDead()) {
      particles.remove(i);
    }

  }
} 


void runGame() {
  resetMatrix();  // 화면 흔들림 좌표 초기화
  drawBackground(); // 배경 그리기
  player.move();
  player.display();
  player.shoot(playerBullets);

  for (int i = playerBullets.size() - 1; i >= 0; i--) {
    Bullet b = playerBullets.get(i);
    b.move();
    b.display();
    if (b.offScreen()) playerBullets.remove(i);
  }

  for (int i = enemies.size() - 1; i >= 0; i--) {
    Enemy e = enemies.get(i);
    e.update();
    e.display();

    if (e.isBoss) {
      drawBossUI(e);
      if (e.warningActive) {
        fill(255, 50, 50, 180);
        textSize(32);
        textAlign(CENTER);
        text("⚠ WARNING ⚠", e.x + 75, e.y - 30);
      }
    }

    e.checkBeamHit(player);
    if (e.isDying && e.fadeAlpha <= 0) enemies.remove(i);
  }

  for (int i = enemyBullets.size() - 1; i >= 0; i--) {
    Bullet b = enemyBullets.get(i);
    b.move();
    b.display();
    if (b.offScreen()) enemyBullets.remove(i);
  }

  drawUI();
  checkCollisions();
}

// Additional functions (checkCollisions, drawUI, keyPressed, etc.)
// are assumed to remain unchanged and can be appended below...


void checkCollisions() {
  // 플레이어 총알 → 적
  for (int i = playerBullets.size() - 1; i >= 0; i--) {
    Bullet b = playerBullets.get(i);

    for (int j = enemies.size() - 1; j >= 0; j--) {
      Enemy e = enemies.get(j);

      // 충돌 판정 기준 보스/일반 적 분기
      float ex = e.isBoss ? e.x + 75 : e.x + 20;
      float ey = e.isBoss ? e.y + 75 : e.y + 20;
      float radius = e.isBoss ? 60 : 25;

      if (dist(b.x, b.y, ex, ey) < radius) {
        e.hp -= 10;
        playerBullets.remove(i);

        if (e.hp <= 0 && !e.isDying) {
          e.isDying = true;  // 🔥 죽는 중 상태 시작

          float dropChance = 1;  // 드롭 확률 (100%)
          if (random(1) < dropChance) {
            String type = random(1) < 0.5 ? "multishot" : "cooldown";
            items.add(new Item(ex, ey, type));
          }
        }
        break;
      }
    }
  }

  // 적 총알 → 플레이어
  player.checkCollision(enemyBullets);
}

void keyPressed() {
  if (typingName) {
    if (key == BACKSPACE && playerName.length() > 0) {
      playerName = playerName.substring(0, playerName.length() - 1);
    } else if (key == ENTER || key == RETURN) {
      typingName = false;  // 이름 입력 완료
    } else if (key != CODED && playerName.length() < 12) {
      playerName += key;
    }
  }

  // 방향키 입력 등 기존 처리
  if (key == 'a' || key == 'A') currentDir = 'L';
  if (key == 'd' || key == 'D') currentDir = 'R';
  if (key == 'w' || key == 'W') currentDir = 'U';
  if (key == 's' || key == 'S') currentDir = 'D';
  if(key == 'r' || key == 'R') gameState = "ranking";  // 랭킹 화면으로 전환
  if (key == ' ') spacePressed = true;
}

void keyReleased() {
  if ((key == 'a' || key == 'A') && currentDir == 'L') currentDir = ' ';
  if ((key == 'd' || key == 'D') && currentDir == 'R') currentDir = ' ';
  if ((key == 'w' || key == 'W') && currentDir == 'U') currentDir = ' ';
  if ((key == 's' || key == 'S') && currentDir == 'D') currentDir = ' ';
  if (key == ' ') spacePressed = false;
}

void drawUI() {
  resetMatrix();  // 화면 흔들림 좌표 초기화
  rectMode(CORNER);
  float barWidth = 200;
  float barHeight = 20;
  float barX = 20;
  float barY = height - 40;

  // 배경 바
  fill(50);
  rect(barX, barY, barWidth, barHeight);

  // 체력 바
  float hpRatio = constrain(player.hp / 100.0, 0, 1);  // 0~1로 제한
  fill(lerpColor(color(255, 0, 0), color(0, 255, 0), hpRatio));  // 체력에 따라 색상 변화
  rect(barX, barY, barWidth * hpRatio, barHeight);

  // 테두리
  noFill();
  stroke(255);
  rect(barX, barY, barWidth, barHeight);
  noStroke();

  // 체력 수치 텍스트
  fill(255);
  textSize(14);
  textAlign(LEFT, BOTTOM);
  text("HP: " + int(player.hp), barX, barY - 5);

    // 이름 표시
  fill(255);
  textSize(14);
  textAlign(RIGHT, BOTTOM);
  text("Name: " + playerName, width - 20, height - 40);  // 스테이지 위에 조그맣게

  fill(255);
  textSize(16);
  textAlign(LEFT, BOTTOM);
  text("STAGE " + stageLevel, width - 100, height - 20);
  fill(255);
  fill(255);
  textAlign(LEFT);
  textSize(14);
  text("총알 수: " + player.bulletsPerShot, 20, height - 100);  // ⬅ 더 위로
  text("쿨타임: " + player.shotCooldown + "ms", 20, height - 80);

  if (stageAnnounceTimer > 0) {
  textAlign(CENTER, CENTER);
  textSize(48);

  int alpha = int(map(stageAnnounceTimer, 120, 0, 255, 0));  // 점점 투명하게
  fill(255, alpha);
  text(currentStageText, width / 2, height / 2);

  stageAnnounceTimer--;
}
}


void startGame() {
  gameState = "playing";
  typingName = false;  // ✅ 이름 입력 종료!
  setupGame();
  println("플레이어 이름: " + playerName);  // ✅ 디버깅용 출력
}

void mousePressed() {
  if (gameState.equals("menu")) {
    float buttonX = width / 2;
    float buttonY = height - 70;
    float buttonWidth = 120;
    float buttonHeight = 55;

    if (mouseX > buttonX - buttonWidth/2 && mouseX < buttonX + buttonWidth/2 &&
        mouseY > buttonY - buttonHeight/2 && mouseY < buttonY + buttonHeight/2) {

      if (playerName.trim().equals("")) {
        warningText = "이름을 입력하세요!";
        warningTimer = 120;  // 2초
      } else {
        startGame();  // 이름이 있으면 시작
      }
    }
  }

  if (gameState.equals("gameover")) {
    // 게임 오버 화면에서 게임 다시 시작
    if (mouseX > width / 2 - 75 && mouseX < width / 2 + 75 && mouseY > height / 2 + 80 && mouseY < height / 2 + 130) {
      gameState = "menu";  // 메뉴로 돌아가기
    }
  }

  if (gameState.equals("ranking")) {
    // 랭킹 화면에서 게임 화면으로 돌아가기
    if (mouseX > width / 2 - 75 && mouseX < width / 2 + 75 && mouseY > height - 100 && mouseY < height - 50) {
      gameState = "menu";  // 게임 화면으로 돌아가기
    }
  }

  if (gameState.equals("prologue")) {
    if (prologueIndex < prologueText.length - 1) {
      prologueIndex++;
    } else {
      gameState = "menu";  // 프로로그 끝나면 메뉴로
    }
  }
}


void drawMenu() {
  background(0);
  
  drawBackground();

  imageMode(CENTER);
  image(ssuTaxiImage, width/2 + sin(xTemp) * 300, height/2 + sin(yTemp) * 40, 150, 150);
  image(logoImage, width/2, 150, 310, 155);
  // 게임 시작 버튼 Y위치 조정
image(startImage, width / 2, height - 70, 120, 55);

  textFont(neodgm);
  fill(255);
  textAlign(CENTER);
  text("슝슝이를 SSU-25 행성까지", width/2, height/2 - 20);
  text("안전하게 태워다줄 수 있을까?!", width/2, height/2 + 5);
  text("우주 속 위험천만한 대모험", width/2, height/2 + 30);
  text("WASD - 이동 | 마우스 클릭 - 공격", width/2, height/2 + 80);
  text("총알 업그레이드는 강화 아이템을 먹어보세요!", width/2, height/2 + 105);

  xTemp = (xTemp + 0.01) % TWO_PI;
  yTemp = (yTemp + 0.02) % TWO_PI;

  // 이름 입력 박스
  fill(255);
  textSize(18);
  textAlign(CENTER);
  text("플레이어 이름을 입력하세요", width / 2, height / 2 + 140);

  // 입력 박스 그리기
  fill(30);
  stroke(255);
  rectMode(CENTER);
  rect(width / 2, height / 2 + 175, 300, 40);
  fill(255);
  noStroke();

  String displayName = playerName;
  if (typingName && showCursor) displayName += "|";  // 깜빡이는 커서

  text(displayName, width / 2, height / 2 + 180);

  // 커서 깜빡임
  cursorBlinkTimer++;
  if (cursorBlinkTimer > 30) {
    showCursor = !showCursor;
    cursorBlinkTimer = 0;
  }
  if (warningTimer > 0) {
    fill(255, 50, 50);
    textSize(18);
    textAlign(CENTER);
    text(warningText, width / 2, height / 2 + 220);
    warningTimer--;
  }
}



void drawGameOver() {
  background(0);
  textAlign(CENTER, CENTER);

  // 게임 오버 텍스트
  fill(255, 50, 50);
  textSize(48);
  text("GAME OVER", width / 2, height / 3);

  // (선택) 점수 표시
  fill(255);
  textSize(24);
  text("당신의 생존력: " + int(player.hp) + " HP", width / 2, height / 2);

  // 다시 시작 버튼
  fill(100, 200, 255);
  rect(width / 2 - 75, height / 2 + 80, 150, 50);
  fill(0);
  textSize(20);
  text("다시 시작", width / 2, height / 2 + 105);
}

void setupGame() {
  // 플레이어 초기화
  player = new Player(width / 2, height - 100);

  // 총알 리스트 초기화
  playerBullets = new ArrayList<Bullet>();
  enemyBullets = new ArrayList<Bullet>();

  // 적 리스트 초기화
  enemies = new ArrayList<Enemy>();

  // 점수나 강화 상태 초기화
  score = 0;
  player.shotCooldown = 300;
  player.bulletsPerShot = 1;

  // 게임 상태
  frameCount = 0;  // 게임 시간 리셋 (선택)
}

void spawnStage1() {
  for (int i = 0; i < 5; i++) {
    float x = 100 + i * 120;
    enemies.add(new Enemy(x, 0, 100, 1, EnemyType.PASSIVE, 0, 0));
  }
}

void spawnStage2() {
  for (int i = 0; i < 5; i++) {
    float x = 100 + i * 120;
    float shootCD = 1000 + i * 200;  // 쿨타임 다르게
    enemies.add(new Enemy(x, 0, 300, 1.2, EnemyType.SHOOTER, 0, shootCD));
  }
}

void spawnStage3() {
  for (int i = 0; i < 3; i++) {
    float x = 150 + i * 200;
    float stopY = 120 + i * 40;  // Y위치 다르게
    enemies.add(new Enemy(x, 0, 500, 1.5, EnemyType.MOVER, stopY, 700 + i * 150));
  }
}

void setupStage(int stage) {
  if (stage == 1) spawnStage1();
  else if (stage == 2) spawnStage2();
  else if (stage == 3) spawnStage3();
  else if (stage == 4) spawnBossStage();

  currentStageText = "STAGE " + stage;
  stageAnnounceTimer = 200;  // 2초 표시
}

void spawnBossStage() {
  Enemy boss = new Enemy(width / 2 - 75, -150, 1000, 1.2, EnemyType.MOVER, 70, 600);

  boss.isBoss = true;
  boss.maxHp = boss.hp;
  enemies.add(boss);
}

void drawBossUI(Enemy boss) {
  float barWidth = 400;
  float barHeight = 20;
  float x = width / 2 - barWidth / 2;
  float y = 30;
  float ratio = constrain(boss.hp / boss.maxHp, 0, 1);

  // 배경
  fill(50);
  rect(x, y, barWidth, barHeight);

  // 체력바
  fill(255, 0, 0);
  rect(x, y, barWidth * ratio, barHeight);

  // 테두리
  noFill();
  stroke(255);
  rect(x, y, barWidth, barHeight);
  noStroke();
}


void applyItemEffect(String type) {
  if (type.equals("multishot")) {
    player.bulletsPerShot += 1;
    player.effectTimer = 60;
    showEffectText("총알 수 증가!!");
  }
  else if (type.equals("cooldown")) {
    player.shotCooldown = max(player.shotCooldown - 50, 100);
    player.effectTimer = 60;
    showEffectText("공격속도 상승!");
  }
}

void showEffectText(String msg) {
  effectText = msg;
  effectTextTimer = 120;  // 2초 정도 유지
}

void drawBackground() {
  imageMode(CORNER);
  image(backgroundImage, 0, 0, width, height); // 배경 이미지 그리기
  for (Star star : stars) {
    star.move();
    star.display();
  }
  tint(255,255);
}


void sendScore(String name, int score) {
  String url = "https://script.google.com/macros/s/AKfycbxYKaFENO-G1pPn3fs4ssdWJ2cEDbP_aT759Zyq0sUxF9RmuSCxNLU4xEJ7rWIzyS7f/exec?action=submitScore&name=" + name + "&score=" + score;
  
  // GET 요청으로 점수 제출
  loadStrings(url);
}
void loadRankings() {
  String url = "https://script.google.com/macros/s/AKfycbxYKaFENO-G1pPn3fs4ssdWJ2cEDbP_aT759Zyq0sUxF9RmuSCxNLU4xEJ7rWIzyS7f/exec?action=getRankings";
  
  // GET 요청으로 랭킹 데이터 가져오기
  String[] rankingsData = loadStrings(url);

  // JSON 데이터를 첫 번째 줄에 있다고 가정
  String jsonString = rankingsData[0];

  // 불필요한 문자 제거 (예: "[" , "]" 제거)
  jsonString = jsonString.replace("[", "").replace("]", "");

  // 각 항목을 구분하여 처리 (JSON 객체는 중괄호로 묶여 있으므로 이를 쪼갬)
  String[] items = split(jsonString, "},{");

  // 아이템을 하나씩 처리
  for (int i = 0; i < items.length; i++) {
    String item = items[i];
    
    // 중괄호를 다시 추가하여 JSON 형식으로 복원
    if (i != 0) item = "{" + item;
    if (i != items.length - 1) item = item + "}";

    // 각 항목에서 필요한 값을 추출
    String name = getValueFromJson(item, "name");
    int score = int(getValueFromJson(item, "score"));
    println("name: " + name + ", score: " + score);  // 디버깅용 출력
    int rank = int(getValueFromJson(item, "rank"));
    println("rank: " + rank);  // 디버깅용 출력

    // Ranking 객체 생성 후 리스트에 추가
    rankings.add(new Ranking(name, score, rank));
  }
}

// JSON 문자열에서 키에 해당하는 값을 추출하는 함수
String getValueFromJson(String json, String key) {
  String pattern = "\"" + key + "\":\"?([^\",}]+)\"?";  // key: "name" 형태로 추출
  String[] matches = match(json, pattern);
  
  // matches 배열에서 결과가 있으면 반환, 없으면 빈 문자열 반환
  if (matches != null && matches.length > 1) {
    return matches[1].trim();  // trim()을 사용하여 불필요한 공백 제거
  }
  return "";
}


void drawRanking() {
  background(0);  // 배경색을 검정으로

  // 게임 상태 텍스트
  fill(255);
  textAlign(CENTER);
  textSize(48);
  text("RANKINGS", width / 2, 50);

  // 랭킹 출력
  int y = 100;
  for (Ranking r : rankings) {
    textSize(20);
    text(r.rank + ". " + r.name + " - " + r.score, width / 2, y);
    y += 30;  // 줄 간격 설정
  }

  // 다시 게임으로 돌아가기 버튼
  fill(50, 150, 255);
  rect(width / 2 - 75, height - 100, 150, 50);
  fill(255);
  textSize(20);
  text("Back to Game", width / 2, height - 75);
}

