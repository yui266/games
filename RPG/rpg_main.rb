require 'dxopal'
include DXOpal

#表示画面の大きさ
Window.width = 900
Window.height = 900

#ウィンドウの色(画像を指定しない場合この色になる)
Window.bgcolor = C_BLACK

Image.register(:title, "images/title.png")

# プレイヤークラス
class Player < Sprite
  #プレイヤーの大きさ
  Player_width = 50
  Player_height = 50
  # プレイヤーステータス
  @@HP = 1
  @@MP = 2
  @@STR = 3  # 攻撃力
  @@VIT = 4  # 防御力（バイタリティ）
  @@LV = 5   # レベル
  @@EXP = 6  # 経験値

  def initialize
    #プレイヤーイメージ
    player_img = Image.new(Player_width, Player_height, C_CYAN)
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
  # ステータス
  def status
    # それぞれのレベルのときのステータスがここで設定される
    if @@LV == 1
      @@HP = 30
      @@MP = 10
      @@STR = 5
      @@VIT = 0
    elsif @@LV == 2
      @@HP = 40
      @@MP = 20
      @@STR = 8
      @@VIT = 3
    elsif @@LV == 3
      @@HP = 50
      @@MP = 30
      @@STR = 11
      @@VIT = 6
    elsif @@LV == 4
      @@HP = 60
      @@MP = 40
      @@STR = 14
      @@VIT = 9
    elsif @@LV == 5
      @@HP = 70
      @@MP = 50
      @@STR = 17
      @@VIT = 9
    elsif @@LV == 6
      @@HP = 80
      @@MP = 60
      @@STR = 20
      @@VIT = 12
    elsif @@LV == 7
      @@HP = 90
      @@MP = 70
      @@STR = 23
      @@VIT = 15
    elsif @@LV == 8
      @@HP = 100
      @@MP = 80
      @@STR = 26
      @@VIT = 18
    elsif @@LV == 9
      @@HP = 110
      @@MP = 90
      @@STR = 29
      @@VIT = 21
    elsif @@LV == 10
      @@HP = 120
      @@MP = 100
      @@STR = 32
      @@VIT = 24
    end
  end
  # レベルアップ
  def LV_up(exp)
    # 入手したEXP量によってプレイヤーのレベルをここで決める
    @@EXP = exp
    if @@EXP < 30
      @@LV = 1
    elsif 30 <= @@EXP && @@EXP < 60 
      @@LV = 2
    elsif 60 <= @@EXP && @@EXP < 90
      @@LV = 3
    elsif 90 <= @@EXP && @@EXP < 120
      @@LV = 4
    elsif 120 <= @@EXP && @@EXP < 150
      @@LV = 5
    elsif 150 <= @@EXP && @@EXP < 180
      @@LV = 6
    elsif 180 <= @@EXP && @@EXP < 210
      @@LV = 7
    elsif 210 <= @@EXP && @@EXP < 240
      @@LV = 8
    elsif 240 <= @@EXP && @@EXP < 270
      @@LV = 9
    elsif 270 <= @@EXP && @@EXP
      @@LV = 10
    end
  end
  # 現在のステータスを返す
  def get_now_status
    return @@HP, @@MP, @@STR, @@VIT, @@LV, @@EXP
  end
end

#マップ画像を読み込み。クラス外で呼ばないとエラーが起きる
Image.register(:map1, 'images/1.png')
Image.register(:map2, 'images/2.png')
Image.register(:map3, 'images/3.png')
Image.register(:map4, 'images/4.png')
Image.register(:map5, 'images/5.png')
Image.register(:map6, 'images/6.png')
Image.register(:map7, 'images/7.png')
Image.register(:map8, 'images/8.png')
Image.register(:map9, 'images/9.png')

# マップクラス
class Map
  #スタート地点のマップ
  @@map_location = 1
  # 現在のマップ値を返す
  def get_map_location
    return @@map_location
  end
  def map1(player_x, player_y)
    Window.draw(0, 0, Image[:map1])
    # プレイヤーが右端に到達したら
    if player_x > Window.width - 52
      @@map_location = 2
      player_x = 2
    # プレイヤーが上端に到達したら
    elsif player_y < 2
      @@map_location = 4
      player_y = Window.height - 52
    end
    return player_x, player_y
  end
  def map2(player_x, player_y)
    Window.draw(0, 0, Image[:map2])
    # プレイヤーが右端に到達したら
    if player_x > Window.width - 52
      @@map_location = 3
      player_x = 2
    # プレイヤーが上端に到達したら
    elsif player_y < 2
      @@map_location = 5
      player_y = Window.height - 52
    # プレイヤーが左端に到達したら
    elsif player_x < 2
      @@map_location = 1
      player_x = Window.width - 52
    end
    return player_x, player_y
  end
  def map3(player_x, player_y)
    Window.draw(0, 0, Image[:map3])
    # プレイヤーが上端に到達したら
    if player_y < 2
      @@map_location = 6
      player_y = Window.height - 52
    # プレイヤーが左端に到達したら
    elsif player_x < 2
      @@map_location = 2
      player_x = Window.width - 52
    end
    return player_x, player_y
  end
  def map4(player_x, player_y)
    Window.draw(0, 0, Image[:map4])
    # プレイヤーが右端に到達したら
    if player_x > Window.width - 52
      @@map_location = 5
      player_x = 2
    # プレイヤーが上端に到達したら
    elsif player_y < 2
      @@map_location = 7
      player_y = Window.height - 52
    # プレイヤーが下端に到達したら
    elsif player_y > Window.height - 52
      @@map_location = 1
      player_y = 2
    end
    return player_x, player_y
  end
  def map5(player_x, player_y)
    Window.draw(0, 0, Image[:map5])
    # プレイヤーが右端に到達したら
    if player_x > Window.width - 52
      @@map_location = 6
      player_x = 2
    # プレイヤーが上端に到達したら
    elsif player_y < 2
      @@map_location = 8
      player_y = Window.height - 52
    # プレイヤーが左端に到達したら
    elsif player_x < 2
      @@map_location = 4
      player_x = Window.width - 52
    # プレイヤーが下端に到達したら
    elsif player_y > Window.height - 52
      @@map_location = 2
      player_y = 2
    end
    return player_x, player_y
  end
  def map6(player_x, player_y)
    Window.draw(0, 0, Image[:map6])
    # プレイヤーが上端に到達したら
    if player_y < 2
      @@map_location = 9
      player_y = Window.height - 52
    # プレイヤーが左端に到達したら
    elsif player_x < 2
      @@map_location = 5
      player_x = Window.width - 52
    # プレイヤーが下端に到達したら
    elsif player_y > Window.height - 52
      @@map_location = 3
      player_y = 2
    end
    return player_x, player_y
  end
  def map7(player_x, player_y)
    Window.draw(0, 0, Image[:map7])
    # プレイヤーが右端に到達したら
    if player_x > Window.width - 52
      @@map_location = 8
      player_x = 2
    # プレイヤーが下端に到達したら
    elsif player_y > Window.height - 52
      @@map_location = 4
      player_y = 2
    end
    return player_x, player_y
  end
  def map8(player_x, player_y)
    Window.draw(0, 0, Image[:map8])
    # プレイヤーが右端に到達したら
    if player_x > Window.width - 52
      @@map_location = 9
      player_x = 2
    # プレイヤーが左端に到達したら
    elsif player_x < 2
      @@map_location = 7
      player_x = Window.width - 52
    # プレイヤーが下端に到達したら
    elsif player_y > Window.height - 52
      @@map_location = 5
      player_y = 2
    end
    return player_x, player_y
  end
  def map9(player_x, player_y)
    Window.draw(0, 0, Image[:map9])
    # プレイヤーが左端に到達したら
    if player_x < 2
      @@map_location = 8
      player_x = Window.width - 52
    # プレイヤーが下端に到達したら
    elsif player_y > Window.height - 52
      @@map_location = 6
      player_y = 2
    end
    return player_x, player_y
  end
end

# ゲームシーン
scene = "title" # 初期画面

# メインループ
Window.load_resources do
  #プレイヤークラスのインスタンス生成
  player = Player.new
  map = Map.new

  player_hp = 0
  player_mp = 0
  player_str = 0
  player_vit = 0
  player_lv = 0
  player_exp = 0

  Window.loop do
    # シーンごとの処理
    case scene
    # タイトル画面
    when "title"
      Window.draw(0, 0, Image[:title])
      Window.draw_font(300, 100, "PRESS SPACE: Start the game", Font.default)
      Window.draw_font(300, 130, "W: up", Font.default)
      Window.draw_font(300, 160, "A: left", Font.default)
      Window.draw_font(300, 190, "S: down", Font.default)
      Window.draw_font(300, 220, "D: right", Font.default)
      # スペースキーが押されたらシーンを変える
      if Input.key_push?(K_SPACE)
        scene = "playing"
      end

    #ゲーム中
    when "playing"
      #現在の経験値によってレベルを決める
      player.LV_up(player_exp)
      #現在のレベルによってステータスを決める
      player.status
      #ステータスそれぞれの値を入手
      player_hp, player_mp, player_str, player_vit, player_lv, player_exp = player.get_now_status
      # 現在のマップを読み込む
      map_location = map.get_map_location
      #プレイヤーの現在地によって呼ぶマップを変更
      if map_location == 1
        player.x, player.y = map.map1(player.x, player.y)
      elsif map_location == 2
        player.x, player.y = map.map2(player.x, player.y)
      elsif map_location == 3
        player.x, player.y = map.map3(player.x, player.y)
      elsif map_location == 4
        player.x, player.y = map.map4(player.x, player.y)
      elsif map_location == 5
        player.x, player.y = map.map5(player.x, player.y)
      elsif map_location == 6
        player.x, player.y = map.map6(player.x, player.y)
      elsif map_location == 7
        player.x, player.y = map.map7(player.x, player.y)
      elsif map_location == 8
        player.x, player.y = map.map8(player.x, player.y)
      elsif map_location == 9
        player.x, player.y = map.map9(player.x, player.y)
      end
      player.update
      player.draw #プレイヤーの表示

      # デバッグ用
      if Input.key_push?(K_ESCAPE)
        scene = "game_over"
      end

    #ゲームオーバー画面
    when "game_over"
      Window.draw_font(Window.width / 2 - 250, Window.height / 2 - 100, "GAME OVER", Font.new(64), {:color => C_RED})
      Window.draw_font(Window.width / 2 - 100, Window.height / 2 + 130, "PRESS SPACE: continue", Font.default)
      # スペースキーが押されたらゲームの状態をリセットし、シーンを変える
      if Input.key_push?(K_SPACE)
        scene = "playing"
      end
    end
  end
end
