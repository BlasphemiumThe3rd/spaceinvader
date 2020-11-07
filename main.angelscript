#include "Collide.angelscript"
#include "MultiCollide.angelscript"
#include "GameOver.angelscript"
#include "Menu.angelscript"

int LimiteMisseis = 0;
int Pontos = 0;
int Vida = 100;

uint CorBranco = ARGB(150, 255, 255, 255);
uint CorAzulClaro = ARGB(150, 150, 238, 254);
uint VerdeClaro = ARGB(255, 50, 205, 50);

uint CorBrancoFull = ARGB(255, 255, 255, 255);

// Temporizador dos Tiros e Ateroides

uint Tempo = 0;
uint tempoUltimoAsteroide = 0;

///////////////////////////////

void main()
	{
		//SetWindowProperties("Ethanon Engine", 1024, 700, true, true, PF32BIT);
		UsePixelShaders(true);
		LoadScene("scenes/Menu.esc", "StartMenu", "UpdateMenu");

		LoadSprite("entities/asteroid64.png");
		LoadSprite("entities/asteroid642.png");
		LoadSprite("entities/asteroid643.png");
		
		//SetScaleFactor(GetScreenSize().x / 2048);
	}

// CallBack onSceneCreated
void startGame()
	{	
	float MetadeTelaX;
	float MetadeTelaY;
	vector2 TamanhoTela2 = GetScreenSize();

	MetadeTelaX = (TamanhoTela2.x / 2);
	MetadeTelaY = (TamanhoTela2.y) - 40;
	
	AddEntity("Heroi.ent", vector3(MetadeTelaX, MetadeTelaY, 0));

// Carga das Musicas e efeitos sonoros
	LoadSoundEffect("soundfx/shoot.mp3");
	LoadSoundEffect("soundfx/asteroid_explosion.mp3");
	LoadSoundEffect("soundfx/explosion.ogg");
	LoadSoundEffect("soundfx/hit.wav");
	
	LoadMusic("soundfx/musica.mp3");
	
// Toca Musica de Fundo
	PlaySample("soundfx/musica.mp3");
	LoopSample("soundfx/musica.mp3", true);

// Carrega Entidades do Health Bar

	AddEntity("PanelHealhtBar.ent", vector3(10, 10, 100));
	AddEntity("HealthBar.ent", vector3(12, 27, 99));
	AddEntity("bg_HealthBar.ent", vector3(10, 10, 98));
	}
	
// Callback onSceneUpdate
void UpdateGame()
	{
		DrawText(vector2(20, 42), "Score: " + Pontos, "Verdana20_shadow.fnt", CorBranco);
		
		// Funcao de Criacao dos Asteroides
		float MetadeTelaX;
		float MetadeTelaY;
		float PosicaoXAsteroide;
		float PosicaoYAsteroide;
		float RotacaoAsteroide;
		vector2 TamanhoTela2 = GetScreenSize();
		uint NumAsteroides = 1;
		
		MetadeTelaX = (TamanhoTela2.x / 2);
		MetadeTelaY = (TamanhoTela2.y) - 40;
		
		// Rotina que cria os asteroides aleatoreamente
		uint TempoCriaAsteroide = GetTime() - tempoUltimoAsteroide;
		
		if(NumAsteroides <= 10 && TempoCriaAsteroide >= 500)
			{
			PosicaoXAsteroide = randF(0, TamanhoTela2.x - 64);
			PosicaoYAsteroide = randF(0, 250) - 450;
			RotacaoAsteroide = randF(0, 360);
			AddEntity("Asteroide64.ent", vector3(PosicaoXAsteroide, PosicaoYAsteroide, 0), RotacaoAsteroide);
			NumAsteroides = NumAsteroides + 1;
			tempoUltimoAsteroide = GetTime();
			}
		if(NumAsteroides <= 20 && TempoCriaAsteroide >= 500 && Pontos > 500)
			{
			PosicaoXAsteroide = randF(0, TamanhoTela2.x - 64);
			PosicaoYAsteroide = randF(0, 250) - 450;
			RotacaoAsteroide = randF(0, 360);
			AddEntity("Asteroide642.ent", vector3(PosicaoXAsteroide, PosicaoYAsteroide, 0), RotacaoAsteroide);
			NumAsteroides = NumAsteroides + 1;
			tempoUltimoAsteroide = GetTime();
			}
		if(NumAsteroides <= 100 && TempoCriaAsteroide >= 500 && Pontos > 1000)
			{
			PosicaoXAsteroide = randF(0, TamanhoTela2.x - 64);
			PosicaoYAsteroide = randF(0, 250) - 450;
			RotacaoAsteroide = randF(0, 360);
			AddEntity("Asteroide643.ent", vector3(PosicaoXAsteroide, PosicaoYAsteroide, 0), RotacaoAsteroide);
			AddEntity("Asteroide64.ent", vector3(PosicaoXAsteroide, PosicaoYAsteroide, 0), RotacaoAsteroide);
			AddEntity("Asteroide642.ent", vector3(PosicaoXAsteroide, PosicaoYAsteroide, 0), RotacaoAsteroide);
			NumAsteroides = NumAsteroides + 3;
			tempoUltimoAsteroide = GetTime();
			}
	}

void ETHCallback_Heroi(ETHEntity@ Heroi)
	{
		ETHInput@ input = GetInputHandle();	
		vector2 movimento(0, 0);
		float VelocidadePadrao = UnitsPerSecond(450); // Normaliza o Vetor da Velocidade
		float VelocidadeX = VelocidadePadrao;
		float VelocidadeY = VelocidadePadrao;

// Rotinas que impedem o Heroi de sair da tela ------------------------------------------
		
		vector2 TamanhoTela = GetScreenSize();
		vector2 PosicaoNave = Heroi.GetPositionXY();
		
		if(PosicaoNave.x > TamanhoTela.x - 32)
			{
				Heroi.SetPositionX(TamanhoTela.x - 32);
			}

		if(PosicaoNave.y > TamanhoTela.y - 32)
			{
				Heroi.SetPositionY(TamanhoTela.y - 32);
			}
		
		if(PosicaoNave.x < 0 + 32)
			{
				Heroi.SetPositionX(0 + 32);
			}

		if(PosicaoNave.y < 0 + 32)
			{
				Heroi.SetPositionY(0 + 32);
			}

// Rotinas que controlam a Aceleração e Saída do Jogo -------------------------------------
		
		
		if(input.KeyDown(K_SHIFT))
			{
			VelocidadePadrao = VelocidadePadrao * 2;
			}

		if(input.KeyDown(K_ESC))
			{
			Exit();
			}

// Rotina de Tiro --------------------------------------------------------------------
	
		uint TempoPassadoUltimoTiro = GetTime() - Tempo;

		if(input.GetKeyState(K_CTRL) == KS_DOWN && TempoPassadoUltimoTiro > 400)
			{
				AddEntity("Missel.ent", Heroi.GetPosition());
				PlaySample("soundfx/shoot.mp3");
				Tempo = GetTime();
			}

// Rotinas que controlam a movimentação do Heroi -------------------------------------

		if(input.KeyDown(K_UP))
			{
			movimento.y = -1;
			//Heroi.SetAngle(0);
			}
			
		if(input.KeyDown(K_DOWN))
			{
			movimento.y = 1;
			//Heroi.SetAngle(-180);
			}

		if(input.KeyDown(K_LEFT))
			{
			movimento.x = -1;
			//Heroi.SetAngle(90);
			}

		if(input.KeyDown(K_RIGHT))
			{
			movimento.x = 1;
			//Heroi.SetAngle(-90);
			}
			
		movimento = normalize(movimento);
		Heroi.AddToPositionXY(movimento * VelocidadePadrao);
		
	}

// Destroi o Missel ao Sair da Tela
void ETHCallback_Missel(ETHEntity@ Missel)
	{
	vector2 DirecaoMissel(0, -1);
	float VelocidadeMissel = UnitsPerSecond(300);
	Missel.AddToPositionXY(DirecaoMissel * VelocidadeMissel);
	vector2 PosicaoMissel = Missel.GetPositionXY();
		
	if(PosicaoMissel.y < -100)
		{
		@Missel = DeleteEntity(Missel);	
		}
	}

// Destroi o Asteroide ao Sair da Tela e ao Colidir com o Missel
void ETHCallback_Asteroide64(ETHEntity@ Asteroide64)
	{
	vector2 TamanhoTela = GetScreenSize();
	vector2 DirecaoAsteroide(0, 1);
	float VelocidadeAsteroide = UnitsPerSecond(100);
	Asteroide64.AddToPositionXY(DirecaoAsteroide * VelocidadeAsteroide);
	vector2 PosicaoAsteroide = Asteroide64.GetPositionXY();
		
	// Colisao Asteroide e Missel

	ETHEntityArray Outras;

	if(Collide(Asteroide64, Outras) == true)
		{
		for(uint i = 0; i < Outras.size(); i++)
			{
			if(Outras[i].GetEntityName() == "Missel.ent")
				{
				DeleteEntity(Outras[i]);
				AddEntity("ExplosaoAsteroide.ent", Outras[i].GetPosition());
				
				Asteroide64.AddToInt("VidaAsteroide", -1);
				
				if(Asteroide64.GetInt("VidaAsteroide") == 0)
					{
					AddEntity("ExplosaoAsteroide.ent", Asteroide64.GetPosition());
					DeleteEntity(Asteroide64);
					PlaySample("soundfx/asteroid_explosion.mp3");
					Pontos = Pontos + 10;
					}
				}

			else if(Outras[i].GetEntityName() == "Heroi.ent")
				{
				//PlaySample("soundfx/asteroid_explosion.mp3");
				PlaySample("soundfx/hit.wav");
				AddEntity("ExplosaoAsteroide.ent", Outras[i].GetPosition());
				DeleteEntity(Asteroide64);

				if(Vida <= 0)
					{
					StopSample("soundfx/musica.mp3");
					LoadScene("scenes/GameOver.esc", "StartGameOver", "UpdateGameOver");
					}
				else
					{
					Vida = Vida - 10;
					}
				}
			}
		}
			
	if(PosicaoAsteroide.y > TamanhoTela.y + 64)
		{
		@Asteroide64 = DeleteEntity(Asteroide64);
		}

	}

//------------------------------------------------------------------------------------------

void ETHCallback_Asteroide642(ETHEntity@ Asteroide642)
	{
	vector2 TamanhoTela = GetScreenSize();
	vector2 DirecaoAsteroide(0, 1);
	float VelocidadeAsteroide = UnitsPerSecond(100);
	Asteroide642.AddToPositionXY(DirecaoAsteroide * (VelocidadeAsteroide * 1.5));
	vector2 PosicaoAsteroide = Asteroide642.GetPositionXY();
		
	// Colisao Asteroide e Missel

	ETHEntityArray Outras;

	if(Collide(Asteroide642, Outras) == true)
		{
		for(uint i = 0; i < Outras.size(); i++)
			{
			if(Outras[i].GetEntityName() == "Missel.ent")
				{
				DeleteEntity(Outras[i]);
				AddEntity("ExplosaoAsteroide.ent", Outras[i].GetPosition());
				
				Asteroide642.AddToInt("VidaAsteroide", -1);
				
				if(Asteroide642.GetInt("VidaAsteroide") == 0)
					{
					AddEntity("ExplosaoAsteroide.ent", Asteroide642.GetPosition());
					DeleteEntity(Asteroide642);
					PlaySample("soundfx/asteroid_explosion.mp3");
					Pontos = Pontos + 20;
					}
				}

			else if(Outras[i].GetEntityName() == "Heroi.ent")
				{
				//PlaySample("soundfx/asteroid_explosion.mp3");
				PlaySample("soundfx/hit.wav");
				AddEntity("ExplosaoAsteroide.ent", Outras[i].GetPosition());
				DeleteEntity(Asteroide642);

				if(Vida <= 0)
					{
					StopSample("soundfx/musica.mp3");
					LoadScene("scenes/GameOver.esc", "StartGameOver", "UpdateGameOver");
					}
				else
					{
					Vida = Vida - 20;
					}
				}
			}
		}
			
	if(PosicaoAsteroide.y > TamanhoTela.y + 64)
		{
		@Asteroide642 = DeleteEntity(Asteroide642);
		}

	}

//------------------------------------------------------------------------------------------

void ETHCallback_Asteroide643(ETHEntity@ Asteroide643)
	{
	vector2 TamanhoTela = GetScreenSize();
	vector2 DirecaoAsteroide(0, 1);
	float VelocidadeAsteroide = UnitsPerSecond(100);
	Asteroide643.AddToPositionXY(DirecaoAsteroide * (VelocidadeAsteroide * 2));
	vector2 PosicaoAsteroide = Asteroide643.GetPositionXY();
		
	// Colisao Asteroide e Missel

	ETHEntityArray Outras;

	if(Collide(Asteroide643, Outras) == true)
		{
		for(uint i = 0; i < Outras.size(); i++)
			{
			if(Outras[i].GetEntityName() == "Missel.ent")
				{
				DeleteEntity(Outras[i]);
				AddEntity("ExplosaoAsteroide.ent", Outras[i].GetPosition());
				
				Asteroide643.AddToInt("VidaAsteroide", -1);
				
				if(Asteroide643.GetInt("VidaAsteroide") == 0)
					{
					AddEntity("ExplosaoAsteroide.ent", Asteroide643.GetPosition());
					DeleteEntity(Asteroide643);
					PlaySample("soundfx/asteroid_explosion.mp3");
					Pontos = Pontos + 30;
					}
				}

			else if(Outras[i].GetEntityName() == "Heroi.ent")
				{
				//PlaySample("soundfx/asteroid_explosion.mp3");
				PlaySample("soundfx/hit.wav");
				AddEntity("ExplosaoAsteroide.ent", Outras[i].GetPosition());
				DeleteEntity(Asteroide643);

				if(Vida <= 0)
					{
					StopSample("soundfx/musica.mp3");
					LoadScene("scenes/GameOver.esc", "StartGameOver", "UpdateGameOver");
					}
				else
					{
					Vida = Vida - 30;
					}
				}
			}
		}
			
	if(PosicaoAsteroide.y > TamanhoTela.y + 64)
		{
		@Asteroide643 = DeleteEntity(Asteroide643);
		}

	}

//------------------------------------------------------------------------------------------

void ETHCallback_HealthBar(ETHEntity@ HealthBar)
	{
	if(Vida == 90)
		{
		HealthBar.SetScale(vector2(0.9f, 1.0f));
		}
	if(Vida == 80)
		{
		HealthBar.SetScale(vector2(0.8f, 1.0f));
		}
	if(Vida == 70)
		{
		HealthBar.SetScale(vector2(0.7f, 1.0f));
		}
	if(Vida == 60)
		{
		HealthBar.SetScale(vector2(0.6f, 1.0f));
		}
	if(Vida == 50)
		{
		HealthBar.SetScale(vector2(0.5f, 1.0f));
		}
	if(Vida == 40)
		{
		HealthBar.SetScale(vector2(0.4f, 1.0f));
		}
	if(Vida == 30)
		{
		HealthBar.SetScale(vector2(0.4f, 1.0f));
		}
	if(Vida == 20)
		{
		HealthBar.SetScale(vector2(0.2f, 1.0f));
		}
	if(Vida == 10)
		{
		HealthBar.SetScale(vector2(0.1f, 1.0f));
		}
	}