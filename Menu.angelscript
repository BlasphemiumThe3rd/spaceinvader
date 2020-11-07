#include "Button.angelscript"

vector2 TamanhoTelaMenu = GetScreenSize();
						
float MetadeTelaMenuX = (TamanhoTelaMenu.x / 2) - 256;
float MetadeTelaMenuY = (TamanhoTelaMenu.y / 2) - 300;

// Inicia a Instância do Botao, mas ainda não joga na tela
Button IniciarJogo("entities/start-game.png", vector2(256, MetadeTelaMenuY + 450));

// OnSceneCreated
void StartMenu()
	{
	LoadMusic("soundfx/menu.mp3");
	PlaySample("soundfx/menu.mp3");
	LoopSample("soundfx/menu.mp3", true);
	
	vector2 PosicaoBotaoStart = GetScreenSize();
	//IniciarJogo.setPos(PosicaoBotaoStart / 2.0f);
	}

// OnSceneUpdate
void UpdateMenu()
	{				
	DrawSprite("entities/title.png", vector2(MetadeTelaMenuX, MetadeTelaMenuY), 0xFFFFFFFF);
	IniciarJogo.putButton();
	ETHInput@ input = GetInputHandle();
	
	if(IniciarJogo.isPressed())
		{
		StopSample("soundfx/menu.mp3");
		Vida = 100;
		LoadScene("scenes/Cena1.esc", "startGame", "UpdateGame", "MoveCamera");
		IniciarJogo.setPressed(false);
		}
		
	if(input.KeyDown(K_ESC))
		{
		Exit();
		}
	}