class Star {
    float x, y;
    float speed;
    int size;
    int opacity;

    Star (float startX, float startY, float speed, int size, int opacity) {
        this.x = startX;
        this.y = startY;
        this.speed = speed;
        this.size = size;
        this.opacity = opacity;
    }

    void move() {
        y += speed;
        if (y > height) {
            y = 0;
            x = random(width);
        }
    }

    void display() {
        tint(255, opacity);
        switch (size) {
            case 1:
                image(star1Img, x, y, 15, 15);
                break;
            case 2:
                image(star2Img, x, y, 15, 15);
                break;
            case 3:
                image(star3Img, x, y, 15, 15);
                break;
        }
    }
}