require 'dxopal'
include DXOpal

#ウィンドウの大きさ
Window.width = 900
Window.height = 900
#ウィンドウの色
Window.bgcolor = C_BLACK

#弾丸クラス
class Bullet < Sprite
  #弾丸大きさ
  Bullet_width = 10
  Bullet_height = 10

  def initialize(player_x = 0, player_y = 0)
    bullet_img = Image.new(Bullet_width, Bullet_height, C_YELLOW)
    # 弾丸の座標はこのメソッドが呼ばれた時点のプレイヤーの座標に順ずる
    x = player_x + 20
    y = player_y
    super(x, y, bullet_img)
  end

  def update
    self.y -= 80
  end
end

# プレイヤークラス
class Player < Sprite
  #プレイヤーの大きさ
  Player_width = 50
  Player_height = 50

  def initialize
    #プレイヤーイメージ
    player_img = Image.new(Player_width, Player_height, C_WHITE)
    #プレイヤーの初期位置
    x = Window.width / 2
    y = Window.height - 100 
    #プレイヤーの初期位置とイメージを渡す
    super(x, y, player_img)
  end
  # 移動処理
  def update
    if Input.key_down?(K_A) && self.x > 0
      self.x -= 5
    elsif Input.key_down?(K_D) && self.x < (Window.width - Player_width)
      self.x += 5
    elsif Input.key_down?(K_W) && self.y > 0
      self.y -= 5
    elsif Input.key_down?(K_S) && self.y < (Window.height - Player_height)
      self.y += 5
    end
  end
end

# 敵クラス
class Enemy < Sprite
  #敵の大きさ
  Enemy_width = 100
  Enemy_height = 100
  def initialize
    #敵イメージ
    enemy_img = Image.new(Enemy_width, Enemy_height, C_RED)
    # x座標はランダムに決める
    x = rand(Window.width - enemy_img.width)
    # y座標は一番上から
    y = 0
    #敵の初期位置とイメージを渡す
    super(x, y, enemy_img)
    # 落ちる速さをランダムに決める
    @down_speed = rand(5..15) #@変数でインスタンス変数（そのクラス内の全メソッドから参照可能）
    #最初に出現したx座標を記録
    @start_x = x
    # 敵の左右の動きを管理,0なら右、1なら左に移動
    @side_flag = 0
  end
  def update
    # 落ちる速さ
    self.y += @down_speed
    if @side_flag == 0
      self.x += 5
    elsif @side_flag == 1
      self.x -= 5
    end

    #右に100移動したら左、左に100移動したら右に移動
    if (self.x - @start_x) > 100
      @side_flag = 1
    elsif (@start_x - self.x) > 100
      @side_flag = 0
    end
    #敵が下まで到達したら元に戻す
    if self.y > Window.height
      self.initialize
    end
  end
end

# ゲーム情報
GAME_INFO = {
  scene: :title, # 初期画面
  score: 0,      # 現在のスコア
}

# メインループ
Window.load_resources do
  #プレイヤークラスのインスタンス生成
  player = Player.new
  #敵クラスのインスタンス生成
  enemy = []
  for i in 1..5 do
    enemy[i] = Enemy.new
  end
  #弾クラスのインスタンス生成
  bullet = Bullet.new
  #弾を表示させるフラグ
  bullet_flag = 0

  Window.loop do
    # シーンごとの処理
    case GAME_INFO[:scene]
    # タイトル画面
    when :title
      Window.draw_font(300, 100, "PRESS SPACE: Start the game", Font.default)
      Window.draw_font(300, 130, "W: up", Font.default)
      Window.draw_font(300, 160, "A: left", Font.default)
      Window.draw_font(300, 190, "S: down", Font.default)
      Window.draw_font(300, 220, "D: right", Font.default)
      Window.draw_font(300, 250, "SPACE: shoot", Font.default)
      # スペースキーが押されたらシーンを変える
      if Input.key_push?(K_SPACE)
        GAME_INFO[:scene] = :playing
      end

    #ゲーム中
    when :playing
      Window.draw_font(10, 30, "SCORE: #{GAME_INFO[:score]}", Font.default)
      player.update
      player.draw #プレイヤーの表示
      for i in 1..5 do
        enemy[i].update
        enemy[i].draw
      end
      # フラグが立っていたらbullet.initializeを呼びたくない
      if Input.key_push?(K_SPACE) && bullet_flag == 0
        bullet_flag = 1
        #プレイヤーの位置に弾の座標を入力するため、明示的にinitializeを呼び出す
        bullet.initialize(player.x, player.y)
      end
      # フラグが立っていたら弾を出力
      if bullet_flag == 1
        bullet.update
        bullet.draw
      end
      # 弾が画面端に到達したらフラグを0に戻して弾の状態を元に戻す
      if bullet.y < 0
        bullet_flag = 0
        bullet.initialize(player.x, player.y)
      end
      #弾と敵が接触した場合
      for i in 1..5 do
        if bullet === enemy[i]
          enemy[i].initialize
          GAME_INFO[:score] += 10
        end
      end
      #敵とプレイヤーが接触した場合
      for i in 1..5 do
        if player === enemy[i]
          GAME_INFO[:scene] = :game_over
        end
      end

    #ゲームオーバー画面
    when :game_over
      Window.draw_font(Window.width / 2 - 250, Window.height / 2 - 100, "GAME OVER", Font.new(64), {:color => C_RED})
      Window.draw_font(Window.width / 2 - 100,  Window.height / 2 + 100, "SCORE: #{GAME_INFO[:score]}", Font.default)
      Window.draw_font(Window.width / 2 - 100, Window.height / 2 + 130, "PRESS SPACE: continue", Font.default)
      # スペースキーが押されたらゲームの状態をリセットし、シーンを変える
      if Input.key_push?(K_SPACE)
        GAME_INFO[:score] = 0
        #プレイヤーと敵を初期状態に戻す
        player.initialize
        for i in 1..5 do
          enemy[i].initialize
        end
        bullet.initialize(player.x, player.y)
        GAME_INFO[:scene] = :playing
      end
    end
  end
end
