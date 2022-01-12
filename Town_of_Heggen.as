package
{
	import flash.display.*;
	import flash.events.*;
	import flash.media.*;
	import flash.net.*;
	import flash.ui.*;
	import flash.utils.*;
	
	public class Town_of_Heggen extends MovieClip
	{
		/* Server Related */
		var server_socket:Socket;
		var server_ip:String = "localhost";
		var SERVER_PORT:int = 8192
		var server_port:int = 8192;
		
		/* Engine System Related */
		const FPS:int = 60;
		var loop_timer:Timer = new Timer (1000/FPS, 0);
		var pos_timer:Timer = new Timer (1000/10, 0);
		
		/* Game Related */
		var player_names:Array = new Array ();
		var input_left:Boolean = false;
		var input_right:Boolean = false;
		var input_attack:Boolean = false;
		var pos_x:int = ((Math.random () * 9542841) % 3200 + 410);
		
		var player_pos:Array = new Array (10000, 10000, 10000, 10000, 10000, 10000, 10000);
		var player_network:Array;
		
		var health:Number = 100;
		
		var enemy_pos:Array = new Array ();
		
		var enemy_pos1:Number = 4000;
		var enemy_pos2:Number = 4000;
		var enemy_pos3:Number = 4000;
		var enemy_pos4:Number = 4000;
		var enemy_pos5:Number = 4000;
		var enemy_pos6:Number = 4000;
		var enemy_pos7:Number = 4000;
		var enemy_pos8:Number = 4000;
		var enemy_pos9:Number = 4000;
		var enemy_pos10:Number = 4000;
		var enemy_pos11:Number = 4000;
		var enemy_pos12:Number = 4000;
		
		var enemy_health1:int = 90;
		var enemy_health2:int = 40;
		var enemy_health3:int = 30;
		var enemy_health4:int = 90;
		var enemy_health5:int = 40;
		var enemy_health6:int = 30;
		var enemy_health7:int = 90;
		var enemy_health8:int = 40;
		var enemy_health9:int = 30;
		var enemy_health10:int = 90;
		var enemy_health11:int = 40;
		var enemy_health12:int = 30;
		const HIT_HEALTH:int = 2;
		
		var enemy_attack1:int = 0;
		var enemy_attack2:int = 0;
		var enemy_attack3:int = 0;
		var enemy_attack4:int = 0;
		var enemy_attack5:int = 0;
		var enemy_attack6:int = 0;
		var enemy_attack7:int = 0;
		var enemy_attack8:int = 0;
		var enemy_attack9:int = 0;
		var enemy_attack10:int = 0;
		var enemy_attack11:int = 0;
		var enemy_attack12:int = 0;
		
		var dir_x:int;
		var score:int = 0;
		const SPEED:Number = 3;
		var sent_position:int = 0;
		var sword_timer:int = 0;
		var looking_dir:int = 1;
		var walk_anim:int = 0;
		var camera_pos_x:Number = 0;
		var ability_selected_player:int = 0;
		var ability_selected:int = 0;
		var game_timer:int = 0;
		var game_state:int = 1;
		var chat:Array = new Array ();
		var maister:int = 0;
		var hit_file:Class;
		var attack_file:Class;
		var die_file:Class;
		var score_file:Class;
		var hit_sound:Sound;
		var attack_sound:Sound;
		var die_sound:Sound;
		var score_sound:Sound;
		var use_sound:Boolean = true;
		
		public function Town_of_Heggen()
		{
			player_network = new Array (Player_Network1, Player_Network2, Player_Network3, Player_Network4, Player_Network5, Player_Network6, Player_Network7);
			
			connect_button.visible = true;
			input_ip.visible = true;
			input_name.visible = true;
			chat_history.visible = false;
			chat_input.visible = false;
			chat_send.visible = false;
			Map1_Sprite.visible = false;
			Map2_Sprite.visible = false;
			Map3_Sprite.visible = false;
			Map4_Sprite.visible = false;
			Player_Sprite.visible = false;
			Player_Network1.visible = false;
			Player_Network2.visible = false;
			Player_Network3.visible = false;
			Player_Network4.visible = false;
			Player_Network5.visible = false;
			Player_Network6.visible = false;
			Player_Network7.visible = false;
			Enemy_Sprite1.visible = false;
			Enemy_Sprite2.visible = false;
			Enemy_Sprite3.visible = false;
			Enemy_Sprite4.visible = false;
			Enemy_Sprite5.visible = false;
			Enemy_Sprite6.visible = false;
			Enemy_Sprite7.visible = false;
			Enemy_Sprite8.visible = false;
			Enemy_Sprite9.visible = false;
			Enemy_Sprite10.visible = false;
			Enemy_Sprite11.visible = false;
			Enemy_Sprite12.visible = false;
			Sword_Sprite.visible = false;
			left_button.visible = false;
			right_button.visible = false;
			attack_button.visible = false;
			Player_Health.visible = false;
			Player_Score.visible = false;
			Enemy_Health1.visible = false;
			Enemy_Health2.visible = false;
			Enemy_Health3.visible = false;
			Enemy_Health4.visible = false;
			Enemy_Health5.visible = false;
			Enemy_Health6.visible = false;
			Enemy_Health7.visible = false;
			Enemy_Health8.visible = false;
			Enemy_Health9.visible = false;
			Enemy_Health10.visible = false;
			Enemy_Health11.visible = false;
			Enemy_Health12.visible = false;
			Mute_Button.visible = false;
			output.visible = true;
			UnMute_Button.visible = false;
			Mute_Button.visible = true;
			chat_back.visible = false;
			chat_background.visible = false;
			chat_send.visible = false;
			
			hit_file = Class (getDefinitionByName ("Hit_Sound"));
			attack_file = Class (getDefinitionByName ("Attack_Sound"));
			die_file = Class (getDefinitionByName ("Die_Sound"));
			score_file = Class (getDefinitionByName ("Score_Sound"));
			hit_sound = new hit_file ();
			attack_sound = new attack_file ();
			die_sound = new die_file ();
			score_sound = new score_file ();
			
			Mute_Button.addEventListener (MouseEvent.CLICK, Sound_Button);
			UnMute_Button.addEventListener (MouseEvent.CLICK, UnSound_Button);
			
			chat[0] = "";
			chat[1] = "";
			chat[2] = "";
			chat[3] = "";
			chat[4] = "";
			chat[5] = "";
			chat[6] = "";
			chat[7] = "";
			chat[8] = "";
			chat[9] = "";
			chat[10] = "";
			
			connect_button.addEventListener (MouseEvent.CLICK, Connect_Handler);
			if (Multitouch.maxTouchPoints > 1)
			{
				Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
				connect_button.addEventListener (TouchEvent.TOUCH_TAP, Connect_Handler);
			}
		}
		
		public function Connect_Handler (foo:MouseEvent):void
		{
			player_names[0] = input_name.text;
			server_ip = input_ip.text;
			connect_button.removeEventListener (MouseEvent.CLICK, Connect_Handler);
			input_ip.visible = true;
			input_name.visible = true;
			connect_button.visible = false;
			Title.visible = true;
			input_ip.text = "ERROR";
			input_name.text = "SERVER DOWN!";
			
			server_socket = new Socket (server_ip, SERVER_PORT);
			server_socket.addEventListener (Event.CONNECT, Socket_Connected);
			server_socket.addEventListener (Event.CLOSE, Socket_Closed);
			server_socket.addEventListener (ProgressEvent.SOCKET_DATA, Socket_Data);

			return;
		}
		
		public function Init_Game_Loop ():void
		{
			loop_timer.addEventListener (TimerEvent.TIMER, Game_Loop);
			loop_timer.start ();
			pos_timer.addEventListener (TimerEvent.TIMER, Send_Pos);
			pos_timer.start ();
			Player_Sprite.visible = true;
			Player_Network1.visible = true;
			Player_Network2.visible = true;
			Player_Network3.visible = true;
			Player_Network4.visible = true;
			Player_Network5.visible = true;
			Player_Network6.visible = true;
			Player_Network7.visible = true;
			Enemy_Sprite1.visible = true;
			Enemy_Sprite2.visible = true;
			Enemy_Sprite3.visible = true;
			Enemy_Sprite4.visible = true;
			Enemy_Sprite5.visible = true;
			Enemy_Sprite6.visible = true;
			Enemy_Sprite7.visible = true;
			Enemy_Sprite8.visible = true;
			Enemy_Sprite9.visible = true;
			Enemy_Sprite10.visible = true;
			Enemy_Sprite11.visible = true;
			Enemy_Sprite12.visible = true;
			chat_history.visible = true;
			chat_input.visible = true;
			chat_send.visible = true;
			chat_back.visible = true;
			chat_background.visible = true;
			chat_send.visible = true;
			Sword_Sprite.visible = true;
			Player_Health.visible = true;
			Player_Score.visible = true;
			Enemy_Health1.visible = true;
			Enemy_Health2.visible = true;
			Enemy_Health3.visible = true;
			Enemy_Health4.visible = true;
			Enemy_Health5.visible = true;
			Enemy_Health6.visible = true;
			Enemy_Health7.visible = true;
			Enemy_Health8.visible = true;
			Enemy_Health9.visible = true;
			Enemy_Health10.visible = true;
			Enemy_Health11.visible = true;
			Enemy_Health12.visible = true;
			Mute_Button.visible = true;
			input_ip.visible = false;
			input_name.visible = false;
			connect_button.visible = false;
			Title.visible = false;
			chat_send.addEventListener (MouseEvent.CLICK, Chat_Send);
			pos_x = (((Math.random () * 10000) % (4100-420)) + 410);
			
			stage.addEventListener (KeyboardEvent.KEY_DOWN, Input_Handler);
			stage.addEventListener (KeyboardEvent.KEY_UP, Input_Handler);
			
			// TouchScreen
			if (Multitouch.maxTouchPoints > 1)
			{
				left_button.visible = true;
				right_button.visible = true;
				attack_button.visible = true;
				left_button.addEventListener (TouchEvent.TOUCH_BEGIN, Left_Handler);
				right_button.addEventListener (TouchEvent.TOUCH_BEGIN, Right_Handler);
				attack_button.addEventListener (TouchEvent.TOUCH_BEGIN, Attack_Handler);
				left_button.addEventListener (TouchEvent.TOUCH_END, Left_Handler);
				right_button.addEventListener (TouchEvent.TOUCH_END, Right_Handler);
				attack_button.addEventListener (TouchEvent.TOUCH_END, Attack_Handler);
			}
			
			return;
		}
		function Left_Handler (foo:TouchEvent):void
		{
			if (foo.type == TouchEvent.TOUCH_BEGIN)
			{
				input_left = true;
			}
			else
			{
				input_left = false;
			}
			
			return;
		}
		function Right_Handler (foo:TouchEvent):void
		{
			if (foo.type == TouchEvent.TOUCH_BEGIN)
			{
				input_right = true;
			}
			else
			{
				input_right = false;
			}
			
			return;
		}
		function Attack_Handler (foo:TouchEvent):void
		{
			if (foo.type == TouchEvent.TOUCH_BEGIN)
			{
				input_attack = true;
			}
			else
			{
				input_attack = false;
			}
			
			return;
		}
		function Sound_Button (foo:MouseEvent):void
		{
			use_sound = (use_sound)?(false):(true);
			UnMute_Button.visible = true;
			Mute_Button.visible = false;
		}
		function UnSound_Button (foo:MouseEvent):void
		{
			use_sound = (use_sound)?(false):(true);
			UnMute_Button.visible = false;
			Mute_Button.visible = true;
		}
		public function Game_Loop (foo:Event):void
		{	
			if (maister)
			{
				/* Game_Loop */
				dir_x = 0;
				if (input_attack)
				{
					/* Spawn weapon */
					sword_timer = 14;
					Sword_Sprite.y = 270;
					if (looking_dir == -1)
					{
						Sword_Sprite.rotation = 0;
					}
					else
					{
						Sword_Sprite.rotation = 0;
					}
					if (use_sound)
					{
						hit_sound.play ();
					}
				}
				else if (input_left)
				{
					dir_x = -SPEED;
					looking_dir = -1;
					
					if (walk_anim == 0)
					{
						if (Player_Sprite.y == 265)
						{
							Player_Sprite.y = 267;
						}
						else if (Player_Sprite.y == 267)
						{
							Player_Sprite.y = 269;
						}
						else if (Player_Sprite.y == 269)
						{
							walk_anim = 1;
						}
					}
					else
					{
						if (Player_Sprite.y == 269)
						{
							Player_Sprite.y = 267;
						}
						else if (Player_Sprite.y == 267)
						{
							Player_Sprite.y = 265;
						}
						else if (Player_Sprite.y == 265)
						{
							walk_anim = 0;
						}
					}
					
				}
				else if (input_right)
				{
					dir_x = SPEED;
					looking_dir = 1;
					
					if (walk_anim == 0)
					{
						if (Player_Sprite.y == 265)
						{
							Player_Sprite.y = 267;
						}
						else if (Player_Sprite.y == 267)
						{
							Player_Sprite.y = 269;
						}
						else if (Player_Sprite.y == 269)
						{
							walk_anim = 1;
						}
					}
					else
					{
						if (Player_Sprite.y == 269)
						{
							Player_Sprite.y = 267;
						}
						else if (Player_Sprite.y == 267)
						{
							Player_Sprite.y = 265;
						}
						else if (Player_Sprite.y == 265)
						{
							walk_anim = 0;
						}
					}
				}
				pos_x += dir_x;
				Sword_Sprite.x = 320;
				Player_Sprite.scaleX = looking_dir;
				if (sword_timer == 0)
				{
					Sword_Sprite.y = 1000;
				}
				Sword_Sprite.rotation += (10 * looking_dir);
				
				
				if (health < 0)
				{
					Server_Send (("5202\t" + score.toString () + "\n"));
					health = 100;
					pos_x = (((Math.random () * 10000) % 3200) + 410);
					score = 0;
					if (use_sound)
					{
						die_sound.play ();
					}
				}
				
				Player_Health.text = health.toString ();
				Player_Health.x = 295;
				Player_Health.y = (195 - (265 - Player_Sprite.y));
				Player_Score.text = score.toString ();
				Player_Score.y = (310 - (265 - Player_Sprite.y));
				Player_Score.x = 295;
				
				/* Enemies */
				Enemy_Health1.text = enemy_health1.toString ();
				Enemy_Health1.x = Enemy_Sprite1.x - 25;
				Enemy_Health1.y = (206 - (270 - Enemy_Sprite1.y));
				Enemy_Health2.text = enemy_health2.toString ();
				Enemy_Health2.x = Enemy_Sprite2.x - 25;
				Enemy_Health2.y = (215 - (275 - Enemy_Sprite2.y));
				Enemy_Health3.text = enemy_health3.toString ();
				Enemy_Health3.x = Enemy_Sprite3.x - 25;
				Enemy_Health3.y = (210 - (276 - Enemy_Sprite3.y));
				Enemy_Health4.text = enemy_health4.toString ();
				Enemy_Health4.x = Enemy_Sprite4.x - 25;
				Enemy_Health4.y = (206 - (270 - Enemy_Sprite4.y));
				Enemy_Health5.text = enemy_health5.toString ();
				Enemy_Health5.x = Enemy_Sprite5.x - 25;
				Enemy_Health5.y = (215 - (275 - Enemy_Sprite5.y));
				Enemy_Health6.text = enemy_health6.toString ();
				Enemy_Health6.x = Enemy_Sprite6.x - 25;
				Enemy_Health6.y = (210 - (276 - Enemy_Sprite6.y));
				Enemy_Health7.text = enemy_health7.toString ();
				Enemy_Health7.x = Enemy_Sprite7.x - 25;
				Enemy_Health7.y = (206 - (270 - Enemy_Sprite7.y));
				Enemy_Health8.text = enemy_health8.toString ();
				Enemy_Health8.x = Enemy_Sprite8.x - 25;
				Enemy_Health8.y = (215 - (275 - Enemy_Sprite8.y));
				Enemy_Health9.text = enemy_health9.toString ();
				Enemy_Health9.x = Enemy_Sprite9.x - 25;
				Enemy_Health9.y = (210 - (276 - Enemy_Sprite9.y));
				Enemy_Health10.text = enemy_health10.toString ();
				Enemy_Health10.x = Enemy_Sprite10.x - 25;
				Enemy_Health10.y = (206 - (270 - Enemy_Sprite10.y));
				Enemy_Health11.text = enemy_health11.toString ();
				Enemy_Health11.x = Enemy_Sprite11.x - 25;
				Enemy_Health11.y = (215 - (275 - Enemy_Sprite11.y));
				Enemy_Health12.text = enemy_health12.toString ();
				Enemy_Health12.x = Enemy_Sprite12.x - 25;
				Enemy_Health12.y = (210 - (276 - Enemy_Sprite12.y));
				
				Enemy_Sprite1.scaleX = -1;
				Enemy_Sprite2.scaleX = -1;
				Enemy_Sprite3.scaleX = -1;
				Enemy_Sprite4.scaleX = 1;
				Enemy_Sprite5.scaleX = 1;
				Enemy_Sprite6.scaleX = 1;
				Enemy_Sprite7.scaleX = -1;
				Enemy_Sprite8.scaleX = -1;
				Enemy_Sprite9.scaleX = -1;
				Enemy_Sprite10.scaleX = 1;
				Enemy_Sprite11.scaleX = 1;
				Enemy_Sprite12.scaleX = 1;

				Enemy_Sprite1.x = enemy_pos1 - pos_x + 320;
				Enemy_Sprite2.x = enemy_pos2 - pos_x + 320;
				Enemy_Sprite3.x = enemy_pos3 - pos_x + 320;
				Enemy_Sprite4.x = enemy_pos4 - pos_x + 320;
				Enemy_Sprite5.x = enemy_pos5 - pos_x + 320;
				Enemy_Sprite6.x = enemy_pos6 - pos_x + 320;
				Enemy_Sprite7.x = enemy_pos7 - pos_x + 320;
				Enemy_Sprite8.x = enemy_pos8 - pos_x + 320;
				Enemy_Sprite9.x = enemy_pos9 - pos_x + 320;
				Enemy_Sprite10.x = enemy_pos10 - pos_x + 320;
				Enemy_Sprite11.x = enemy_pos11 - pos_x + 320;
				Enemy_Sprite12.x = enemy_pos12 - pos_x + 320;
				
				
				
				if (Sword_Sprite.hitTestObject (Enemy_Sprite1))
				{
					enemy_attack1 += 1;
				}
				if (Sword_Sprite.hitTestObject (Enemy_Sprite2))
				{
					enemy_attack2 += 1;
				}
				if (Sword_Sprite.hitTestObject (Enemy_Sprite3))
				{
					enemy_attack3 += 1;
				}
				if (Sword_Sprite.hitTestObject (Enemy_Sprite4))
				{
					enemy_attack4 += 1;
				}
				if (Sword_Sprite.hitTestObject (Enemy_Sprite5))
				{
					enemy_attack5 += 1;
				}
				if (Sword_Sprite.hitTestObject (Enemy_Sprite6))
				{
					enemy_attack6 += 1;
				}
				if (Sword_Sprite.hitTestObject (Enemy_Sprite7))
				{
					enemy_attack7 += 1;
				}
				if (Sword_Sprite.hitTestObject (Enemy_Sprite8))
				{
					enemy_attack8 += 1;
				}
				if (Sword_Sprite.hitTestObject (Enemy_Sprite9))
				{
					enemy_attack9 += 1;
				}
				if (Sword_Sprite.hitTestObject (Enemy_Sprite10))
				{
					enemy_attack10 += 1;
				}
				if (Sword_Sprite.hitTestObject (Enemy_Sprite11))
				{
					enemy_attack11 += 1;
				}
				if (Sword_Sprite.hitTestObject (Enemy_Sprite12))
				{
					enemy_attack12 += 1;
				}
				
				if (Enemy_Sprite1.hitTestObject (Player_Sprite))
				{
					health -= HIT_HEALTH;
					if (use_sound)
					{
						attack_sound.play ();
					}
				}
				if (Enemy_Sprite2.hitTestObject (Player_Sprite))
				{
					health -= HIT_HEALTH;
					if (use_sound)
					{
						attack_sound.play ();
					}
				}
				if (Enemy_Sprite3.hitTestObject (Player_Sprite))
				{
					health -= HIT_HEALTH;
					if (use_sound)
					{
						attack_sound.play ();
					}
				}
				if (Enemy_Sprite4.hitTestObject (Player_Sprite))
				{
					health -= HIT_HEALTH;
					if (use_sound)
					{
						attack_sound.play ();
					}
				}
				if (Enemy_Sprite5.hitTestObject (Player_Sprite))
				{
					health -= HIT_HEALTH;
					if (use_sound)
					{
						attack_sound.play ();
					}
				}
				if (Enemy_Sprite6.hitTestObject (Player_Sprite))
				{
					health -= HIT_HEALTH;
					if (use_sound)
					{
						attack_sound.play ();
					}
				}
				if (Enemy_Sprite7.hitTestObject (Player_Sprite))
				{
					health -= HIT_HEALTH;
					if (use_sound)
					{
						attack_sound.play ();
					}
				}
				if (Enemy_Sprite8.hitTestObject (Player_Sprite))
				{
					health -= HIT_HEALTH;
					if (use_sound)
					{
						attack_sound.play ();
					}
				}
				if (Enemy_Sprite9.hitTestObject (Player_Sprite))
				{
					health -= HIT_HEALTH;
					if (use_sound)
					{
						attack_sound.play ();
					}
				}
				if (Enemy_Sprite10.hitTestObject (Player_Sprite))
				{
					health -= HIT_HEALTH;
					if (use_sound)
					{
						attack_sound.play ();
					}
				}
				if (Enemy_Sprite11.hitTestObject (Player_Sprite))
				{
					health -= HIT_HEALTH;
					if (use_sound)
					{
						attack_sound.play ();
					}
				}
				if (Enemy_Sprite12.hitTestObject (Player_Sprite))
				{
					health -= HIT_HEALTH;
					if (use_sound)
					{
						attack_sound.play ();
					}
				}
				
				if (game_state == 1)
				{
					Player_Network1.y = 244;
					Player_Network2.y = 274;
					Player_Network3.y = 236;
					Player_Network4.y = 294;
					Player_Network5.y = 300;
					Player_Network6.y = 314;
					Player_Network7.y = 315;
					Enemy_Sprite1.y = 270;
					Enemy_Sprite2.y = 275;
					Enemy_Sprite3.y = 276;
					Enemy_Sprite4.y = 270;
					Enemy_Sprite5.y = 275;
					Enemy_Sprite6.y = 276;
					Enemy_Sprite7.y = 270;
					Enemy_Sprite8.y = 275;
					Enemy_Sprite9.y = 276;
					Enemy_Sprite10.y = 270;
					Enemy_Sprite11.y = 275;
					Enemy_Sprite12.y = 276;
				}
				else if (game_state == 2)
				{
					Player_Network1.y = 246;
					Player_Network2.y = 276;
					Player_Network3.y = 238;
					Player_Network4.y = 296;
					Player_Network5.y = 302;
					Player_Network6.y = 316;
					Player_Network7.y = 317;
					Enemy_Sprite1.y = 272;
					Enemy_Sprite2.y = 277;
					Enemy_Sprite3.y = 278;
					Enemy_Sprite4.y = 272;
					Enemy_Sprite5.y = 277;
					Enemy_Sprite6.y = 278;
					Enemy_Sprite7.y = 272;
					Enemy_Sprite8.y = 277;
					Enemy_Sprite9.y = 278;
					Enemy_Sprite10.y = 272;
					Enemy_Sprite11.y = 277;
					Enemy_Sprite12.y = 278;
				}
				else if (game_state == 3)
				{
					Player_Network1.y = 247;
					Player_Network2.y = 277;
					Player_Network3.y = 239;
					Player_Network4.y = 297;
					Player_Network5.y = 303;
					Player_Network6.y = 317;
					Player_Network7.y = 318;
					Enemy_Sprite1.y = 273;
					Enemy_Sprite2.y = 278;
					Enemy_Sprite3.y = 279;
					Enemy_Sprite4.y = 273;
					Enemy_Sprite5.y = 278;
					Enemy_Sprite6.y = 279;
					Enemy_Sprite7.y = 273;
					Enemy_Sprite8.y = 278;
					Enemy_Sprite9.y = 279;
					Enemy_Sprite10.y = 273;
					Enemy_Sprite11.y = 278;
					Enemy_Sprite12.y = 279;
				}
				else if (game_state == 4)
				{
					Player_Network1.y = 245;
					Player_Network2.y = 275;
					Player_Network3.y = 237;
					Player_Network4.y = 295;
					Player_Network5.y = 301;
					Player_Network6.y = 315;
					Player_Network7.y = 316;
					Enemy_Sprite1.y = 271;
					Enemy_Sprite2.y = 274;
					Enemy_Sprite3.y = 275;
					Enemy_Sprite4.y = 271;
					Enemy_Sprite5.y = 274;
					Enemy_Sprite6.y = 275;
					Enemy_Sprite7.y = 271;
					Enemy_Sprite8.y = 274;
					Enemy_Sprite9.y = 275;
					Enemy_Sprite10.y = 271;
					Enemy_Sprite11.y = 274;
					Enemy_Sprite12.y = 275;
				}
				
				/* Teleport */
				if (pos_x < 400)
				{
					pos_x = ((4096-1000) + pos_x);
				}
				if (pos_x > 3696)
				{
					pos_x = ((1000) - 400 + (pos_x - 3696));
				}
				
				/* End of each Frame */
				camera_pos_x = (2048 -(pos_x - 320));
				Map1_Sprite.x = camera_pos_x;
				Map2_Sprite.x = camera_pos_x;
				Map3_Sprite.x = camera_pos_x;
				Map4_Sprite.x = camera_pos_x;
				Player_Sprite.x = 320;
				for (var i:int = 0; i < 7; i++)
				{
					(player_network[i]).x = (player_pos[i] - pos_x + 320);
				}
				Player_Network1.x = player_pos[0] - pos_x + 320;
				Player_Network2.x = player_pos[1] - pos_x + 320;
				Player_Network3.x = player_pos[2] - pos_x + 320;
				Player_Network4.x = player_pos[3] - pos_x + 320;
				Player_Network5.x = player_pos[4] - pos_x + 320;
				Player_Network6.x = player_pos[5] - pos_x + 320;
				Player_Network7.x = player_pos[6] - pos_x + 320;
				if (game_state == 1)
				{
					Map1_Sprite.visible = true;
					Map2_Sprite.visible = false;
					Map3_Sprite.visible = false;
					Map4_Sprite.visible = false;
				}
				else if (game_state == 2)
				{
					Map1_Sprite.visible = false;
					Map2_Sprite.visible = true;
					Map3_Sprite.visible = false;
					Map4_Sprite.visible = false;
				}
				else if (game_state == 3)
				{
					Map1_Sprite.visible = false;
					Map2_Sprite.visible = false;
					Map3_Sprite.visible = true;
					Map4_Sprite.visible = false;
				}
				else if (game_state == 4)
				{
					Map1_Sprite.visible = false;
					Map2_Sprite.visible = false;
					Map3_Sprite.visible = false;
					Map4_Sprite.visible = true;
				}
				chat_history.text = chat[0];
				chat_history.text = chat_history.text.concat (chat[1]);
				chat_history.text = chat_history.text.concat (chat[2]);
				chat_history.text = chat_history.text.concat (chat[3]);
				chat_history.text = chat_history.text.concat (chat[4]);
				chat_history.text = chat_history.text.concat (chat[5]);
				chat_history.text = chat_history.text.concat (chat[6]);
				chat_history.text = chat_history.text.concat (chat[7]);
				chat_history.text = chat_history.text.concat (chat[8]);
				chat_history.text = chat_history.text.concat (chat[9]);
				chat_history.text = chat_history.text.concat (chat[10]);
				
				sword_timer--;
			}
			else
			{
				connect_button.visible = false;
				input_ip.visible = false;
				input_name.visible = false;
				chat_history.visible = false;
				chat_input.visible = false;
				chat_send.visible = false;
				Map1_Sprite.visible = false;
				Map2_Sprite.visible = false;
				Map3_Sprite.visible = false;
				Map4_Sprite.visible = false;
				
				Title.visible = true;
				input_ip.text = "SERVER DISCONNECTED!";
				input_name.text = "SERVER DOWN!";
				connect_button.visible = false;
				
				loop_timer.stop ();
				pos_timer.stop ();
			}
			
			return;
		}
		function Input_Handler (evt:KeyboardEvent):void
		{
			/* Left Arrow */
			if (evt.keyCode == 37)
			{
				if (evt.type == KeyboardEvent.KEY_DOWN)
				{
					input_left = true;
				}
				else
				{
					input_left = false;
				}
			}
			/* Right Arrow */
			if (evt.keyCode == 39)
			{
				if (evt.type == KeyboardEvent.KEY_DOWN)
				{
					input_right = true;
				}
				else
				{
					input_right = false;
				}
			}
			/* Ctrl */
			if (evt.keyCode == 17)
			{
				if (evt.type == KeyboardEvent.KEY_DOWN)
				{
					input_attack = true;
				}
				else
				{
					input_attack = false;
				}
			}
			
			/* Controller/Mobile */
			if (Multitouch.maxTouchPoints > 1)
			{
				if (evt.keyCode == 65)
				{
					if (evt.type == KeyboardEvent.KEY_DOWN)
					{
						input_left = true;
					}
					
				}
				if (evt.keyCode == 81)
				{
					if (evt.type == KeyboardEvent.KEY_DOWN)
					{
						input_left = false;
					}
					
				}	
				if (evt.keyCode == 68)
				{
					if (evt.type == KeyboardEvent.KEY_DOWN)
					{
						input_right = true;
					}
				}
				else if (evt.keyCode == 67)
				{
					if (evt.type == KeyboardEvent.KEY_DOWN)
					{
						input_right = false;
					}
				}
				if (evt.keyCode == 72)
				{
					if (evt.type == KeyboardEvent.KEY_DOWN)
					{
						input_attack = true;
					}
				}
				else if (evt.keyCode == 82)
				{
					if (evt.type == KeyboardEvent.KEY_DOWN)
					{
						input_attack = false;
					}
				}
			}
			
			return;
		}
		
		public function Chat_Send (foo:MouseEvent):void
		{
			Server_Send ("3031\t" + player_names[0] + "\t" + chat_input.text + "\n");
			chat_input.text = "";
			
			return;
		}
		public function Send_Pos (foo:TimerEvent):void
		{
			var message:String = new String ();
			message = "5021 ";
			message = message.concat (pos_x.toString ());
			message = message.concat (" ");
			message = message.concat (looking_dir.toString ());
			message = message.concat (" ");
			message = message.concat (enemy_attack1.toString ());
			message = message.concat (" ");
			message = message.concat (enemy_attack2.toString ());
			message = message.concat (" ");
			message = message.concat (enemy_attack3.toString ());
			message = message.concat (" ");
			message = message.concat (enemy_attack4.toString ());
			message = message.concat (" ");
			message = message.concat (enemy_attack5.toString ());
			message = message.concat (" ");
			message = message.concat (enemy_attack6.toString ());
			message = message.concat (" ");
			message = message.concat (enemy_attack7.toString ());
			message = message.concat (" ");
			message = message.concat (enemy_attack8.toString ());
			message = message.concat (" ");
			message = message.concat (enemy_attack9.toString ());
			message = message.concat (" ");
			message = message.concat (enemy_attack10.toString ());
			message = message.concat (" ");
			message = message.concat (enemy_attack11.toString ());
			message = message.concat (" ");
			message = message.concat (enemy_attack12.toString ());
			message = message.concat ("\n");
			
			Server_Send (message);
			
			if (enemy_health1 - enemy_attack1 <= 0)
			{
				score += 30;
				if (use_sound)
				{
					score_sound.play ();
				}
			}
			enemy_attack1 = 0;
			if (enemy_health2 - enemy_attack2 <= 0)
			{
				score += 30;
				if (use_sound)
				{
					score_sound.play ();
				}
			}
			enemy_attack2 = 0;
			if (enemy_health3 - enemy_attack3 <= 0)
			{
				score += 30;
				if (use_sound)
				{
					score_sound.play ();
				}
			}
			enemy_attack3 = 0;
			if (enemy_health4 - enemy_attack4 <= 0)
			{
				score += 30;
				if (use_sound)
				{
					score_sound.play ();
				}
			}
			enemy_attack4 = 0;
			if (enemy_health5 - enemy_attack5 <= 0)
			{
				score += 30;
				if (use_sound)
				{
					score_sound.play ();
				}
			}
			enemy_attack5 = 0;
			if (enemy_health6 - enemy_attack6 <= 0)
			{
				score += 30;
				if (use_sound)
				{
					score_sound.play ();
				}
			}
			enemy_attack6 = 0;
			if (enemy_health7 - enemy_attack7 <= 0)
			{
				score += 30;
				if (use_sound)
				{
					score_sound.play ();
				}
			}
			enemy_attack7 = 0;
			if (enemy_health8 - enemy_attack8 <= 0)
			{
				score += 30;
				if (use_sound)
				{
					score_sound.play ();
				}
			}
			enemy_attack8 = 0;
			if (enemy_health9 - enemy_attack9 <= 0)
			{
				score += 30;
				if (use_sound)
				{
					score_sound.play ();
				}
			}
			enemy_attack9 = 0;
			if (enemy_health10 - enemy_attack10 <= 0)
			{
				score += 30;
				if (use_sound)
				{
					score_sound.play ();
				}
			}
			enemy_attack10 = 0;
			if (enemy_health11 - enemy_attack11 <= 0)
			{
				score += 30;
				if (use_sound)
				{
					score_sound.play ();
				}
			}
			enemy_attack11 = 0;
			if (enemy_health12 - enemy_attack12 <= 0)
			{
				score += 30;
				if (use_sound)
				{
					score_sound.play ();
				}
			}
			enemy_attack12 = 0;
			
		}
		
		
		public function Socket_Connected (foo:Event):void
		{
			output.text = "Socket Connected";
			Server_Send (player_names[0] + "\n");
			maister = 1;
			Init_Game_Loop ();
		}
		public function Socket_Data (foo:Event):void
		{
			output.text = "Socket Data\n";
			var buffer_string:String = "";
			buffer_string = server_socket.readUTFBytes (server_socket.bytesAvailable);
			output.text = buffer_string;
			
			React_Data (buffer_string);
		}
		public function React_Data (foo:String)
		{
			if (foo == "\n")
				return;
			var disected_buffer:Array = foo.split ("\n");
			var bar:String = disected_buffer[0];
			disected_buffer = new Array ();
			disected_buffer = bar.split ("\t");
			
			var type:int = int(disected_buffer[0]);
			var i:int = 0;
			var new_buffer:String = "";
			
			/* React based on what we got */
			if (type == 1001)
			{
				/* Game Tick/Ping */
				game_timer = disected_buffer[3]; /* GameTimer */
				game_state = disected_buffer[5]; /* GameState */
				i = 6;
				for (var j:int = 0; j < 7; j++)
				{
					player_pos[j] = disected_buffer[i++];
				}
				/*
				player_pos1 = disected_buffer[i++];
				player_pos2 = disected_buffer[i++];
				player_pos3 = disected_buffer[i++];
				player_pos4 = disected_buffer[i++];
				player_pos5 = disected_buffer[i++];
				player_pos6 = disected_buffer[i++];
				player_pos7 = disected_buffer[i++];*/
				Player_Network1.scaleX = disected_buffer[i++];
				Player_Network2.scaleX = disected_buffer[i++];
				Player_Network3.scaleX = disected_buffer[i++];
				Player_Network4.scaleX = disected_buffer[i++];
				Player_Network5.scaleX = disected_buffer[i++];
				Player_Network6.scaleX = disected_buffer[i++];
				Player_Network7.scaleX = disected_buffer[i++];
				enemy_pos1 = disected_buffer[i++];
				enemy_pos2 = disected_buffer[i++];
				enemy_pos3 = disected_buffer[i++];
				enemy_pos4 = disected_buffer[i++];
				enemy_pos5 = disected_buffer[i++];
				enemy_pos6 = disected_buffer[i++];
				enemy_pos7 = disected_buffer[i++];
				enemy_pos8 = disected_buffer[i++];
				enemy_pos9 = disected_buffer[i++];
				enemy_pos10 = disected_buffer[i++];
				enemy_pos11 = disected_buffer[i++];
				enemy_pos12 = disected_buffer[i++];
				enemy_health1 = disected_buffer[i++];
				enemy_health2 = disected_buffer[i++];
				enemy_health3 = disected_buffer[i++];
				enemy_health4 = disected_buffer[i++];
				enemy_health5 = disected_buffer[i++];
				enemy_health6 = disected_buffer[i++];
				enemy_health7 = disected_buffer[i++];
				enemy_health8 = disected_buffer[i++];
				enemy_health9 = disected_buffer[i++];
				enemy_health10 = disected_buffer[i++];
				enemy_health11 = disected_buffer[i++];
				enemy_health12 = disected_buffer[i++];
				//player_network_attack1 = disected_buffer[i++];
			}
			else if (type == 3031)
			{
				chat[0] = chat[1];
				chat[1] = chat[2];
				chat[2] = chat[3];
				chat[3] = chat[4];
				chat[4] = chat[5];
				chat[5] = chat[6];
				chat[6] = chat[7];
				chat[7] = chat[8];
				chat[8] = chat[9];
				chat[9] = chat[10];
				
				chat[10] = (disected_buffer[1] + ": " + disected_buffer[2]);
			
			}
		}
		public function Server_Send (foo:String):void
		{
			server_socket.writeUTFBytes (foo);
			server_socket.flush ();
			
			return;
		}
		public function Socket_Closed (foo:Event):void
		{
			output.text = "Socket Closed";
			maister = 0;
		}
		
	}
}