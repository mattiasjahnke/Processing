class Player {
  public float x;
  public float y;
  public int dir;
  public float rot;
  public int speed;
  public float moveSpeed;
  public float rotSpeed;
  
  public Player() {
    x = 20;
    y = 2;
    dir = 0;
    rot = -PI / 2;
    speed = 0;
    moveSpeed = 0.10;
    rotSpeed = 2 * PI / 180;
  }
}