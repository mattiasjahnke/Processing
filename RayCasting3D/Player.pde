class Player {
  public float x;
  public float y;
  public int dir;
  public float rot;
  public int speed;
  public float moveSpeed;
  public float rotSpeed;
  
  public Player() {
    x = 5.2;
    y = 19.8;
    dir = 0;
    rot = -0.76794404;//-PI / 2;
    speed = 0;
    moveSpeed = 0.10;
    rotSpeed = 2 * PI / 180;
  }
}