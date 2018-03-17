class Player {
  public float x;
  public float y;
  public int dir;
  public float rot;
  public int speed;
  public float moveSpeed;
  public float rotSpeed;
  
  public Player() {
    x = 18;
    y = 5;
    dir = 0;
    rot = 0;
    speed = 0;
    moveSpeed = 0.10;
    rotSpeed = 3 * PI / 180;
  }
}